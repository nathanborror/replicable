import Foundation
import SwiftUI
import Automerge

class LocalStorage: ObservableObject {
    
    @Published var notebook: Automerge.Document<Notebook>
    
    let directoryURL: URL
    let notebookURL: URL
    
    init(url: URL) {
        self.directoryURL = url
        try? FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        
        self.notebookURL = self.directoryURL.appendingPathComponent("notebook.json")
        print(notebookURL.absoluteString)
        
        if FileManager.default.fileExists(atPath: notebookURL.path) {
            let data = try! Data(contentsOf: notebookURL)
            notebook = Automerge.Document<Notebook>(data: [UInt8](data))
        } else {
            notebook = Automerge.Document(Notebook())
        }
    }
    
    func save() {
        try! Data(notebook.save()).write(to: notebookURL)
    }
    
    // TODO: merge() with cloud state
    
    func noteAdd() {
        notebook.change(message: "note append") { nb in
            nb.notes.append(Note())
        }
    }
    
    func noteRemove(at index: Int) {
        notebook.change(message: "note remove at index \(index)") { nb in
            nb.notes.remove(at: index)
        }
    }
    
    func noteMove(from source: Int, to destination: Int) {
        notebook.change(message: "note move \(source) to \(destination)") { nb in
            let note = nb.notes.remove(at: source)
            nb.notes.insert(note, at: destination)
        }
    }
    
    func noteBinding(forID id: Note.ID) -> Binding<Note> {
        .init(
            get: { () -> Note in
                self.notebook.content.notes.first { $0.id == id }!
            },
            set: { note in
                let i = self.notebook.content.notes.firstIndex { $0.id == id }!
                self.notebook.change(message: "note change \(note.id)") { nb in
                    nb.notes[i].set(note)
                }
            }
        )
    }
    
    func noteBinding(forIndex index: Int) -> Binding<Note> {
        .init(
            get: { () -> Note in
                self.notebook.content.notes[index]
            },
            set: { note in
                self.notebook.change(message: "note change \(note.id)") { nb in
                    nb.notes[index].set(note)
                }
            }
        )
    }
}
