import Foundation

public struct ReplicatingAddOnlySet<T: Hashable> {
    
    public var storage: Set<T>
    
    public mutating func insert(_ entry: T) {
        storage.insert(entry)
    }
    
    public var values: Set<T> {
        storage
    }
    
    public init() {
        storage = .init()
    }
    
    public init(_ values: Set<T>) {
        storage = values
    }
}

extension ReplicatingAddOnlySet: Replicable {
    
    public func merged(with other: ReplicatingAddOnlySet) -> ReplicatingAddOnlySet {
        ReplicatingAddOnlySet(storage.union(other.storage))
    }
}

extension ReplicatingAddOnlySet: Equatable where T: Equatable {}
extension ReplicatingAddOnlySet: Codable where T: Codable {}
