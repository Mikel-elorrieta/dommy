import SwiftUI

struct FinalDestinationCardView: View {
    let title: MCUTitle?
    /// Conjunto de títulos ACTIVO (mismo que usa el roadmap y el countdown de
    /// cabecera: MCU núcleo + categorías con toggle activado, según el modo).
    /// Nunca incluye el nodo final — DoomsdayCalculator ya lo excluye también
    /// como salvaguarda por si algún día se pasa por error.
    let activeTitles: [MCUTitle]
    let completed: Int
    let total: Int

    private var stats: DoomsdayStats {
        DoomsdayCalculator.stats(for: activeTitles)
    }

    var body: some View {
        VStack(spacing: 14) {
            Text("Tu camino hasta Doomsday")
                .font(.caption.weight(.bold))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)

            ZStack {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color(red: 0.35, green: 0.02, blue: 0.02), Color.black],
                            startPoint: .top, endPoint: .bottom
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .stroke(
                                LinearGradient(colors: [.red, .orange, .yellow], startPoint: .leading, endPoint: .trailing),
                                lineWidth: 2
                            )
                    )
                    .shadow(color: .red.opacity(0.4), radius: 20, y: 8)

                VStack(spacing: 10) {
                    Text("💥")
                        .font(.system(size: 44))
                    Text("AVENGERS: DOOMSDAY")
                        .font(.title2.weight(.heavy))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                    Text("18 DICIEMBRE 2026")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.7))

                    countdownGrid

                    if completed == total && total > 0 {
                        Text("🎉 ESTÁS PREPARADO PARA DOOMSDAY")
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(.yellow)
                            .padding(.top, 6)
                    } else if let title, title.isRewatchedDoomsday {
                        Text("VISTA ✓")
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(.green)
                    }
                }
                .padding(24)
            }
            .frame(maxWidth: .infinity)
            .frame(minHeight: 280)

            Text("\(completed) / \(total) títulos completados")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal)
    }

    private var countdownGrid: some View {
        let s = stats
        return VStack(spacing: 6) {
            HStack(spacing: 16) {
                miniStat("\(s.daysRemaining)", "días")
                miniStat("\(s.titlesRemaining)", "títulos")
                miniStat("\(s.minutesRemaining / 60)", "horas rest.")
            }
            HStack(spacing: 16) {
                miniStat(String(format: "%.1f", s.titlesPerWeekNeeded), "títulos/sem")
                miniStat(formattedHours(s.hoursPerWeekNeeded), "por semana")
            }
        }
        .padding(.top, 2)
    }

    private func miniStat(_ value: String, _ label: String) -> some View {
        VStack(spacing: 1) {
            Text(value).font(.subheadline.weight(.bold)).foregroundStyle(.yellow)
            Text(label).font(.system(size: 9)).foregroundStyle(.white.opacity(0.6))
        }
    }

    private func formattedHours(_ hours: Double) -> String {
        let h = Int(hours)
        let m = Int((hours - Double(h)) * 60)
        return "\(h)h\(m)m"
    }
}
