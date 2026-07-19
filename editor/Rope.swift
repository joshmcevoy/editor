import Foundation

class RopeNode {
	
	private(set) var left: RopeNode?
	private(set) var right: RopeNode?
	private(set) var text: String
	private(set) var lCount: Int
    
    public init(left: RopeNode? = nil, right: RopeNode? = nil, text: String = "", lCount: Int = 0) {
		self.left = left
		self.right = right
		self.text = text
		self.lCount = lCount
    }
    
}

class Rope {
    
	public var root: RopeNode?
	
	init(text: String = "") {
		root = create(text: text)
	}
	
	private func create(text: String) -> RopeNode {
		if (text.count <= 4) {
			return RopeNode(
				left: nil,
				right: nil,
				text: text,
				lCount: text.count
			)
		}
		
		let firstHalf: String = String(text.prefix(text.count / 2))
		let secondHalf: String = String(text.suffix(text.count - (text.count / 2)))
		
		return RopeNode(
			left: self.create(text: firstHalf),
			right: self.create(text: secondHalf),
			text: "",
			lCount: text.count / 2
		)
	}
	
	public func toString(lineFrom: Int = 0, lineTo: Int = 0) -> String {
		let lines = lineTo - lineFrom
		var newLines = 0
		
		func helper(node: RopeNode?) -> String {
			if (node == nil || (newLines == lines && lines != 0)) {
				return ""
			}
			
			if let node, !node.text.isEmpty {
				if (node.text.contains("\n")) {
					newLines += 1
				}
				
				return node.text
			}
			return helper(node: node?.left) + helper(node: node?.right)
		}
		
		return helper(node: self.root)
	}
	
	public func weight(node: RopeNode?) -> Int {
		if let node = node {
			if (node.text != "") {
				return node.text.count
			}
			
			return node.lCount + self.weight(node: node.right)
			
		}
		return 0
	}
	
	public func concat(node1: RopeNode, node2: RopeNode) -> RopeNode {
		return RopeNode(
			left: node1,
			right: node2,
			lCount: self.weight(node: node1)
		)
	}
	
	public func split(index: Int, node: RopeNode) -> (node1: RopeNode, node2: RopeNode) {
		
		// leaf node case
		if (node.right == nil && node.left == nil) {
			let leftText = String(node.text.prefix(index))
			let rightText = String(node.text.suffix(node.text.count - index))
			
			let leftNode = RopeNode(text: leftText)
			let rightNode = RopeNode(text: rightText)
			
			return (leftNode, rightNode)
		}
		
		// internal node case
		let leftChild = node.left!
		let rightChild = node.right!
		let weight = node.lCount
		
		if (index < weight) {
			let (a, b) = split(index: index, node: leftChild)
			
			return (a, self.concat(node1: b, node2: rightChild))
		} else if (index > weight) {
			let localIndex = index - weight
			let (a, b) = split(index: localIndex, node: rightChild)
			
			return (concat(node1: leftChild, node2: a), b)
		} 
		
		return (leftChild, rightChild)
	}
	
	public func insert(index: Int, text: String) {
		let (left, right) = split(index: index, node: self.root!)
		
		self.root = concat(
			node1: concat(
				node1: left,
				node2: RopeNode(text: text)
			),
			node2: right
		)
	}
	
	public func delete(index: Int, length: Int = 1) {
		let (left, remaining) = split(index: index, node: root!)
		let (target, right) = split(index: length, node: remaining)
		
		//todo: add a rebalancing function.
		self.root = concat(node1: left, node2: right)
	}
	
}
