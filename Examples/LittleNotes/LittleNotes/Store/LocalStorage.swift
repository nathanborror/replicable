import Foundation
import SwiftUI

class LocalStorage: ObservableObject {
    
    struct Metadata: Codable {
        var versionOfNotebookInCloud: UUID?
    }
    
    @Published var notebook: Notebook
    
    var metadata: Metadata
    
    let directoryURL: URL
    let metadataURL: URL
    let notebookURL: URL
    
    init(url: URL) {
        self.directoryURL = url
        try? FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        
        self.metadataURL = self.directoryURL.appendingPathComponent("metadata.json")
        if FileManager.default.fileExists(atPath: metadataURL.path) {
            metadata = try! JSONDecoder().decode(Metadata.self, from: Data(contentsOf: metadataURL))
        } else {
            metadata = .init()
        }
        
        self.notebookURL = self.directoryURL.appendingPathComponent("notebook.json")
        if FileManager.default.fileExists(atPath: notebookURL.path) {
            notebook = try! JSONDecoder().decode(Notebook.self, from: Data(contentsOf: notebookURL))
        } else {
            notebook = .init()
        }
    }
    
    func save() {
        try! JSONEncoder().encode(notebook).write(to: notebookURL)
        try! JSONEncoder().encode(metadata).write(to: metadataURL)
    }
    
    func merge(cloudNotebook: Notebook) {
        metadata.versionOfNotebookInCloud = cloudNotebook.versionID
        notebook = notebook.merged(with: cloudNotebook)
        save()
    }
    
    // TODO: merge() with cloud state
    
    func noteAdd() {
        notebook.noteAppend(Note())
    }
    
    func noteRemove(at index: Int) {
        notebook.noteRemove(at: index)
    }
    
    func noteMove(from source: Int, to destination: Int) {
        notebook.noteMove(from: source, to: destination)
    }
    
    func noteBinding(forID id: Note.ID) -> Binding<Note> {
        .init(
            get: { () -> Note in
                self.notebook.notes.first { $0.id == id }!
            },
            set: { note in
                let i = self.notebook.notes.firstIndex { $0.id == id }!
                self.notebook[i] = note
            }
        )
    }
    
    func noteBinding(forIndex index: Int) -> Binding<Note> {
        .init(
            get: { () -> Note in
                self.notebook[index]
            },
            set: { note in
                self.notebook[index] = note
            }
        )
    }
}

extension LocalStorage: CloudStorable {
    
    func receiveDownload(from store: CloudStorage, _ data: Data) {
        if let notebook = try? JSONDecoder().decode(Notebook.self, from: data) {
            merge(cloudNotebook: notebook)
        }
    }
    
    func shouldUpload(to store: CloudStorage) -> Bool {
        metadata.versionOfNotebookInCloud != notebook.versionID
    }
    
    func dataToUpload(to store: CloudStorage) throws -> Data {
        try JSONEncoder().encode(notebook)
    }
    
}
