import SwiftUI

@main
struct MainApp: App {
    @Environment(\.scenePhase) private var scenePhase
    
    let store = AppStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store.localStorage)
        }
        .onChange(of: scenePhase) { newPhase in
            switch newPhase {
            case.active:
                store.sync()
            case .inactive, .background:
                store.saveAndSync()
            @unknown default:
                break
            }
        }
    }
}
