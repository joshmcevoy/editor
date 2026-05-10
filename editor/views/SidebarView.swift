import SwiftUI

struct FileNode: Identifiable {
	let id = UUID()
	let name: String
	let path: String
	var isDirectory: Bool = false
	var children: [FileNode] = []
}

class FileList {
	
	var root: FileNode
	
	init() {
		root = FileList.scanDirectory(path: "/Users/josh/tmp")
		printNodes(node: root)
	}
	
	static func scanDirectory(path: String) -> FileNode {
		var node = FileNode(
			name: URL(fileURLWithPath: path).lastPathComponent,
			path: path,
			isDirectory: true
		)
		
		do {
			let items = try FileManager.default.contentsOfDirectory(
				at: URL(string: path)!,
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
					node.children.append(childDirectory)
				} else {
					let childFile = FileNode(
						name: item.lastPathComponent,
						path: item.path,
						isDirectory: false
					)

					node.children.append(childFile)
				}
				
			}
		} catch {
			print("Err")
		}
		
		return node
	}
	
	func printNodes(node: FileNode, depth: Int = 0) {
		for node in node.children {
			print(String(repeating: "-", count: depth) + node.name)
			printNodes(node: node, depth: depth + 1)
		}
	}
	
}

struct FileItem: Identifiable {
	let id: Int
	let name: String
	let isFolder: Bool
}

struct FileRowView: View {
	let file: FileItem
	
	var body: some View {
		HStack {
			Image(systemName: file.isFolder ? "folder" : "doc.text")
			Text(file.name)
			Spacer()
		}.padding(4)
	}
}

struct SideBar: View {
    var body: some View {
		let files: [FileItem] = [FileItem(id: 1, name: "hi", isFolder: false), FileItem(id: 1, name: "hi 2", isFolder: true)]
		
		List(files) { file in
			FileRowView(file: file).listRowSeparator(.hidden)
		}
		.listStyle(.plain)
		.scrollContentBackground(.hidden)
		.frame(width: 180, height: nil, alignment: .topLeading)
		.frame(maxHeight: .infinity, alignment: .topLeading)
    }
}
