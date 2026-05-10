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
    
	private var root: RopeNode?
	
	init(text: String = "") {
		root = create(text: text)
	}
	
	private func create(text: String) -> RopeNode {
		if (text.count <= 4) {
			return RopeNode(left: nil, right: nil, text: text, lCount: text.count)
		}
		
		let firstHalf: String = String(text.prefix(text.count / 2))
		let secondHalf: String = String(text.suffix(text.count - (text.count / 2)))
		
		let returnRope: RopeNode = RopeNode(left: self.create(text: firstHalf), right: self.create(text: secondHalf), text: "", lCount: text.count / 2)
		return returnRope
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
}
