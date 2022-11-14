import Foundation

extension Array {
    
    func filterDuplicates(identifying block: (Element) -> AnyHashable) -> Self {
        var encountered: Set<AnyHashable> = []
        return filter { encountered.insert(block($0)).inserted }
    }
}
