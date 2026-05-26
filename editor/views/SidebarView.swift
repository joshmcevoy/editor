import SwiftUI

struct FileRowView: View {
	let file: FileNode
	
	var body: some View {
		HStack {
			Image(systemName: file.isDirectory ? "folder" : "doc.text")
			Text(file.name)
			Spacer()
		}.padding(4)
	}
}

struct SideBar: View {
	let fileList = FileList()
	
	@State private var selectedItem: UUID?
	@EnvironmentObject var appState: AppState

	var body: some View {
		List(selection: $selectedItem) {
			OutlineGroup(fileList.root.children ?? [], children: \.children) { file in
				FileRowView(file: file)
					.listRowSeparator(.hidden)
					.onTapGesture {
						appState.currentOpenFile = file
					}
			}
		}
		.listStyle(.plain)
		.scrollContentBackground(.hidden)
		.frame(width: 180, height: nil, alignment: .topLeading)
		.frame(maxHeight: .infinity, alignment: .topLeading)
	}
}
