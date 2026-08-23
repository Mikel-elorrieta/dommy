# Compilar e instalar SIN Mac (desde Windows)

Dos fases: 1) GitHub compila el `.ipa` en un Mac virtual gratis. 2) Sideloadly
(en tu Windows) lo instala en tu iPhone por cable, usando tu Apple ID gratuito.
No necesitas Xcode, no necesitas Mac, no necesitas pagar los 99$/año de Apple.

## Fase 1 — Compilar en GitHub Actions

1. Ve a [github.com/new](https://github.com/new) y crea un repositorio (puede ser privado).
2. Sube el contenido de este zip al repo. Formas más fáciles sin usar `git` desde
   terminal: en la página del repo → **Add file → Upload files** → arrastra
   TODAS las carpetas y archivos (incluida la carpeta oculta `.github`).
   ⚠️ Asegúrate de que `.github/workflows/build-ipa.yml` y `project.yml` quedan
   en la raíz del repo, no dentro de una subcarpeta `MCURewatch/`.
3. Ve a la pestaña **Actions** del repo. Si te pregunta si quieres habilitar
   Actions, acepta.
4. Debería aparecer un workflow llamado **"Build unsigned IPA"**. Si no se
   lanzó solo, entra en él y pulsa **Run workflow** (botón a la derecha).
5. Espera ~5-10 minutos (compila un Mac virtual desde cero). Verás un ✅ verde
   cuando termine.
6. Entra en esa ejecución → baja hasta **Artifacts** → descarga
   `MCURewatch-unsigned-ipa` (es un .zip que contiene el `.ipa` dentro).

## Fase 2 — Instalar en tu iPhone con Sideloadly (Windows)

1. Descarga **Sideloadly** desde [sideloadly.io](https://sideloadly.io) (versión Windows).
2. Instala también **iTunes** (o Apple Devices desde Microsoft Store) — Sideloadly
   lo necesita para hablar con el iPhone por USB.
3. Conecta el iPhone al PC por cable. La primera vez el iPhone te pedirá
   "Confiar en este ordenador" — acepta.
4. Abre Sideloadly. Arriba a la derecha debería reconocer tu iPhone.
5. Arrastra el archivo `MCURewatch-unsigned.ipa` (el que descargaste de GitHub,
   descomprimido) al centro de la ventana de Sideloadly.
6. Te pedirá tu Apple ID y contraseña — es el mismo que usas en el iPhone,
   normal y gratuito (NO hace falta cuenta de pago). Sideloadly lo usa solo
   para firmar la app localmente, no sube nada a Apple más allá de lo normal
   de cualquier instalación de desarrollo.
7. Pulsa **Start**. Instalará la app en el iPhone.
8. En el iPhone: **Ajustes → General → VPN y gestión de dispositivos** → toca
   tu Apple ID → **Confiar**. Sin este paso el icono de la app da error al abrir.
9. Abre "MCU Rewatch" desde la pantalla de inicio.

## Limitación del método gratuito

Con Apple ID gratuito (sin pagar cuenta de desarrollador), la app deja de
funcionar a los **7 días** y hay que repetir la Fase 2 (Sideloadly puede
dejarse abierto en segundo plano para re-firmar automáticamente cada semana
si el PC está encendido y conectado). El progreso guardado en la app
(SwiftData) **no se pierde** al reinstalar de esta forma siempre que no
borres la app del todo entre medias.

## Si algo falla en GitHub Actions

Pégame el error exacto del log (pestaña Actions → la ejecución en rojo ❌ →
abre el paso que falló) y lo arreglo. Lo más probable si falla algo es una
ruta o nombre de escena que XcodeGen no encuentra — nada relacionado con la
base de datos ni la lógica de la app.
