import java.util.Base64
import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.trainloop.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.gonisoma.trainloop"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 26
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        // App ID de AdMob (D8). Por defecto el ID de PRUEBA oficial de Google;
        // el real se pasa sin tocar código: `-PTL_ADMOB_APP_ID=ca-app-pub-…~…`,
        // la variable de entorno TL_ADMOB_APP_ID o una línea en
        // android/local.properties (no se versiona). Ver README, «Anuncios».
        manifestPlaceholders["admobAppId"] = admobAppId()
        // Recorridos de integration_test/ como prueba instrumentada (D9).
        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
    }

    // Firma de release (D9): android/key.properties o variables de entorno
    // (ver README, «Build de release»). Sin llave, se firma con la de
    // depuración y se avisa: sirve para probar, nunca para Play.
    val upload = uploadKey()
    signingConfigs {
        if (upload != null) {
            create("release") {
                storeFile = file(upload.getValue("storeFile"))
                storePassword = upload.getValue("storePassword")
                keyAlias = upload.getValue("keyAlias")
                keyPassword = upload.getValue("keyPassword")
            }
        }
    }

    buildTypes {
        release {
            signingConfig = if (upload != null) {
                signingConfigs.getByName("release")
            } else {
                logger.warn(
                    "Trainloop: sin android/key.properties ni TL_KEYSTORE_*; " +
                        "el release se firma con la llave de DEPURACIÓN (no sirve para Play).",
                )
                signingConfigs.getByName("debug")
            }
            // R8: reduce y ofusca el código y quita recursos sin uso (NF-11).
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )
        }
    }
}

flutter {
    source = "../.."
}

/** App ID de AdMob: propiedad de Gradle, entorno, local.properties o el de prueba. */
fun admobAppId(): String {
    val testId = "ca-app-pub-3940256099942544~3347511713"
    val key = "TL_ADMOB_APP_ID"
    (project.findProperty(key) as String?)?.takeIf { it.isNotBlank() }?.let { return it }
    System.getenv(key)?.takeIf { it.isNotBlank() }?.let { return it }
    val local = rootProject.file("local.properties")
    if (local.exists()) {
        val props = Properties()
        local.inputStream().use { props.load(it) }
        props.getProperty(key)?.takeIf { it.isNotBlank() }?.let { return it }
    }
    return testId
}

/**
 * Llave de subida: `android/key.properties` (no se versiona) o las variables
 * TL_KEYSTORE_PATH, TL_KEYSTORE_PASSWORD, TL_KEY_ALIAS y TL_KEY_PASSWORD
 * (CI). `null` si falta alguna.
 */
fun uploadKey(): Map<String, String>? {
    val file = rootProject.file("key.properties")
    val values = if (file.exists()) {
        val props = Properties()
        file.inputStream().use { props.load(it) }
        mapOf(
            "storeFile" to props.getProperty("storeFile"),
            "storePassword" to props.getProperty("storePassword"),
            "keyAlias" to props.getProperty("keyAlias"),
            "keyPassword" to props.getProperty("keyPassword"),
        )
    } else {
        mapOf(
            "storeFile" to System.getenv("TL_KEYSTORE_PATH"),
            "storePassword" to System.getenv("TL_KEYSTORE_PASSWORD"),
            "keyAlias" to System.getenv("TL_KEY_ALIAS"),
            "keyPassword" to System.getenv("TL_KEY_PASSWORD"),
        )
    }
    if (values.values.any { it.isNullOrBlank() }) return null
    return values.mapValues { it.value!! }
}

/** `--dart-define` que Flutter pasa a Gradle (cada uno en base64). */
fun dartDefines(): Map<String, String> {
    val raw = project.findProperty("dart-defines")?.toString() ?: return emptyMap()
    return raw.split(",").filter { it.isNotBlank() }.mapNotNull { encoded ->
        val decoded = try {
            String(Base64.getDecoder().decode(encoded))
        } catch (_: IllegalArgumentException) {
            return@mapNotNull null
        }
        val i = decoded.indexOf('=')
        if (i <= 0) null else decoded.substring(0, i) to decoded.substring(i + 1)
    }.toMap()
}

/**
 * Guarda de release (deuda 6 de D8): un build de release con los IDs de
 * PRUEBA de AdMob falla, salvo con TL_ALLOW_TEST_ADS=true (CI y pruebas
 * internas) o sin anuncios (`--dart-define=TL_ADS=off`). Revisa el App ID
 * (Gradle) y los bloques del banner y del intersticial (dart-define).
 */
val verifyReleaseAdIds by tasks.registering {
    group = "verification"
    description = "Falla si un release usa los IDs de prueba de AdMob."
    val allow = ((project.findProperty("TL_ALLOW_TEST_ADS") as String?)
        ?: System.getenv("TL_ALLOW_TEST_ADS")) == "true"
    val defines = dartDefines()
    val appId = admobAppId()
    doLast {
        if (allow || defines["TL_ADS"] == "off") {
            logger.warn("Trainloop: release con IDs de prueba de AdMob permitido (TL_ALLOW_TEST_ADS o TL_ADS=off).")
            return@doLast
        }
        val testPublisher = "ca-app-pub-3940256099942544"
        val problems = buildList {
            if (appId.startsWith(testPublisher)) add("App ID (TL_ADMOB_APP_ID)")
            for (key in listOf("TL_ADMOB_BANNER_ID", "TL_ADMOB_INTERSTITIAL_ID")) {
                val v = defines[key]
                if (v.isNullOrBlank() || v.startsWith(testPublisher)) add("$key (--dart-define)")
            }
        }
        if (problems.isNotEmpty()) {
            throw GradleException(
                "Release con IDs de PRUEBA de AdMob: ${problems.joinToString()}. " +
                    "Pasa los reales (README, «Anuncios») o, solo para pruebas, " +
                    "TL_ALLOW_TEST_ADS=true.",
            )
        }
    }
}

tasks.matching { it.name == "preReleaseBuild" }.configureEach {
    dependsOn(verifyReleaseAdIds)
}

dependencies {
    // Pruebas JVM del motor y del punto de recuperación (android/app/src/test).
    testImplementation("junit:junit:4.13.2")
    // android.jar solo trae stubs de org.json: las pruebas usan la implementación real.
    testImplementation("org.json:json:20240303")
    // integration_test en Firebase Test Lab (tool/test_lab.sh). Las mismas
    // versiones que trae el plugin integration_test (resolución consistente).
    androidTestImplementation("androidx.test:runner:1.2.0")
    androidTestImplementation("androidx.test:rules:1.2.0")
    androidTestImplementation("androidx.test.espresso:espresso-core:3.2.0")
}
