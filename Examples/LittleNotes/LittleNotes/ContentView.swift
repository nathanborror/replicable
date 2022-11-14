import SwiftUI

struct ContentView: View {
    @EnvironmentObject var storage: LocalStorage
    
    @State private var selectedNote: Note? = nil
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedNote) {
                ForEach(storage.notebook.notes) { note in
                    NavigationLink(value: note) { Text(note.displayTitle) }
                }
                .onDelete { indices in
                    indices.forEach { storage.notebook.noteRemove(at: $0) }
                }
                .onMove { sources, destination in
                    storage.noteMove(from: sources.first!, to: destination)
                }
            }
            .navigationTitle("Notes")
            .toolbar {
                ToolbarItem {
                    Button(action: storage.noteAdd) {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem {
                    EditButton()
                }
            }
        } detail: {
            if let note = selectedNote {
                NoteDetail(note: storage.noteBinding(forID: note.id))
            } else {
                Text("Select Note")
            }
        }
    }
}

struct NoteDetail: View {
    @Binding var note: Note
    
    var body: some View {
        VStack {
            TextField("Title", text: $note.title.value)
            ReplicatingCharactersView(replicatingCharacters: $note.text)
        }
        .padding()
    }
}
