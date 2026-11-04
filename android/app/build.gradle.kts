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
        applicationId = "com.trainloop.app"
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
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
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
        val props = java.util.Properties()
        local.inputStream().use { props.load(it) }
        props.getProperty(key)?.takeIf { it.isNotBlank() }?.let { return it }
    }
    return testId
}

dependencies {
    // Pruebas JVM del motor y del punto de recuperación (android/app/src/test).
    testImplementation("junit:junit:4.13.2")
    // android.jar solo trae stubs de org.json: las pruebas usan la implementación real.
    testImplementation("org.json:json:20240303")
}
