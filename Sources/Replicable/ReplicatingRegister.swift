import Foundation

public struct ReplicatingRegister<T> {
    
    fileprivate struct Entry: Identifiable {
        var value: T
        var timestamp: TimeInterval
        var id: UUID
        
        init(value: T, timestamp: TimeInterval = Date().timeIntervalSinceReferenceDate, id: UUID = UUID()) {
            self.value = value
            self.timestamp = timestamp
            self.id = id
        }
        
        func isOrdered(after other: Entry) -> Bool {
            (timestamp, id.uuidString) > (other.timestamp, other.id.uuidString)
        }
    }
    
    private var entry: Entry
    
    public var value: T {
        get { entry.value }
        set { entry = Entry(value: newValue) }
    }
    
    public init(_ value: T) {
        entry = Entry(value: value)
    }
}

extension ReplicatingRegister: Replicable {
    
    public func merged(with other: ReplicatingRegister) -> ReplicatingRegister {
        entry.isOrdered(after: other.entry) ? self : other
    }
}

extension ReplicatingRegister: Equatable where T: Equatable {}
extension ReplicatingRegister.Entry: Equatable where T: Equatable {}

extension ReplicatingRegister: Hashable where T: Hashable {}
extension ReplicatingRegister.Entry: Hashable where T: Hashable {}

extension ReplicatingRegister: Codable where T: Codable {}
extension ReplicatingRegister.Entry: Codable where T: Codable {}
