import SwiftUI

struct EditorTab: Identifiable {
	let id: Int
	let name: String
}

struct EditorTabView: View {
	let Tab: EditorTab
	@State private var hovered = false
	@EnvironmentObject var appState: AppState
	
	var body: some View {
		HStack {
			Image(systemName: "doc.text").foregroundStyle(.black)
			Text(Tab.name).foregroundStyle(.black)
			if hovered {
				Image(systemName: "x.circle").foregroundStyle(.black)
					.onTapGesture {
						appState.currentOpenFile = nil
					}
			}
		}.padding(10)
			.background(hovered ? Color(NSColor(rgb: 0xd2d2d2)) : Color(NSColor(rgb: 0xF0F0F0)))
			.cornerRadius(20)
			.onHover { hovering in
				withAnimation(.easeInOut(duration: 0.1)) {
					hovered = hovering
				}
				
				if hovering {
					NSCursor.pointingHand.push()
				} else {
					NSCursor.pop()
				}
			}
	}
}

struct TabBar: View {
	@EnvironmentObject var appState: AppState
	
	var body: some View {
		let tabs: [EditorTab] = [EditorTab(id: 0, name: appState.currentOpenFile?.name ?? "No file selected")]
		
		HStack {
			ForEach(tabs) { tab in
				EditorTabView(Tab: tab)
			}
			
			Spacer()
		}
			.frame(maxWidth: .infinity, alignment: .leading)
			.padding(.leading, 24)
			.padding(.vertical, 6)
	}
}
