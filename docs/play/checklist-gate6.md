# Checklist del Gate 6 (D10, publicación)

Criterio de `docs/arquitectura.md` (fila 10):
- ficha de Play en 3 idiomas;
- política de privacidad;
- declaración del servicio en primer plano;
- prueba cerrada con ≥ 12 testers durante 14 días.

Para aprobar el gate hacen falta la revisión de Play, la beta cerrada cumplida y este checklist completo.

Estados: **listo** · **pendiente Gestión** · **pendiente Legal** · **pendiente teléfono real** · **pendiente Play**.

## Ficha y recursos

| Ítem | Estado | Doc |
|---|---|---|
| Título, descripción corta y completa en es-419, en-US y pt-BR, dentro de los límites | listo (revisar tono: Gestión) | `fastlane/metadata/android/`, `test/tool/play_metadata_test.dart` |
| Novedades del `versionCode` 2 | listo | `fastlane/metadata/android/<locale>/changelogs/2.txt` |
| Ícono 512 × 512 | listo | `docs/play/icon-512.png` |
| Gráfico destacado 1024 × 500 | listo (la línea está solo en es; versión en/pt opcional) | `docs/play/feature-graphic.png` |
| Capturas de teléfono: 5 por idioma (Inicio, Entrenar, intervalos en curso, fuerza con «Igual que antes» y Progreso) | listo | `fastlane/metadata/android/<locale>/images/phoneScreenshots/` |
| Símbolo de marca suavizado: hoy está calcado con segmentos rectos, conviene redibujarlo con curvas en Figma y volver a exportar el ícono, el gráfico y el adaptativo | pendiente Gestión (diseño) | `docs/play/icon-512.svg` |
| Categoría Salud y fitness, correo y sitio de contacto | pendiente Gestión | `docs/play/cuestionarios.md` §5 |

## Políticas y formularios

| Ítem | Estado | Doc |
|---|---|---|
| Política de privacidad (borrador es/en) | pendiente Legal | `docs/play/politica-privacidad.md` |
| Política alojada en una URL pública (HTML listo, sin publicar) | pendiente Gestión | `docs/play/privacy/index.html` |
| Seguridad de los datos | pendiente Legal | `docs/data-safety.md` |
| Declaración FGS `specialUse` (texto es/en, propiedad en el manifiesto) | listo | `docs/play/declaracion-fgs.md` |
| Video de 30 s del FGS | pendiente teléfono real | `docs/play/declaracion-fgs.md` (guion) |
| Clasificación IARC | pendiente Gestión (enviar) | `docs/play/cuestionarios.md` §1 |
| Público objetivo 13+ (sin Familias) | pendiente Gestión y Legal (decisión) | `docs/play/cuestionarios.md` §2 |
| Anuncios: sí, e ID de publicidad para publicidad | pendiente Gestión (enviar) | `docs/play/cuestionarios.md` §3 |
| Acceso a la app sin cuenta | listo | `docs/play/cuestionarios.md` §4 |
| Declaración de apps de salud | pendiente Legal | `docs/play/cuestionarios.md` §5 |
| Mensaje de consentimiento UMP en AdMob (es/en/pt) | pendiente Gestión y Legal | `docs/data-safety.md` §4 |

## Build y cuentas

| Ítem | Estado | Doc |
|---|---|---|
| `version: 1.0.0+2` | listo | `pubspec.yaml`, `docs/play/release.md` |
| El AAB compila (con `TL_ALLOW_TEST_ADS=true`) | listo | `docs/play/release.md` («Estado») |
| Cuenta de Play Console | pendiente Gestión | `docs/play/release.md` §5 |
| Llave de subida y `key.properties` | pendiente Gestión | `docs/play/release.md` §1–2 |
| IDs reales de AdMob (app, banner, intersticial) | pendiente Gestión | `docs/play/release.md` §3 |
| AAB firmado con IDs reales | pendiente Gestión | `docs/play/release.md` §4 |
| Play App Signing | pendiente Play | `docs/play/release.md` §5 |
| Producto `trainloop_remove_ads` y precio | pendiente Gestión | `docs/play/release.md` §6 |
| Decisión del intersticial en la beta (`TL_INTERSTITIAL`) | pendiente Gestión | README, «Anuncios» |
| Proveedor de errores y analítica (o lanzar sin él) | pendiente Gestión | `docs/pruebas-estabilidad.md` §6 |

## Pruebas y lanzamiento

| Ítem | Estado | Doc |
|---|---|---|
| Prueba interna: instalación, compra de prueba, UMP, banner real | pendiente Play | `docs/play/release.md` §7.1 |
| Bloque en teléfono real (NF-02, NF-03 60 min, NF-10, raster S05, T-03/T-04, voz) | pendiente teléfono real | `docs/pruebas-estabilidad.md` §4 |
| Prueba cerrada: ≥ 12 testers durante 14 días (invitación y registro listos) | pendiente Gestión y Play | `docs/play/release.md` §7.2 |
| Revisión de Play aprobada | pendiente Play | — |
| Acceso a producción y lanzamiento escalonado | pendiente Play | `docs/play/release.md` §7.3 |

## Deuda abierta que llega al Gate 6

Viene de D9 (`docs/pruebas-estabilidad.md` §5). Ninguna bloquea la prueba interna. La de teléfono real debe cerrarse antes de producción.

- **D9:**
  - medir en teléfono NF-02, NF-03 (60 min), NF-10 y el raster de S05;
  - Test Lab sin correr;
  - el banner reintenta sin escuchar la conectividad;
  - `classes.dex` pesa 5,9 MB.
- **D4** (`docs/pruebas-temporizador.md`):
  - T-03, T-04 y voz en teléfono real;
  - sin implementar: «pausar en llamadas», «solo vibración», aviso de mitad y pantalla encendida.
- **D5** (`docs/pruebas-fuerza.md`):
  - reemplazar ejercicio (R-G9), distancia (R-G5) y R-G15;
  - «repetir» intervalos;
  - S10 con TalkBack.
- **D6** (`docs/pruebas-historial.md`):
  - casos de varias semanas;
  - pruebas de widgets de S12–S15;
  - F-12 (P2).
- **D7** (`docs/pruebas-experiencia.md`):
  - TalkBack con gestos reales;
  - pantallas al 200 %;
  - restauración en el hilo principal;
  - recordatorios en teléfono.
- **D8** (`docs/pruebas-monetizacion.md`):
  - analítica y TCF;
  - compra real;
  - `getAnchoredAdaptiveBannerAdSize` obsoleto;
  - `tagForUnderAgeOfConsent`;
  - mensaje único de Play.
- **UX** (`docs/ux-sesion-en-curso.md`):
  - la notificación no reabre la sesión si la persona ya había salido de ella;
  - falta la prueba del flujo «terminar intervalos» desde la barra.
- **D10:**
  - el video del FGS no se grabó;
  - el gráfico destacado tiene la línea solo en es;
  - en las capturas en/pt la rutina de demostración se llama «Empuje»;
  - el texto de la ficha no lo revisó un hablante nativo de pt-BR.
