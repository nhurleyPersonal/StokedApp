import Foundation

struct TopSpot: Hashable, Codable, Identifiable {
    var id: String
    var name: String
    var Date: Date
    var sessions: [Session]
    var overallScore: Double
    var surfData: SurfData
    var descriptions: [String] {
        var wordCounts: [String: Int] = [:]

        for session in sessions {
            let words = [session.wordOne, session.wordTwo, session.wordThree]
            for word in words {
                wordCounts[word, default: 0] += 1
            }
        }

        let sortedWords = wordCounts.sorted { $0.value > $1.value }
        let topFiveWords = sortedWords.prefix(5).map { $0.key }

        return topFiveWords
    }
}
