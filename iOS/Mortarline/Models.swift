import Foundation

struct MortarJob: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var location: String = ""
    var mixType: String = ""
    var date: Date = Date()
}
