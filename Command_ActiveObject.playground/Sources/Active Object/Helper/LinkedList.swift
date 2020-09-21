import Foundation

public class Node<Value> {
    public var value: Value
    public var next: Node?
    
    public init(value: Value, next: Node? = nil) {
        self.value = value
        self.next = next
    }
}

extension Node: CustomStringConvertible {
    public var description: String {
        guard let next = next else { return "\(value)" }
        return "\(value) -> " + String(describing: next) + " "
    }
}


// Value 타입의 값과 다음 Node 를 옵셔널로 가짐
// Node 만으로도 연결된 리스트를 구성할 수 있지만
// 실용적이지 못하므로 Linked List 라는 노드 컨테이너를 만들어 이를 관리한다.
public struct LinkedList<Value> {
    // 변수 이름 그대로 연결 리스트의 양끝을 각각 가진다.
    public var head: Node<Value>?
    public var tail: Node<Value>?
    
    public init() {}
    
    // tail 이 nil 이더라도 연결 리스트에는 하나의 노드가 존재할 수 있으나
    // head 가 nil 이라는 것은 연결 리스트가 비어있음을 나타낸다.
    public var isEmpty: Bool {
        self.head == nil
    }
}
// MARK: - Removing values from the list
extension LinkedList {
    // 연결 리스트의 Removing 연산
    // 삽입 연산의 집합과 마찬가지로 총 세가지 연산을 가진다.
    // 1. pop (앞) 2. removeLast (뒤) 3. remove (중간)
    @discardableResult
    public mutating func pop() -> Value? {
        copyNodes()
        defer {
            // 헤드 값을 가져갔으므로 헤드의 다음 노드를 헤드로 만든다.
            head = head?.next
            // pop 연산 이후 비어있는 리스트가 되었을 경우
            // tail 도 제거한다.
            if isEmpty { tail = nil }
        }
        // 연결리스트의 헤드 값을 리턴한다.
        return head?.value
    }
    public mutating func removeLast() -> Value? {
        copyNodes()
        // 비어있는 리스트이므로 nil 을 리턴한다.
        guard let head = head else { return nil }
        // 노드 하나만 존재하는 리스트이므로 pop 메소드를 리턴한다.
        guard head.next != nil else { return pop() }
        
        // currentNode 는 내가 손에 쥐고 있는 노드이다.
        // previousNode 는 내가 손에 쥔 이 노드의 앞에 존재하는 노드이다.
        // 왼손은 previousNode 를 오른손은 currentNode 를 쥐고 있다고 생각한다.
        var previousNode = head
        var currentNode = head
        
        // while statement 를 통해 양손을 리스트를 따라 한 칸씩 움직인다.
        // 단 이때 양손에 노드가 쥐어쥘 수 있어야 하며
        // 따라서 오른손에 더이상 쥘 노드가 없다면 현재 쥐고 있는 노드들을 쥔 채로 이를 종료한다.
        // 그렇다면 이 while statment 의 종료 조건은 오른손은 tail 노드를, 왼손은 tail 의 전 노드를 쥐는 것이다.
        while let nextOfCurrentNode = currentNode.next {
            previousNode = currentNode
            currentNode = nextOfCurrentNode
        }
        
        previousNode.next = nil
        tail = previousNode
        
        return currentNode.value
    }
    @discardableResult
    public mutating func remove(after node: Node<Value>) -> Value? {
        guard let node = copyNodes(returningCopyOf: node) else { return nil }
        // 전달 받은 node 다음의 값을 가져오는 메소드.
        // node 의 next 는 리턴될 값을 가지는 노드의 다음 노드가 될 것. 즉, node.next.next
        // 만일 next 가 더이상 존재하지 않는다면 이는 node 가 tail 이므로
        // node 를 tail 로 설정할 것.
        defer {
            if node.next === tail {
                tail = node
            }
            node.next = node.next?.next
        }
        return node.next?.value
    }
}
// MARK: - Adding values into the list
extension LinkedList {
    // 연결 리스트의 Adding 연산
    // 스택과 달리 어느 곳이든 노드가 더해질 수 있다.
    // 따라서 연결 리스트의 더하기 연산에는
    // 1. Push (앞) 2. Append (뒤) 3. Insert (중간)
    // 총 세 가지의 연산이 있다.
    public mutating func push(value: Value) {
        copyNodes()
        // 연결 리스트의 가장 앞에 파라미터로 전달 받은 값을 갖는 노드를 더함.
        head = Node(value: value, next: head)
        if tail == nil { tail = head }
    }
    public mutating func append(value: Value) {
        copyNodes()
        // 연결 리스트의 마지막에 파라미터로 전달 받은 값을 갖는 노드를 더함.
        guard isEmpty == false else {
            push(value: value)
            return
        }
        tail!.next = Node(value: value)
        tail = tail!.next
    }
    @discardableResult
    public mutating func insert(value: Value, after node: Node<Value>) -> Node<Value> {
        copyNodes()
        // 파라미터로 전달 받은 노드의 뒤에 value 값을 갖는 노드를 더함.
        // 기준 노드를 인자로 전달 받으므로 해당 노드를 탐색할 수 있는 헬퍼 메소드가 필요함.
        guard tail !== node else {
            // 연결 리스트의 마지막 노드가 탐색된 노드라면 바로 append 메소드를 호출하고 리턴.
            append(value: value)
            return tail!
        }
        
        node.next = Node(value: value, next: node.next)
        
        return node.next!
    }
}
// MARK: - Helper Methods
extension LinkedList {
    public func search(at index: Int) -> Node<Value>? {
        // 인자로 전달 받은 정수 값에 해당하는 인덱스의 노드를 찾는다.
        var currentNode = head
        var currentIndex = 0
        
        while currentNode != nil && currentIndex < index {
            // head 부터 시작하여 순차 탐색을 하므로 O(n) 의 계산 복잡도를 가진다.
            currentNode = currentNode!.next
            currentIndex += 1
        }
        
        return currentNode
    }
}
// MARK: - Value semantics and copy-on-write (COW)
extension LinkedList {
    private mutating func copyNodes() {
        /*
         이 메소드의 방식은 매 mutating 메소드 호출마다
         O(n) 의 오버헤드를 발생시킨다.
        
         이는 `isKnownUniquelyReferenced 메소드로 해결한다.`
         */
        
        // head 의 참조 카운트가 2 이상이라면 true 를 리턴하여
        // 아래 guard statement 를 통과한다.
        guard
            !isKnownUniquelyReferenced(&head),
            head !== tail
            else { return }
        // 비어있는 연결 리스트라면 리턴하고 종료한다.
        guard var oldNode = head else { return }
        // head 에 원래 head 의 값을 가지는 새로운 Node 객체를 할당한다.
        head = Node(value: oldNode.value)
        // 새 변수 newNode 가 head 를 가리키도록 한다.
        var newNode = head
        // oldNode 가 마지막 노드가 될 때까지 루프를 실행한다.
        while let nextOldNode = oldNode.next {
            // newNode 의 다음 노드는 nextOldNode 의 값을 가지는 새로운 노드가 된다.
            newNode!.next = Node(value: nextOldNode.value)
            // newNode 를 newNode 의 다음을 가리키도록 한다.
            newNode = newNode!.next
            // oldNode 또한 nextOldNode 를 가리키도록 한다.
            oldNode = nextOldNode
        }
        
        // while statement 를 종료했다는 것은
        // oldNode 의 다음 노드가 존재하지 않았으며
        // newNode 는 현재 이 oldNode (tail) 의 값을 가진 노드가 된다.
        // 따라서 이 newNode 를 새로운 tail 로 할당한다.
        tail = newNode
    }
    private mutating func copyNodes(returningCopyOf node: Node<Value>?) -> Node<Value>? {
        guard
            !isKnownUniquelyReferenced(&head),
            head !== tail
        else {
            print("[INFO] failed the first guard statement")
            print("\(isKnownUniquelyReferenced(&head))")
            return head
        }
        guard var oldNode = head else {
            print("[INFO] failed the second guard statement")
            return nil
        }
        
        head = Node(value: oldNode.value)
        var newNode = head
        var nodeCopy: Node<Value>?
        
        while let nextOldNode = oldNode.next {
            if oldNode === node {
                nodeCopy = newNode
            }
            
            newNode!.next = Node(value: nextOldNode.value)
            newNode = newNode!.next
            oldNode = nextOldNode
        }
        return nodeCopy
    }

}

extension LinkedList: CustomStringConvertible {
    public var description: String {
        guard let head = head else { return "Empty List" }
        return String(describing: head)
    }
}

// Becoming a Swift collection
extension LinkedList: Collection {
    public struct Index: Comparable {
        public var node: Node<Value>?
        static public func ==(lhs: Index, rhs: Index) -> Bool {
            switch (lhs.node, rhs.node) {
            case let (left?, right?):
                return left.next === right.next
            case (nil, nil):
                return true
            default:
                return false
            }
        }
        
        static public func <(lhs: Index, rhs: Index) -> Bool {
            guard lhs != rhs else { return false }
            let nodes = sequence(first: lhs.node) { $0?.next }
            return nodes.contains { $0 === rhs.node }
        }
    }
    // startIndex 는 당연히 연결 리스트의 head 가 된다.
    public var startIndex: Index {
        Index(node: head)
    }
    // Collection 은 endIndex 를 접근 가능한 마지막 value 의 다음 index 로 정의한다.
    // 따라서 endIndex 는 tail 의 next 이다.
    public var endIndex: Index {
        Index(node: tail?.next)
    }
    // index(after:) 메소드는 index 가 어떻게 증가될 것인가에 대해 정의한다.
    public func index(after i: Index) -> Index {
        Index(node: i.node?.next)
    }
    //
    public subscript(position: Index) -> Value {
        position.node!.value
    }
}
