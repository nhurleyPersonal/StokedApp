import Foundation

enum DummyData {
    static func generateRandomUser() -> User {
        let firstNames = [
            "John", "Jane", "Mike", "Emma", "Chris", "Sarah", "David", "Emily", "James", "Jessica",
            "Robert", "Ashley", "Michael", "Rachel", "William", "Amanda", "Joseph", "Megan", "Charles", "Hannah",
            "Thomas", "Alexis", "Christopher", "Grace", "Daniel", "Taylor", "Matthew", "Anna", "George", "Victoria",
            "Richard", "Madison", "Anthony", "Emma", "Donald", "Olivia", "Paul", "Sophia", "Mark", "Isabella",
        ]

        let lastNames = [
            "Smith", "Johnson", "Williams", "Brown", "Jones", "Miller", "Davis", "Garcia", "Rodriguez", "Wilson",
            "Martinez", "Anderson", "Taylor", "Thomas", "Hernandez", "Moore", "Martin", "Jackson", "Thompson", "White",
            "Lopez", "Lee", "Gonzalez", "Harris", "Clark", "Lewis", "Robinson", "Walker", "Perez", "Hall",
            "Young", "Allen", "Sanchez", "Wright", "King", "Scott", "Green", "Baker", "Adams", "Nelson",
        ]
        let domains = ["example", "test", "demo"]
        let tlds = ["com", "net", "org"]
        let taglines = [
            "Surf's Up",
            "Ride Waves",
            "Ocean Bliss",
            "Wave Rider",
            "Sea Surfer",
            "Beach Bum",
            "Tide Turner",
            "Wave Warrior",
            "Surf Junkie",
            "Board Master",
            "Sea Escape",
            "Ocean Roamer",
            "Tide Rider",
            "Surf Seeker",
            "Wave Chaser",
            "Board Rider",
            "Sea Drifter",
            "Ocean Explorer",
            "Surf Addict",
            "Wave Catcher",
            "Tide Chaser",
            "Board Bender",
            "Sea Rider",
            "Ocean Adventurer",
            "Surf Voyager",
            "Wave Surfer",
            "Tide Surfer",
            "Board Surfer",
            "Sea Adventurer",
            "Ocean Rider",
            "Surf Explorer",
            "Wave Adventurer",
            "Tide Explorer",
            "Board Explorer",
            "Sea Voyager",
            "Ocean Seeker",
            "Surf Warrior",
            "Wave Voyager",
            "Tide Voyager",
            "Board Voyager",
        ]

        // Then, in your generateRandomUser function, you can select a random tagline like this:

        let randomTagline = taglines.randomElement()

        let firstName = firstNames.randomElement() ?? "John"
        let lastName = lastNames.randomElement() ?? "Doe"
        let email = "\(firstName.lowercased()).\(lastName.lowercased())@\(domains.randomElement() ?? "example").\(tlds.randomElement() ?? "com")"

        return User(id: UUID(), firstName: firstName, lastName: lastName, email: email, tagline: randomTagline)
    }

    static func generateDummySessions() -> [Session] {
        let spotNames = ["Steamer Lane", "Trestles", "Jeffreys Bay", "Bells Beach", "Uluwatu", "Pipeline", "Teahupo'o", "Jaws", "Mavericks", "Hossegor"]
        let boardNames = ["Mayhem", "Hypto Krypto", "Fish", "Gun", "Longboard", "Shortboard", "Funboard", "Foamboard", "Malibu", "Mini Malibu"]
        let tides = ["Low", "Med", "High"]
        let surfTerms = ["Barney", "Break", "Choppy", "Dawn Patrol", "Epic", "Firing", "Glassy", "Hodad", "Inside", "Jammed", "Kook", "Lineup", "Mushy", "Noodled", "Outside", "Pitted", "Quiver", "Rip", "Stoked", "Tubular"]
        let now = Date()
        let startOfYear = Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 1))!
        let timeInterval = now.timeIntervalSince(startOfYear)

        var dummySessions: [Session] = []

        for i in 1 ... 20 {
            let randomTimeInterval: TimeInterval
            if Bool.random() {
                // 70% chance to pick a date within the past week
                let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -4, to: now)!
                randomTimeInterval = TimeInterval.random(in: oneWeekAgo.timeIntervalSince(startOfYear) ... timeInterval)
            } else {
                // 30% chance to pick a date between the start of the year and one week ago
                randomTimeInterval = TimeInterval.random(in: 0 ... (Calendar.current.date(byAdding: .day, value: -4, to: now)!.timeIntervalSince(startOfYear)))
            }
            let spot = Spot(id: "\(i)", name: spotNames[i % spotNames.count])
            let board = Board(id: "\(i)", name: boardNames[i % boardNames.count])

            let sessionDatetime = startOfYear.addingTimeInterval(randomTimeInterval)
            let sessionLength = Double.random(in: 1 ... 3)
            let surfData = generateDummySurfData()[0]
            let wordOne = surfTerms[i % surfTerms.count]
            let wordTwo = surfTerms[(i + 5) % surfTerms.count]
            let wordThree = surfTerms[(i + 10) % surfTerms.count]
            let overallScore = Double.random(in: 1 ... 10)
            let extraNotes = "Session \(i)"
            let user = generateRandomUser()

            let session = Session(
                id: "\(i)",
                spot: spot,
                sessionDatetime: sessionDatetime,
                sessionLength: sessionLength,
                board: board,
                surfData: surfData,
                wordOne: wordOne,
                wordTwo: wordTwo,
                wordThree: wordThree,
                overallScore: overallScore,
                extraNotes: extraNotes,
                user: user
            )

            dummySessions.append(session)
        }

        return dummySessions
    }

    static func generateDummyFilter() -> FilterCriteria {
        let spotNames = ["Steamer Lane", "Trestles", "Jeffreys Bay", "Bells Beach", "Uluwatu", "Pipeline", "Teahupo'o", "Jaws", "Mavericks", "Hossegor"]
        let spotName = spotNames[Int.random(in: 0 ..< spotNames.count)]
        let dateRange = Date() ... Date().addingTimeInterval(60 * 60 * 24 * 30) // 30 days from now
        let minWaveHeight = Double.random(in: 1 ... 6)
        let minOverallScore = Double.random(in: 1 ... 10)

        return FilterCriteria(spotName: spotName, dateRange: dateRange, minWaveHeight: minWaveHeight, minOverallScore: minOverallScore)
    }

    static func generateBlankFilter() -> FilterCriteria {
        return FilterCriteria()
    }

    static func generateDummyTopSpot() -> TopSpot {
        let spotNames = ["Steamer Lane", "Trestles", "Jeffreys Bay", "Bells Beach", "Uluwatu", "Pipeline", "Teahupo'o", "Jaws", "Mavericks", "Hossegor"]
        let spotName = spotNames[Int.random(in: 0 ..< spotNames.count)]
        let spot = Spot(id: UUID().uuidString, name: spotName)
        let date = Date()
        let sessions = generateDummySessions()
        let overallScore = Double.random(in: 1 ... 10)
        let surfData = SurfData(
            id: UUID().uuidString,
            spot: spot,
            date: date,
            swellHeight: Double.random(in: 1 ... 6),
            swellPeriod: Double.random(in: 10 ... 15),
            swellDirection: Int.random(in: 210 ... 310),
            windSpeed: Double.random(in: 1 ... 20),
            windDirection: Int.random(in: 0 ... 360),
            tide: ["Low", "Med", "High"].randomElement()!
        )

        return TopSpot(
            id: UUID().uuidString,
            name: spotName,
            Date: date,
            sessions: sessions,
            overallScore: overallScore,
            surfData: surfData
        )
    }

    static func generateDummyTopSpots() -> [TopSpot] {

        return (1 ... 20).map { _ in
            let spotNames = ["Steamer Lane", "Trestles", "Jeffreys Bay", "Bells Beach", "Uluwatu", "Pipeline", "Teahupo'o", "Jaws", "Mavericks", "Hossegor"]
            let spotName = spotNames[Int.random(in: 0 ..< spotNames.count)]
            let spot = Spot(id: UUID().uuidString, name: spotName)
            let date = Date()
            let sessions = generateDummySessions()
            let overallScore = Double.random(in: 1 ... 10)
            let surfData = SurfData(
                id: UUID().uuidString,
                spot: spot,
                date: date,
                swellHeight: Double.random(in: 1 ... 6),
                swellPeriod: Double.random(in: 10 ... 15),
                swellDirection: Int.random(in: 210 ... 310),
                windSpeed: Double.random(in: 1 ... 20),
                windDirection: Int.random(in: 0 ... 360),
                tide: ["Low", "Med", "High"].randomElement()!
            )

            return TopSpot(
                id: UUID().uuidString,
                name: spotName,
                Date: date,
                sessions: sessions,
                overallScore: overallScore,
                surfData: surfData
            )
        }
    }

    static func generateDummySurfData() -> [SurfData] {
        let spotNames = ["Steamer Lane", "Trestles", "Jeffreys Bay", "Bells Beach", "Uluwatu", "Pipeline", "Teahupo'o", "Jaws", "Mavericks", "Hossegor"]
        let tides = ["Low", "Med", "High"]

        return (1 ... 20).map { i in
            let spot = Spot(id: "\(i)", name: spotNames[i % spotNames.count])
            let date = Date().addingTimeInterval(TimeInterval(i * 86400)) // Add i days to the current date
            let swellHeight = Double.random(in: 1 ... 6)
            let swellPeriod = Double.random(in: 10 ... 15)
            let swellDirection = Int.random(in: 200 ... 320)
            let windSpeed = Double.random(in: 1 ... 20)
            let windDirection = Int.random(in: 0 ... 360)
            let tide = tides[i % tides.count]

            return SurfData(
                id: "\(i)",
                spot: spot,
                date: date,
                swellHeight: swellHeight,
                swellPeriod: swellPeriod,
                swellDirection: swellDirection,
                windSpeed: windSpeed,
                windDirection: windDirection,
                tide: tide
            )
        }
    }
}
