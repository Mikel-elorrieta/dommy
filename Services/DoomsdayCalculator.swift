import Foundation

struct DoomsdayStats {
    let daysRemaining: Int
    let hoursRemaining: Int
    let titlesRemaining: Int
    let minutesRemaining: Int
    let titlesPerWeekNeeded: Double
    let hoursPerWeekNeeded: Double
    let isReady: Bool
}

enum DoomsdayCalculator {

    /// 18 de diciembre de 2026 — fecha oficial confirmada de Avengers: Doomsday.
    static var doomsdayReleaseDate: Date {
        var c = DateComponents()
        c.year = 2026; c.month = 12; c.day = 18
        c.timeZone = TimeZone(identifier: "UTC")
        return Calendar(identifier: .gregorian).date(from: c)!
    }

    /// `titles` debe ser el conjunto YA FILTRADO por modo/toggles activos,
    /// SIN el nodo final (Doomsday nunca cuenta como "pendiente normal").
    static func stats(for titles: [MCUTitle], now: Date = Date()) -> DoomsdayStats {
        let relevant = titles.filter { $0.category != .finalDestination }
        let pending = relevant.filter { !$0.isRewatchedDoomsday }

        let secondsRemaining = max(0, doomsdayReleaseDate.timeIntervalSince(now))
        let daysRemaining = Int(secondsRemaining / 86400)
        let hoursRemaining = Int(secondsRemaining / 3600)
        let weeksRemaining = max(secondsRemaining / (86400 * 7), 1.0 / 7.0)

        let minutesRemaining = pending.reduce(0) { $0 + $1.runtimeMinutes }
        let titlesPerWeek = Double(pending.count) / weeksRemaining
        let hoursPerWeek = (Double(minutesRemaining) / 60.0) / weeksRemaining

        return DoomsdayStats(
            daysRemaining: daysRemaining,
            hoursRemaining: hoursRemaining,
            titlesRemaining: pending.count,
            minutesRemaining: minutesRemaining,
            titlesPerWeekNeeded: titlesPerWeek,
            hoursPerWeekNeeded: hoursPerWeek,
            isReady: pending.isEmpty
        )
    }
}
