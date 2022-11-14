import Foundation

struct Notebook: Codable, Equatable {
    var notes: [Note] = []
}

struct Note: Codable, Equatable, Hashable, Identifiable {
    var id: UUID = .init()
    var title: String = ""
    var text: String = ""
    var created: Date = .init()
    
    var displayTitle: String {
        title.isEmpty ? "Untitled" : title
    }
}
