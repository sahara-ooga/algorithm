/// 連結リストのノード
///
/// - element: 要素と次のノードへのポインタ
/// - end: 終端であることを示す
public indirect enum LinkedListNode<Element> {
    case element(element: Element, next: LinkedListNode<Element>)
    case end
}
extension LinkedListNode {
    /// 次の要素を返す
    public var next: LinkedListNode? {
        switch self {
        case .element(element: _, next: let next):
            return next
        case .end:
            return nil
        }
    }
}
extension LinkedListNode {
    public var element: Element? {
        switch self {
        case .element(element: let element, next: _):
            return element
        default:
            return nil
        }
    }
}
// MARK: - CollectionとLinkedListの変換用の計算型プロパティ
extension LinkedListNode {
    /// 連結リスト（のノード）から配列への変換
    public var array: Array<Element> {
        switch self {
        case .end:
            return []
        case .element(element: let element, next: let next):
            return [element] + next.array
        }
    }
}
extension Collection {
    /// Collectionから連結リストへの変換
    public var linkedListNode: LinkedListNode<Element> {
        if self.isEmpty {
            return LinkedListNode<Element>.end
        } else {
            return LinkedListNode.element(
                element: self.first!,
                next: self.dropFirst().map { $0 }.linkedListNode
            )
        }
    }
}
// MARK: - Collectionと連結リストの相互変換用のイニシャライザ
extension LinkedListNode {
    public init<T: Collection>(collection: T) where T.Element == Element {
        if collection.isEmpty {
            self = LinkedListNode<Element>.end
        } else {
            self = LinkedListNode.element(
                element: collection.first!,
                next: LinkedListNode(collection: collection.dropFirst())
            )
        }
    }
}
extension Array {
    public init(linkedList: LinkedListNode<Array.Element>) {
        switch linkedList {
        case .end:
            self = []
        case .element(element: let element, next: let next):
            self = [element] + Array(linkedList: next)//next.array
        }
    }
}
extension LinkedListNode {
    /// 自分自身か、次の要素がendであればtrue
    public var isEndOfList: Bool {
        if case .end = self { return true }
        if case .end? = self.next { return true }
        return false
    }
}
extension LinkedListNode {
    /// 連結リストの長さを返す。自分自身が終端なら0を返す
    public var length: Int {
        switch self {
        case .end:
            return 0
        case .element(element: _, next: let next):
            return next.length + 1
        }
    }
}
