import Cocoa

enum BinaryTree<T: Comparable> { //Enums allow for associated values
    
    case empty
    indirect case node(BinaryTree<T>, T, BinaryTree<T>) //indirect will allow passing references to values instead of the values
    
    var count: Int { //logic
        switch self {
        case let .node(left, _, right):
            return left.count + 1 + right.count
        case .empty: //empty will show at "leaf" of binary tree
            return 0
        }
    }
    
    
    mutating func naiveInsert(newValue: T) { //Code for insert. 'mutating' will allow change in value type
        
        guard case .node(var left, let value, var right) = self else {
            
            self = .node(.empty, newValue, .empty) //formatting for node
            return
        }
        
        
        if newValue < value {
            left.naiveInsert(newValue: newValue)
        } else {
            right.naiveInsert(newValue: newValue)
        }
        
    }
    
    private func newTreeWithInsertedValue(newValue: T) -> BinaryTree { //handles insertion
        switch self {
        
        case .empty:
            return .node(.empty, newValue, .empty)
        case let .node(left, value, right):
            if newValue < value { //ensures that smaller value is on left
                return .node(left.newTreeWithInsertedValue(newValue: newValue), value, right)
            } else {
                return .node(left, value, right.newTreeWithInsertedValue(newValue: newValue))
            }
        }
    }
    
    mutating func insert(newValue: T) {
        self = newTreeWithInsertedValue(newValue: newValue)
    }
    
    func traverseInOrder(process: (T) -> ()) { //Handles 'in order traversal', meaning will go left and farthest down, then move right one node, move up and right one branch, etc
        switch self {
        case .empty: //will finish if/when empty
            return
        case let .node(left, value, right):
            left.traverseInOrder(process: process)
            process(value)
            right.traverseInOrder(process: process)
        }
    }
    
    func traversePreOrder( process: (T) -> ()) { //'PreOrder' will visit the current node first
        switch self {
        case .empty:
            return
        case let .node(left, value, right):
            process(value)
            left.traversePreOrder(process: process)
            right.traversePreOrder(process: process)
        }
    }
    
    func traversePostOrder( process: (T) -> ()) { //'PostOrder' will visit the other nodes before the current node
        switch self {
        case .empty:
            return
        case let .node(left, value, right):
            left.traversePostOrder(process: process)
            right.traversePostOrder(process: process)
            process(value)
        }
    }
    
    func search(searchValue: T) -> BinaryTree? { //using 'tree.search(searchValue: 3)' it will show where in the tree that number is.
        switch self {
        case .empty:
            return nil
        case let .node(left, value, right):
            
            if searchValue == value {
                return self
            }
            
            if searchValue < value {
                return left.search(searchValue: searchValue)
            } else {
                return right.search(searchValue: searchValue)
            }
        }
    }
}

extension BinaryTree: CustomStringConvertible { //handles console logging which shows structure of tree
    var description: String {
        switch self {
        case let .node(left, value, right):
            return "value: \(value), left = [" + left.description + "], right = [" + right.description + "]"
        case .empty:
            return ""
        }
    }
}

// leaf nodes
let node5 = BinaryTree.node(.empty, "5", .empty)
let nodeA = BinaryTree.node(.empty, "a", .empty)
let node10 = BinaryTree.node(.empty, "10", .empty)
let node4 = BinaryTree.node(.empty, "4", .empty)
let node3 = BinaryTree.node(.empty, "3", .empty)
let nodeB = BinaryTree.node(.empty, "b", .empty)

// intermediate nodes on the left
let Aminus10 = BinaryTree.node(nodeA, "-", node10)
let timesLeft = BinaryTree.node(node5, "*", Aminus10)

// intermediate nodes on the right
let minus4 = BinaryTree.node(.empty, "-", node4)
let divide3andB = BinaryTree.node(node3, "/", nodeB)
let timesRight = BinaryTree.node(minus4, "*", divide3andB)

// root node
var tree: BinaryTree<Int> = .empty
tree.insert(newValue: 7)
tree.insert(newValue: 10)
tree.insert(newValue: 2)
tree.insert(newValue: 1)
tree.insert(newValue: 5)
tree.insert(newValue: 9)
tree.insert(newValue: 3)

tree.traverseInOrder { print($0) }
tree.search(searchValue: 5)

//Will print values in order. Thanks for reading :)


