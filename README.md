# MCU Rewatch — Road to Doomsday

App nativa iOS (SwiftUI + SwiftData). Maratón completo del MCU con sistema de
tres estados independientes, dos modos de recorrido y countdown en vivo hasta
**Avengers: Doomsday (18 de diciembre de 2026)**.

## ⚠️ Por qué no incluyo un .xcodeproj

Genero este proyecto desde un entorno Linux sin Xcode instalado, así que no puedo
compilar ni generar de forma fiable el `.xcodeproj` binario. Te doy todos los
`.swift` ya organizados en carpetas — montar el proyecto en Xcode lleva 2 minutos.

## Pasos en Xcode (macOS) — ÚNICO paso manual obligatorio

1. Xcode → **File → New → Project → iOS → App**.
2. Nombre del producto: `MCURewatch`. Interface: **SwiftUI**. Language: **Swift**.
3. **Deployment target: iOS 17.0 o superior** (obligatorio: usa `@Model`, `@Bindable`,
   `ImageRenderer`, `NavigationStack`).
4. Borra el `ContentView.swift` y `MCURewatchApp.swift` que genera Xcode por defecto.
5. Arrastra a tu proyecto las carpetas `Models/`, `Views/`, `ViewModels/`, `Data/`,
   `Persistence/`, `Components/`, `Services/` y el archivo `MCURewatchApp.swift`
   de este paquete. Marca "Copy items if needed" y "Create groups".
6. Conecta tu iPhone por cable/red, selecciónalo como destino en Xcode (⌘R),
   y en el iPhone: Ajustes → General → VPN y gestión de dispositivos → confía
   en tu certificado de desarrollador la primera vez.
7. Compila (⌘R). No hay nada más que configurar: sin API keys, sin backend,
   sin capacidades especiales que activar.

## Qué se ha creado/modificado en esta iteración

| Archivo | Cambio |
|---|---|
| `Models/MCUTitle.swift` | **Reescrito.** Sistema de 3 estados independientes (`isSeenBefore`/`seenBeforeDate`, `isRewatchedDoomsday`/`rewatchDate`), `ContentCategory`, `MaratonMode`, `WatchState` |
| `Data/MCUDatabase.swift` | **Reescrito.** 93 títulos auditados (65 núcleo + 1 nodo final + 12 Multiverse + 13 Defenders + 2 Agent Carter), `releaseOrder` recalculado por categoría |
| `Persistence/PersistenceController.swift` | Sin cambios de fondo — sigue sembrando solo si la base está vacía |
| `Services/DoomsdayCalculator.swift` | Actualizado: excluye el nodo final del cálculo de pendientes, usa `isRewatchedDoomsday` como criterio de "completado" |
| `Services/RoadmapImageGenerator.swift` | Sin cambios |
| `ViewModels/RoadmapViewModel.swift` | **Reescrito.** Modo (`roadToDoomsday`/`mcuCompleto`), toggles de Multiverse/Defenders/Agent Carter, acciones `markSeenBefore`/`markRewatch`/`unmarkSeen`/`unmarkRewatch` |
| `ViewModels/ChecklistViewModel.swift` | **Reescrito.** Filtros de estado (No vistas/Vistas anteriormente/Rewatch/Pendientes de Rewatch) + tipo |
| `Components/RoadmapNodeView.swift` | **Reescrito.** Nodo con los 3 estados visuales (⚪🟢🔥) + candado si no estrenada |
| `Components/PosterView.swift` | Actualizado al nuevo campo `category` (antes `universe`) |
| `Components/FinalDestinationCardView.swift` | Actualizado con countdown en vivo integrado |
| `Components/ProgressBarView.swift` | Sin cambios |
| `Views/TitleDetailView.swift` | **Nuevo.** Ficha de detalle con los dos botones de acción y resumen de ambos estados |
| `Views/RoadToDoomsdayView.swift` | **Reescrito.** Selector de modo, toggles de contenido opcional, roadmap filtrado por modo |
| `Views/ChecklistView.swift` | **Reescrito.** Filtros nuevos + botón de acción rápida inline por fila |
| `Views/StatsView.swift` | **Reescrito.** Separado en "Mi Historial" y "Road to Doomsday" |
| `Views/ContentView.swift` | Actualizado: comparte un único `RoadmapViewModel` entre las 3 pestañas (así el modo/toggles no se pierden al cambiar de pestaña) |
| `MCURewatchApp.swift` | Sin cambios |

## Los dos modos

- **🔥 Road to Doomsday**: MCU núcleo (65) + Multiverse automático (12) + nodo final. Sin toggles — Defenders y Agent Carter nunca aparecen aquí.
- **🏆 MCU Completo**: MCU núcleo siempre + Multiverse/Defenders/Agent Carter mediante toggle independiente (todos apagados por defecto).

## Sistema de 3 estados (persistido en SwiftData, campos independientes)

`isSeenBefore` + `seenBeforeDate` por un lado, `isRewatchedDoomsday` + `rewatchDate`
por otro. Marcar Rewatch activa automáticamente "vista anteriormente" si no lo estaba;
desmarcar "vista anteriormente" resetea también el rewatch (no puede haber rewatch
de algo no visto). Puedes tocar el botón desde la ficha de detalle o desde el
botón de acción rápida en cada fila de la lista, sin entrar a la ficha.

## Pendiente para una futura sesión (fuera de alcance ahora, no lo he tocado)

Para un **segundo maratón futuro** (p. ej. hacia *Secret Wars*) sin perder el
historial de este, la vía más limpia sería migrar `isRewatchedDoomsday`/`rewatchDate`
a una entidad `RewatchCampaign` con relación uno-a-muchos. Ahora mismo el modelo
soporta un único ciclo de rewatch activo ("Doomsday"), tal y como pediste; lo dejo
anotado aquí para cuando quieras ese salto.

## Datos: 93 títulos auditados

Ver desglose completo por fase/categoría en el histórico de esta conversación.
Verificación cruzada por script (no transcripción manual) antes de generar el código.
