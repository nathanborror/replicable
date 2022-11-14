import Foundation
import Replicable

struct Notebook: Replicable, Codable, Equatable {
    
    private var notesByIdentifier: ReplicatingDictionary<Note.ID, Note> {
        didSet {
            if notesByIdentifier != oldValue {
                changeVersion()
            }
        }
    }
    
    private var noteIdentifiersOrdered: ReplicatingArray<Note.ID> {
        didSet {
            if noteIdentifiersOrdered != oldValue {
                changeVersion()
            }
        }
    }
    
    private(set) var versionID: UUID = .init()
    private mutating func changeVersion() { versionID = .init() }
    
    var notes: [Note] { noteIdentifiersOrdered.compactMap { notesByIdentifier[$0] }}
    
    init() {
        notesByIdentifier = .init()
        noteIdentifiersOrdered = .init()
    }
    
    subscript (_ index: Int) -> Note {
        get {
            let id = noteIdentifiersOrdered[index]
            return notesByIdentifier[id]!
        }
        set {
            let id = noteIdentifiersOrdered[index]
            notesByIdentifier[id] = newValue
        }
    }
    
    mutating func noteAppend(_ note: Note) {
        notesByIdentifier[note.id] = note
        noteIdentifiersOrdered.append(note.id)
    }
    
    mutating func noteRemove(at index: Int) {
        let id = noteIdentifiersOrdered.remove(at: index)
        notesByIdentifier[id] = nil
    }
    
    mutating func noteMove(from source: Int, to destination: Int) {
        let id = noteIdentifiersOrdered[source]
        if source < destination {
            noteIdentifiersOrdered.insert(id, at: destination)
            noteIdentifiersOrdered.remove(at: source)
        } else {
            noteIdentifiersOrdered.remove(at: source)
            noteIdentifiersOrdered.insert(id, at: destination)
        }
    }
    
    func merged(with other: Self) -> Self {
        var new = self
        
        new.notesByIdentifier = notesByIdentifier.merged(with: other.notesByIdentifier)
        
        // Make sure there are no duplicates in the note identifiers.
        // Also confirm that a note exists for each identifier.
        // Begin by gathering the indices of the duplicates or invalid ids.
        let orderedIds = noteIdentifiersOrdered.merged(with: other.noteIdentifiersOrdered)
        var encounteredIds = Set<Note.ID>()
        var indicesForRemoval: [Int] = []
        for (i, id) in orderedIds.enumerated() {
            if !encounteredIds.insert(id).inserted || new.notesByIdentifier[id] == nil {
                indicesForRemoval.append(i)
            }
        }
        
        // Remove the non-unique entries in reverse order, so indices are valid
        var uniqueIds = orderedIds
        for i in indicesForRemoval.reversed() {
            uniqueIds.remove(at: i)
        }
        new.noteIdentifiersOrdered = uniqueIds
        return new
    }
}

struct Note: Replicable, Codable, Equatable, Hashable, Identifiable {
    var id: UUID = .init()
    var title: ReplicatingRegister<String> = .init("")
    var text: ReplicatingArray<Character> = .init()
    var created: Date = .init()
    
    var displayTitle: String {
        title.value.isEmpty ? "Untitled" : title.value
    }
    
    func merged(with other: Note) -> Note {
        assert(id == other.id)
        var new = self
        new.title = title.merged(with: other.title)
        new.text = text.merged(with: other.text)
        return new
    }
}
