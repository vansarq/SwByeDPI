import Foundation

/// Abstract cancellation token
public struct CancellationToken {
    
    /// Cancellation requested for the token flag
    private var cancelled: Bool
    
    /// Returns `true` if cancellation has been requested for this token.
    public var cancellationRequested: Bool {
        get {
            return cancelled
        }
    }
    
    init() {
        cancelled = false
    }
    
    fileprivate mutating func cancel() {
        if (cancelled) {
            return
        }
        cancelled = true
    }
}

/// Abstract cancellation token source
public final class CancellationTokenSource {

    /// Cancellation token
    fileprivate var token: CancellationToken
    
    /// Cancellation token
    public var cancellationToken: CancellationToken {
        get {
            return token
        }
    }
    
    public init() {
        token = CancellationToken()
    }
    
    /// Communicates a request for cancellation to the managed tokens.
    public func cancel() {
        token.cancel()
    }
}

/// Thread-safe cancellation token source
public final class ConcurrentCancellationTokenSource {

    /// Cancellation token
    fileprivate var token: CancellationToken
    /// Dispatch queue
    fileprivate let queue: DispatchQueue
    
    /// Cancellation token getter (Thread-safe)
    public var cancellationToken: CancellationToken {
        get {
            queue.sync {
                return token
            }
        }
    }
    
    public init() {
        token = CancellationToken()
        queue = DispatchQueue(label: UUID().uuidString + ".cancellationToken")
    }
    
    /// Request cancellation (Thread-safe)
    public func cancel() {
        queue.sync {
            token.cancel()
        }
    }
}

#if swift(>=5.5)
extension CancellationToken: Sendable {}
extension ConcurrentCancellationTokenSource: @unchecked Sendable {}
#endif
