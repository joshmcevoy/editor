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

struct PickerOption: Identifiable {
	let id = UUID()
	let title: String
	let symbol: String
}

struct SideBar: View {
	let fileList = FileList()
	
	@State private var selectedItem: UUID?
	@State private var selectedFilter = "Files"
	@State private var digit1: String = "1"
	@EnvironmentObject var appState: AppState

	let options = [
		PickerOption(title: "Files", symbol: "folder"),
		PickerOption(title: "Live Share", symbol: "folder")
	]
	
	var body: some View {
		VStack(alignment: .center) {
			Picker("", selection: $selectedFilter) {
				ForEach(options) { option in
					Text("\(Image(systemName: option.symbol)) \(option.title)")
						.tag(option.title)
				}
			}
			.pickerStyle(.segmented)

			if selectedFilter == "Files" {
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

			} else {
				VStack {

					HStack(spacing: 12) {
						RoundedRectangle(cornerRadius: 10)
							.fill(Color(NSColor(rgb: 0xF0F0F0)))
							.aspectRatio(1, contentMode: .fit)
							.overlay(TextField("1", text: $digit1), alignment: .center)

						RoundedRectangle(cornerRadius: 10)
							.fill(Color(NSColor(rgb: 0xF0F0F0)))
							.aspectRatio(1, contentMode: .fit)
							.overlay(Text("2"), alignment: .center)

						RoundedRectangle(cornerRadius: 10)
							.fill(Color(NSColor(rgb: 0xF0F0F0)))
							.aspectRatio(1, contentMode: .fit)
							.overlay(Text("3"), alignment: .center)

						RoundedRectangle(cornerRadius: 10)
							.fill(Color(NSColor(rgb: 0xF0F0F0)))
							.aspectRatio(1, contentMode: .fit)
							.overlay(Text("4"), alignment: .center)
					}
					.frame(maxWidth: .infinity, alignment: .center)
					.padding(10)
				}

				Spacer()
			}
		}
		.frame(maxHeight: .infinity, alignment: .topLeading)
	}
}
