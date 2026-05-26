import SwiftUI

struct FileNode: Identifiable {
	let id = UUID()
	let name: String
	let path: String
	var isDirectory: Bool = false
	var children: [FileNode]? = nil
}
