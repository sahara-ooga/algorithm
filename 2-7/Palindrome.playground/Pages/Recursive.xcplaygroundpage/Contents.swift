//: [Previous](@previous)


/*
 要素数が奇数のとき
 0 ( 1 ( 2 ( 3 ) 2 ) 1 ) 0
 を渡されたら、
 1番目と7番目を比較する　（残りリスト長さ5)
 2番目と6番目を比較する (残りリスト長さ3)
 3番目と5番目を比較する（残りリスト長さ1)
 ４番目は関係ない
 */
/*
 要素数が偶数のとき
 0 ( 1 ( 2 ( 3 nil 3 ) 2 ) 1 ) 0
 1番目と８番目を比較する (残りリスト長さ6)
 2番目と7番目を比較する (残りリスト長さ4)
 3番目と6番目を比較する (残りリスト長さ2)
 4番目と5番目を比較する (残りリスト長さ0)
 */
/*
 再帰で実装するときは、まず、真ん中に達したあとで、真ん中を挟むように比較を続けることになる。
 真ん中はElement?型で、元のリストの長さが偶数のときのみnilになる。
 */
/*:
 残りのリスト                         残りリスト長さ
 0 ( 1 ( 2 ( 3 ) 2 ) 1 ) 0                  7
 1 ( 2 ( 3 ) 2 ) 1 ) 0                  5
 2 ( 3 ) 2 ) 1 ) 0                   3
 ( 3 ) 2 ) 1 ) 0                   1
 
 ※ここで、実際保持されている連結リストの長さと、対象にしている残りリスト長さは異なることに注意（前者は１ずつ減る・後者は２ずつ減る）
 
 　　残り長さが１かゼロになったら、掘り進めるのをやめる（再帰の打ち止め）
 
 残りリスト長さが1 or 0になったら、次のノード1bを返す
 先頭ノード1fと帰ってきたノード1bを比較し、異なる場合はfalseを返して終了　同じ場合は1fを返す
 */

/// 回文かどうかを調べた結果
struct PalindromeCheckResult<Element: Equatable> {
    /// 次に調べるべき連結リストのノード
    let node: LinkedListNode<Element>?
    /// 回文かどうか
    let isPalindrome: Bool
}

/// 再帰的に回分であるかどうかをチェックする
///
/// - Parameters:
///   - node: チェック対象となる連結リストのノード
///   - length: チェック対象となる連結リストの残りノードの数
/// - Returns: 次にチェックすべき連結リストのノードとノードの要素の判定結果
func checkRecursively<Element: Equatable>(
    head: LinkedListNode<Element>,
    length: Int) -> PalindromeCheckResult<Element> {
    if case .end = head, head.length == 0 {
        return PalindromeCheckResult(node: nil, isPalindrome: false)
    }
    if head.element == nil || length == 0 {
        return PalindromeCheckResult(node: nil, isPalindrome: true)
    } else if length == 1 {//元のリストは奇数長で、渡されてきたnodeは真ん中の要素である
        return PalindromeCheckResult(
            node: head.next, isPalindrome: true//次の要素を返す　比較はしようがないのでtrueを返す
        )
    } else if length == 2 {
        return PalindromeCheckResult(
            node: nil, isPalindrome: head.element == head.next?.element
        )
    }
    //より真ん中に近い部分で判定を行い、戻ってきた結果で場合分けする
    let middlePartCheckResult = checkRecursively(head: head.next!, length: length - 2)
    if middlePartCheckResult.node == nil || !middlePartCheckResult.isPalindrome {
        //比較すべき次の要素が無い場合は、帰ってきた中間結果をそのまま返せば良い
        //真ん中寄りの部分の判定結果がfalseなら、新たに判定する必要もなくfalseを返せばよい
        return middlePartCheckResult
    } else {
        //middlePartCheckResult.node != nilかつmiddlePartCheckResult.result == trueである
        //引数のnodeの要素と比較して、判定結果と次の要素を返す
        //連結リストのポインタは先に進める
        return PalindromeCheckResult(
            node: middlePartCheckResult.node?.next,
            isPalindrome: head.element == middlePartCheckResult.node?.element
        )
    }
}
func isPalindrome<Element: Equatable>(node: LinkedListNode<Element>) -> Bool {
    if case .end = node { return false }
    return checkRecursively(head: node, length: node.length).isPalindrome
}
do {
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
        .map { checkRecursively(head: $0, length: $0.length) }
        .map { $0.isPalindrome }
        .forEach { assert($0) }
    palindromes
        .map { LinkedListNode(collection: $0) }
        .map { isPalindrome(node: $0) }
        .forEach { assert($0) }
}
do {
    
    let notPalindromes = [
        [],
        [1, 2],
        [1, 2, 2],
        [0, 1, 2, 3],
        [2, 4, 4, 5, 10]
    ]
    notPalindromes
        .map { LinkedListNode(collection: $0) }
        .map { checkRecursively(head: $0, length: $0.length) }
        .map { $0.isPalindrome }
        .forEach { assert(!$0) }
    notPalindromes
        .map { LinkedListNode(collection: $0) }
        .map { isPalindrome(node: $0) }
        .forEach { assert(!$0) }
}
//: [Next](@next)
