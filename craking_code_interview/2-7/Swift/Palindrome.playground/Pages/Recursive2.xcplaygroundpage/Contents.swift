//: [Previous](@previous)

/* 再帰処理の中間生成物は、「比較結果が異なるとなった場合、次回以降のステップではノードの情報を使わない」ことに着目すると、enumに書き直す事ができる
 また、判定処理を「２つのノードから判定処理を生成する」と捉えれば、中間生成物のイニシャライザで判定処理を行うことが出来る。Swiftではこうしたモデルからモデルへの変換をイニシャライザで行うことが一般的
 */
enum RecursiveResult<Element: Equatable>{
    case different
    case palindrome(next: LinkedListNode<Element>?)
    
    init(lhs: LinkedListNode<Element>, rhs: LinkedListNode<Element>?) {
        guard let lElement = lhs.element,
            let rElement = rhs?.element  else {
                self = .different; return
        }
        if lElement == rElement {
            self = .palindrome(next: rhs?.next)
        } else {
            self = .different
        }
    }
}
func checkRecursively2<Element: Equatable>(
    head: LinkedListNode<Element>,
    length: Int) -> RecursiveResult<Element> {
    /* 与えられた長さが2以下の場合 */
    if case .end = head, head.length == 0 {
        return RecursiveResult.different
    }
    if head.element == nil || length == 0 {
        return RecursiveResult.palindrome(next: head.next)
    } else if length == 1 {
        //元のリストは奇数長で、渡されてきたnodeは真ん中の要素である
        return RecursiveResult.palindrome(next: head.next)//次の要素を返す
    } else if length == 2 {
        //ちょうど中間地点の２つを比較する
        return RecursiveResult(
            lhs: head, rhs: head.next
        )
    }
    /* 与えられた長さが3以上の場合 */
    let middleResult = checkRecursively2(
        head: head.next!, length: length - 2
    )
    switch middleResult {
    case .different:
        return middleResult
    case .palindrome(let next):
        return RecursiveResult(lhs: head, rhs: next)
    }
}
// MARK: 検証
func check<Element: Equatable, MiddleProduct>(
    subjects: [[Element]],
    function: (LinkedListNode<Element>, Int) -> MiddleProduct,
    mapping: (MiddleProduct) -> Bool,
    expect: Bool) {
    subjects
        .map { LinkedListNode(collection: $0) }
        .map { function($0, $0.length) }
        .map { mapping($0) }
        .forEach { assert($0 == expect, "失敗") }
}

do {
    //検証
    let palindromes = [
        [0],
        [1, 1],
        [1, 2, 1],
        [1, 2, 2, 1],
        [1, 2, 1, 2, 1],
        [1, 2, 3, 3, 2, 1],
        [0, 1, 2, 3, 2, 1, 0]
    ]
    palindromes
        .map { LinkedListNode(collection: $0) }
        .map { checkRecursively2(head: $0, length: $0.length) }
        .map {
            switch $0 {
            case .different:
                return false
            case .palindrome(_):
                return true
            }
        }
        .forEach { assert($0) }
    check(
        subjects: palindromes,
        function: { checkRecursively2(head: $0, length: $1) },
        mapping: {
            switch $0 {
            case .different:
                return false
            case .palindrome(_):
                return true
            }
    },
        expect: true
    )
    let notPalindromes = [
        [],
        [1, 2],
        [1, 2, 2],
        [0, 1, 2, 3],
        [2, 4, 4, 5, 10]
    ]
    check(
        subjects: notPalindromes,
        function: { checkRecursively2(head: $0, length: $1) },
        mapping: {
            switch $0 {
            case .different:
                return false
            case .palindrome(_):
                return true
            }
    },
        expect: false
    )

}

//: [Next](@next)
