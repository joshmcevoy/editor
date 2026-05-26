import SwiftUI

class FileList {
	
	var root: FileNode
	
	init() {
		root = FileList.scanDirectory(path: "/Users/josh/tmp2")
		//printNodes(node: root)
	}
	
	static func scanDirectory(path: String) -> FileNode {
		var node = FileNode(
			name: URL(fileURLWithPath: path).lastPathComponent,
			path: path,
			isDirectory: true,
			children: []
		)
		
		do {
			let items = try FileManager.default.contentsOfDirectory(
				at: URL(fileURLWithPath: path),
				includingPropertiesForKeys: [.isDirectoryKey],
				options: []
			)
			
			for item in items {
				let values = try item.resourceValues(forKeys: [.isDirectoryKey])
				let isDir = values.isDirectory ?? false
				
				if (item.lastPathComponent.first == ".") {
					continue
				}
				
				if isDir {
					let childDirectory = scanDirectory(path: item.path)
					node.children?.append(childDirectory)
				} else {
					let childFile = FileNode(
						name: item.lastPathComponent,
						path: item.path,
						isDirectory: false,
						children: nil
					)

					node.children?.append(childFile)
				}
				
			}
		} catch {
			print("Err")
		}
		
		return node
	}
	/*
	func printNodes(node: FileNode, depth: Int = 0) {
		for node in node.children! {
			print(String(repeating: "-", count: depth) + node.name)
			printNodes(node: node, depth: depth + 1)
		}
	}*/
	
}
