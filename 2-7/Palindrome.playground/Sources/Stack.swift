public protocol StackProtocol {
    associatedtype Element
    
    func push(_ element: Element)
    func pop() -> Element?
}
public class Stack<T>: StackProtocol {
    private var array = [T]()
    public init() {}
    
    public func push(_ element: T) {
        self.array.append(element)
    }
    public func pop() -> T? {
        return self.array.isEmpty ? nil : self.array.removeLast()
    }
}

