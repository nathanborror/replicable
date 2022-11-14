import Foundation

class AppStore {
    
    let localStorage: LocalStorage
    let cloudStorage: CloudStorage
    
    init() {
        localStorage = Self.makeLocalStorage()
        cloudStorage = Self.makeCloudStorage(for: localStorage)
        cloudStorage.awaken()
    }
    
    func saveAndSync() {
        localStorage.save()
        sync()
    }
    
    func sync() {
        cloudStorage.sync()
    }
    
    private static func makeLocalStorage() -> LocalStorage {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let subDir = appSupport.appendingPathComponent("LittleNotes")
        return LocalStorage(url: subDir)
    }
    
    private static func makeCloudStorage(for localStorage: LocalStorage) -> CloudStorage {
        let recordConfiguration = CloudStorage.RecordConfiguration(
            containerIdentifier: "iCloud.run.nathan.LittleNotes",
            zoneName: "NotebookZone",
            recordType: "Notebook",
            recordName: "MainNotebook"
        )
        let cloudStorage = CloudStorage(recordConfiguration: recordConfiguration, localStorage: localStorage)
        cloudStorage.localStorage = localStorage
        return cloudStorage
    }
}
