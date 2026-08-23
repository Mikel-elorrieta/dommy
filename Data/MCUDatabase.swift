import Foundation

/// Fuente de verdad de todos los titulos, separada de la UI.
///
/// Estos 93 titulos y sus categorias fueron auditados automaticamente
/// (conteo por script, sin transcripcion manual) antes de generar este
/// archivo. Ver /areas/mcu-rewatch-app.md para el historial de la auditoria.
///
/// Categorias:
/// - mcuCore (65): pelis + series + especiales + one-shots del MCU principal
/// - finalDestination (1): Avengers: Doomsday, nodo final especial del roadmap
/// - multiverse (12): X-Men / Deadpool / Logan / 4 Fantasticos (Fox)
/// - defenders (13): Daredevil/Jessica Jones/Luke Cage/Iron Fist/Defenders/Punisher (Netflix, canon confirmado)
/// - agentCarter (2): serie Agent Carter, opcional
enum MCUDatabase {

    private static func date(_ y: Int, _ m: Int, _ d: Int) -> Date {
        var c = DateComponents()
        c.year = y; c.month = m; c.day = d
        c.timeZone = TimeZone(identifier: "UTC")
        return Calendar(identifier: .gregorian).date(from: c)!
    }

    static func seedTitles() -> [MCUTitle] {
        var all: [MCUTitle] = [
            // MARK: - mcu_core (65) 
        .init(id: "iron-man", title: "Iron Man", releaseDate: date(2008,5,2), mediaType: .movie, phase: .phase1, category: .mcuCore, runtimeMinutes: 126, releaseOrder: 0),
        .init(id: "incredible-hulk", title: "El Increíble Hulk", releaseDate: date(2008,6,13), mediaType: .movie, phase: .phase1, category: .mcuCore, runtimeMinutes: 112, releaseOrder: 0),
        .init(id: "iron-man-2", title: "Iron Man 2", releaseDate: date(2010,5,7), mediaType: .movie, phase: .phase1, category: .mcuCore, runtimeMinutes: 124, releaseOrder: 0),
        .init(id: "thor", title: "Thor", releaseDate: date(2011,5,6), mediaType: .movie, phase: .phase1, category: .mcuCore, runtimeMinutes: 115, releaseOrder: 0),
        .init(id: "captain-america-first-avenger", title: "Capitán América: El Primer Vengador", releaseDate: date(2011,7,22), mediaType: .movie, phase: .phase1, category: .mcuCore, runtimeMinutes: 124, releaseOrder: 0),
        .init(id: "one-shot-consultant", title: "The Consultant", releaseDate: date(2011,9,13), mediaType: .special, phase: .phase1, category: .mcuCore, runtimeMinutes: 4, releaseOrder: 0),
        .init(id: "one-shot-funny-thing", title: "A Funny Thing Happened on the Way to Thor's Hammer", releaseDate: date(2011,10,25), mediaType: .special, phase: .phase1, category: .mcuCore, runtimeMinutes: 4, releaseOrder: 0),
        .init(id: "the-avengers", title: "Los Vengadores", releaseDate: date(2012,5,4), mediaType: .movie, phase: .phase1, category: .mcuCore, runtimeMinutes: 143, releaseOrder: 0),
        .init(id: "one-shot-item-47", title: "Item 47", releaseDate: date(2012,9,25), mediaType: .special, phase: .phase1, category: .mcuCore, runtimeMinutes: 12, releaseOrder: 0),
        .init(id: "iron-man-3", title: "Iron Man 3", releaseDate: date(2013,5,3), mediaType: .movie, phase: .phase2, category: .mcuCore, runtimeMinutes: 130, releaseOrder: 0),
        .init(id: "one-shot-agent-carter", title: "Agent Carter (One-Shot)", releaseDate: date(2013,9,3), mediaType: .special, phase: .phase2, category: .mcuCore, runtimeMinutes: 15, releaseOrder: 0),
        .init(id: "thor-dark-world", title: "Thor: Un Mundo Oscuro", releaseDate: date(2013,11,8), mediaType: .movie, phase: .phase2, category: .mcuCore, runtimeMinutes: 112, releaseOrder: 0),
        .init(id: "one-shot-all-hail-king", title: "All Hail the King", releaseDate: date(2014,2,4), mediaType: .special, phase: .phase2, category: .mcuCore, runtimeMinutes: 15, releaseOrder: 0),
        .init(id: "captain-america-winter-soldier", title: "Capitán América: El Soldado de Invierno", releaseDate: date(2014,4,4), mediaType: .movie, phase: .phase2, category: .mcuCore, runtimeMinutes: 136, releaseOrder: 0),
        .init(id: "guardians-galaxy", title: "Guardianes de la Galaxia", releaseDate: date(2014,8,1), mediaType: .movie, phase: .phase2, category: .mcuCore, runtimeMinutes: 121, releaseOrder: 0),
        .init(id: "avengers-age-of-ultron", title: "Vengadores: La Era de Ultrón", releaseDate: date(2015,5,1), mediaType: .movie, phase: .phase2, category: .mcuCore, runtimeMinutes: 141, releaseOrder: 0),
        .init(id: "ant-man", title: "Ant-Man", releaseDate: date(2015,7,17), mediaType: .movie, phase: .phase2, category: .mcuCore, runtimeMinutes: 117, releaseOrder: 0),
        .init(id: "captain-america-civil-war", title: "Capitán América: Civil War", releaseDate: date(2016,5,6), mediaType: .movie, phase: .phase3, category: .mcuCore, runtimeMinutes: 147, releaseOrder: 0),
        .init(id: "doctor-strange", title: "Doctor Strange", releaseDate: date(2016,11,4), mediaType: .movie, phase: .phase3, category: .mcuCore, runtimeMinutes: 115, releaseOrder: 0),
        .init(id: "gotg-vol-2", title: "Guardianes de la Galaxia Vol. 2", releaseDate: date(2017,5,5), mediaType: .movie, phase: .phase3, category: .mcuCore, runtimeMinutes: 136, releaseOrder: 0),
        .init(id: "spiderman-homecoming", title: "Spider-Man: Homecoming", releaseDate: date(2017,7,7), mediaType: .movie, phase: .phase3, category: .mcuCore, runtimeMinutes: 133, releaseOrder: 0),
        .init(id: "thor-ragnarok", title: "Thor: Ragnarok", releaseDate: date(2017,11,3), mediaType: .movie, phase: .phase3, category: .mcuCore, runtimeMinutes: 130, releaseOrder: 0),
        .init(id: "black-panther", title: "Black Panther", releaseDate: date(2018,2,16), mediaType: .movie, phase: .phase3, category: .mcuCore, runtimeMinutes: 134, releaseOrder: 0),
        .init(id: "avengers-infinity-war", title: "Vengadores: Infinity War", releaseDate: date(2018,4,27), mediaType: .movie, phase: .phase3, category: .mcuCore, runtimeMinutes: 149, releaseOrder: 0),
        .init(id: "ant-man-wasp", title: "Ant-Man y la Avispa", releaseDate: date(2018,7,6), mediaType: .movie, phase: .phase3, category: .mcuCore, runtimeMinutes: 118, releaseOrder: 0),
        .init(id: "captain-marvel", title: "Capitana Marvel", releaseDate: date(2019,3,8), mediaType: .movie, phase: .phase3, category: .mcuCore, runtimeMinutes: 123, releaseOrder: 0),
        .init(id: "avengers-endgame", title: "Vengadores: Endgame", releaseDate: date(2019,4,26), mediaType: .movie, phase: .phase3, category: .mcuCore, runtimeMinutes: 181, releaseOrder: 0),
        .init(id: "spiderman-far-from-home", title: "Spider-Man: Lejos de Casa", releaseDate: date(2019,7,2), mediaType: .movie, phase: .phase3, category: .mcuCore, runtimeMinutes: 129, releaseOrder: 0),
        .init(id: "wandavision", title: "WandaVision", releaseDate: date(2021,1,15), mediaType: .series, phase: .phase4, category: .mcuCore, runtimeMinutes: 285, releaseOrder: 0),
        .init(id: "falcon-winter-soldier", title: "Falcon y el Soldado de Invierno", releaseDate: date(2021,3,19), mediaType: .series, phase: .phase4, category: .mcuCore, runtimeMinutes: 290, releaseOrder: 0),
        .init(id: "loki-s1", title: "Loki (Temporada 1)", releaseDate: date(2021,6,9), mediaType: .series, phase: .phase4, category: .mcuCore, runtimeMinutes: 320, releaseOrder: 0),
        .init(id: "black-widow", title: "Black Widow", releaseDate: date(2021,7,9), mediaType: .movie, phase: .phase4, category: .mcuCore, runtimeMinutes: 134, releaseOrder: 0),
        .init(id: "what-if-s1", title: "What If...? (Temporada 1)", releaseDate: date(2021,8,11), mediaType: .series, phase: .phase4, category: .mcuCore, runtimeMinutes: 280, releaseOrder: 0),
        .init(id: "shang-chi", title: "Shang-Chi y la Leyenda de los Diez Anillos", releaseDate: date(2021,9,3), mediaType: .movie, phase: .phase4, category: .mcuCore, runtimeMinutes: 132, releaseOrder: 0),
        .init(id: "eternals", title: "Eternals", releaseDate: date(2021,11,5), mediaType: .movie, phase: .phase4, category: .mcuCore, runtimeMinutes: 156, releaseOrder: 0),
        .init(id: "hawkeye", title: "Ojo de Halcón", releaseDate: date(2021,11,24), mediaType: .series, phase: .phase4, category: .mcuCore, runtimeMinutes: 290, releaseOrder: 0),
        .init(id: "spiderman-no-way-home", title: "Spider-Man: Sin Camino a Casa", releaseDate: date(2021,12,17), mediaType: .movie, phase: .phase4, category: .mcuCore, runtimeMinutes: 148, releaseOrder: 0),
        .init(id: "moon-knight", title: "Moon Knight", releaseDate: date(2022,3,30), mediaType: .series, phase: .phase4, category: .mcuCore, runtimeMinutes: 290, releaseOrder: 0),
        .init(id: "doctor-strange-multiverse-madness", title: "Doctor Strange en el Multiverso de la Locura", releaseDate: date(2022,5,6), mediaType: .movie, phase: .phase4, category: .mcuCore, runtimeMinutes: 126, releaseOrder: 0),
        .init(id: "ms-marvel", title: "Ms. Marvel", releaseDate: date(2022,6,8), mediaType: .series, phase: .phase4, category: .mcuCore, runtimeMinutes: 260, releaseOrder: 0),
        .init(id: "thor-love-thunder", title: "Thor: Amor y Trueno", releaseDate: date(2022,7,8), mediaType: .movie, phase: .phase4, category: .mcuCore, runtimeMinutes: 119, releaseOrder: 0),
        .init(id: "she-hulk", title: "She-Hulk: Abogada Hulka", releaseDate: date(2022,8,18), mediaType: .series, phase: .phase4, category: .mcuCore, runtimeMinutes: 290, releaseOrder: 0),
        .init(id: "werewolf-by-night", title: "Werewolf by Night", releaseDate: date(2022,10,7), mediaType: .special, phase: .phase4, category: .mcuCore, runtimeMinutes: 53, releaseOrder: 0),
        .init(id: "wakanda-forever", title: "Black Panther: Wakanda Forever", releaseDate: date(2022,11,11), mediaType: .movie, phase: .phase4, category: .mcuCore, runtimeMinutes: 161, releaseOrder: 0),
        .init(id: "gotg-holiday-special", title: "Especial Guardianes de la Galaxia: Feliz Navidad", releaseDate: date(2022,11,25), mediaType: .special, phase: .phase4, category: .mcuCore, runtimeMinutes: 44, releaseOrder: 0),
        .init(id: "ant-man-quantumania", title: "Ant-Man y la Avispa: Quantumania", releaseDate: date(2023,2,17), mediaType: .movie, phase: .phase5, category: .mcuCore, runtimeMinutes: 125, releaseOrder: 0),
        .init(id: "gotg-vol-3", title: "Guardianes de la Galaxia Vol. 3", releaseDate: date(2023,5,5), mediaType: .movie, phase: .phase5, category: .mcuCore, runtimeMinutes: 150, releaseOrder: 0),
        .init(id: "secret-invasion", title: "Secret Invasion", releaseDate: date(2023,6,21), mediaType: .series, phase: .phase5, category: .mcuCore, runtimeMinutes: 230, releaseOrder: 0),
        .init(id: "loki-s2", title: "Loki (Temporada 2)", releaseDate: date(2023,10,6), mediaType: .series, phase: .phase5, category: .mcuCore, runtimeMinutes: 300, releaseOrder: 0),
        .init(id: "the-marvels", title: "The Marvels", releaseDate: date(2023,11,10), mediaType: .movie, phase: .phase5, category: .mcuCore, runtimeMinutes: 105, releaseOrder: 0),
        .init(id: "echo", title: "Echo", releaseDate: date(2024,1,9), mediaType: .series, phase: .phase5, category: .mcuCore, runtimeMinutes: 260, releaseOrder: 0),
        .init(id: "deadpool-wolverine", title: "Deadpool & Wolverine", releaseDate: date(2024,7,26), mediaType: .movie, phase: .phase5, category: .mcuCore, runtimeMinutes: 128, releaseOrder: 0),
        .init(id: "agatha-all-along", title: "Agatha, ¿Quién si no?", releaseDate: date(2024,9,18), mediaType: .series, phase: .phase5, category: .mcuCore, runtimeMinutes: 290, releaseOrder: 0),
        .init(id: "captain-america-brave-new-world", title: "Capitán América: Un Nuevo Mundo", releaseDate: date(2025,2,14), mediaType: .movie, phase: .phase5, category: .mcuCore, runtimeMinutes: 118, releaseOrder: 0),
        .init(id: "daredevil-born-again-s1", title: "Daredevil: Born Again (Temporada 1)", releaseDate: date(2025,3,4), mediaType: .series, phase: .phase5, category: .mcuCore, runtimeMinutes: 440, releaseOrder: 0),
        .init(id: "thunderbolts", title: "Thunderbolts*", releaseDate: date(2025,5,2), mediaType: .movie, phase: .phase5, category: .mcuCore, runtimeMinutes: 127, releaseOrder: 0),
        .init(id: "ironheart", title: "Ironheart", releaseDate: date(2025,6,24), mediaType: .series, phase: .phase5, category: .mcuCore, runtimeMinutes: 250, releaseOrder: 0),
        .init(id: "fantastic-four-first-steps", title: "Los 4 Fantásticos: Primeros Pasos", releaseDate: date(2025,7,25), mediaType: .movie, phase: .phase6, category: .mcuCore, runtimeMinutes: 115, releaseOrder: 0),
        .init(id: "eyes-of-wakanda", title: "Eyes of Wakanda", releaseDate: date(2025,8,6), mediaType: .series, phase: .phase6, category: .mcuCore, runtimeMinutes: 160, releaseOrder: 0),
        .init(id: "marvel-zombies", title: "Marvel Zombies", releaseDate: date(2025,10,3), mediaType: .series, phase: .phase6, category: .mcuCore, runtimeMinutes: 220, releaseOrder: 0),
        .init(id: "wonder-man-s1", title: "Wonder Man (Temporada 1)", releaseDate: date(2026,1,27), mediaType: .series, phase: .phase6, category: .mcuCore, runtimeMinutes: 360, releaseOrder: 0),
        .init(id: "daredevil-born-again-s2", title: "Daredevil: Born Again (Temporada 2)", releaseDate: date(2026,3,24), mediaType: .series, phase: .phase6, category: .mcuCore, runtimeMinutes: 400, releaseOrder: 0),
        .init(id: "punisher-one-last-kill", title: "The Punisher: One Last Kill", releaseDate: date(2026,5,12), mediaType: .special, phase: .phase6, category: .mcuCore, runtimeMinutes: 50, releaseOrder: 0),
        .init(id: "spiderman-brand-new-day", title: "Spider-Man: Brand New Day", releaseDate: date(2026,7,31), mediaType: .movie, phase: .phase6, category: .mcuCore, runtimeMinutes: 130, releaseOrder: 0),
        .init(id: "visionquest", title: "VisionQuest", releaseDate: date(2026,10,14), mediaType: .series, phase: .phase6, category: .mcuCore, runtimeMinutes: 250, releaseOrder: 0),

            // MARK: - mcu_core_final (1) 
        .init(id: "avengers-doomsday", title: "Avengers: Doomsday", releaseDate: date(2026,12,18), mediaType: .movie, phase: .phase6, category: .finalDestination, runtimeMinutes: 150, releaseOrder: 0),

            // MARK: - multiverse (12) 
        .init(id: "x-men", title: "X-Men", releaseDate: date(2000,7,14), mediaType: .movie, phase: .multiverse, category: .multiverse, runtimeMinutes: 104, releaseOrder: 0),
        .init(id: "x2", title: "X2: X-Men United", releaseDate: date(2003,5,2), mediaType: .movie, phase: .multiverse, category: .multiverse, runtimeMinutes: 133, releaseOrder: 0),
        .init(id: "x-men-last-stand", title: "X-Men: La Decisión Final", releaseDate: date(2006,5,26), mediaType: .movie, phase: .multiverse, category: .multiverse, runtimeMinutes: 104, releaseOrder: 0),
        .init(id: "fantastic-four-2005", title: "Los 4 Fantásticos (2005)", releaseDate: date(2005,7,8), mediaType: .movie, phase: .multiverse, category: .multiverse, runtimeMinutes: 106, releaseOrder: 0),
        .init(id: "fantastic-four-silver-surfer", title: "Los 4 Fantásticos y Silver Surfer", releaseDate: date(2007,6,15), mediaType: .movie, phase: .multiverse, category: .multiverse, runtimeMinutes: 92, releaseOrder: 0),
        .init(id: "x-men-first-class", title: "X-Men: Primera Generación", releaseDate: date(2011,6,3), mediaType: .movie, phase: .multiverse, category: .multiverse, runtimeMinutes: 132, releaseOrder: 0),
        .init(id: "x-men-days-future-past", title: "X-Men: Días del Futuro Pasado", releaseDate: date(2014,5,23), mediaType: .movie, phase: .multiverse, category: .multiverse, runtimeMinutes: 132, releaseOrder: 0),
        .init(id: "deadpool", title: "Deadpool", releaseDate: date(2016,2,12), mediaType: .movie, phase: .multiverse, category: .multiverse, runtimeMinutes: 108, releaseOrder: 0),
        .init(id: "x-men-apocalypse", title: "X-Men: Apocalipsis", releaseDate: date(2016,5,27), mediaType: .movie, phase: .multiverse, category: .multiverse, runtimeMinutes: 144, releaseOrder: 0),
        .init(id: "logan", title: "Logan", releaseDate: date(2017,3,3), mediaType: .movie, phase: .multiverse, category: .multiverse, runtimeMinutes: 137, releaseOrder: 0),
        .init(id: "deadpool-2", title: "Deadpool 2", releaseDate: date(2018,5,18), mediaType: .movie, phase: .multiverse, category: .multiverse, runtimeMinutes: 119, releaseOrder: 0),
        .init(id: "dark-phoenix", title: "X-Men: Fénix Oscura", releaseDate: date(2019,6,7), mediaType: .movie, phase: .multiverse, category: .multiverse, runtimeMinutes: 114, releaseOrder: 0),

            // MARK: - defenders (13) 
        .init(id: "daredevil-t1", title: "Daredevil (Temporada 1)", releaseDate: date(2015,4,10), mediaType: .series, phase: .defenders, category: .defenders, runtimeMinutes: 572, releaseOrder: 0),
        .init(id: "jessica-jones-t1", title: "Jessica Jones (Temporada 1)", releaseDate: date(2015,11,20), mediaType: .series, phase: .defenders, category: .defenders, runtimeMinutes: 624, releaseOrder: 0),
        .init(id: "daredevil-t2", title: "Daredevil (Temporada 2)", releaseDate: date(2016,3,18), mediaType: .series, phase: .defenders, category: .defenders, runtimeMinutes: 572, releaseOrder: 0),
        .init(id: "luke-cage-t1", title: "Luke Cage (Temporada 1)", releaseDate: date(2016,9,30), mediaType: .series, phase: .defenders, category: .defenders, runtimeMinutes: 650, releaseOrder: 0),
        .init(id: "iron-fist-t1", title: "Iron Fist (Temporada 1)", releaseDate: date(2017,3,17), mediaType: .series, phase: .defenders, category: .defenders, runtimeMinutes: 650, releaseOrder: 0),
        .init(id: "the-defenders", title: "The Defenders", releaseDate: date(2017,8,18), mediaType: .series, phase: .defenders, category: .defenders, runtimeMinutes: 430, releaseOrder: 0),
        .init(id: "punisher-t1", title: "The Punisher (Temporada 1)", releaseDate: date(2017,11,17), mediaType: .series, phase: .defenders, category: .defenders, runtimeMinutes: 650, releaseOrder: 0),
        .init(id: "jessica-jones-t2", title: "Jessica Jones (Temporada 2)", releaseDate: date(2018,3,8), mediaType: .series, phase: .defenders, category: .defenders, runtimeMinutes: 650, releaseOrder: 0),
        .init(id: "luke-cage-t2", title: "Luke Cage (Temporada 2)", releaseDate: date(2018,6,22), mediaType: .series, phase: .defenders, category: .defenders, runtimeMinutes: 650, releaseOrder: 0),
        .init(id: "iron-fist-t2", title: "Iron Fist (Temporada 2)", releaseDate: date(2018,9,7), mediaType: .series, phase: .defenders, category: .defenders, runtimeMinutes: 550, releaseOrder: 0),
        .init(id: "daredevil-t3", title: "Daredevil (Temporada 3)", releaseDate: date(2018,10,19), mediaType: .series, phase: .defenders, category: .defenders, runtimeMinutes: 650, releaseOrder: 0),
        .init(id: "punisher-t2", title: "The Punisher (Temporada 2)", releaseDate: date(2019,1,18), mediaType: .series, phase: .defenders, category: .defenders, runtimeMinutes: 650, releaseOrder: 0),
        .init(id: "jessica-jones-t3", title: "Jessica Jones (Temporada 3)", releaseDate: date(2019,6,14), mediaType: .series, phase: .defenders, category: .defenders, runtimeMinutes: 650, releaseOrder: 0),

            // MARK: - agent_carter (2) 
        .init(id: "agent-carter-t1", title: "Agent Carter (Temporada 1)", releaseDate: date(2015,1,6), mediaType: .series, phase: .agentCarter, category: .agentCarter, runtimeMinutes: 340, releaseOrder: 0),
        .init(id: "agent-carter-t2", title: "Agent Carter (Temporada 2)", releaseDate: date(2016,1,19), mediaType: .series, phase: .agentCarter, category: .agentCarter, runtimeMinutes: 340, releaseOrder: 0),
        ]

        // Recalcula releaseOrder correlativo por fecha DENTRO de cada categoria,
        // para que cada bloque (nucleo, multiverse, defenders, agent carter)
        // tenga su propia numeracion de "parada" en el roadmap.
        for cat in [ContentCategory.mcuCore, .finalDestination, .multiverse, .defenders, .agentCarter] {
            var subset = all.filter { $0.category == cat }
            subset.sort { $0.releaseDate < $1.releaseDate }
            for (i, item) in subset.enumerated() { item.releaseOrder = i + 1 }
        }

        return all
    }
}
