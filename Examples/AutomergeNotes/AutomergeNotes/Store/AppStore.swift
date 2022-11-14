import Foundation

class AppStore {
    
    let localStorage: LocalStorage
    
    init() {
        localStorage = Self.makeLocalStorage()
    }
    
    func saveAndSync() {
        localStorage.save()
        sync()
    }
    
    func sync() {
        // TODO: Cync with cloud
    }
    
    private static func makeLocalStorage() -> LocalStorage {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let subDir = appSupport.appendingPathComponent("AutomergeNotes")
        return LocalStorage(url: subDir)
    }
}
