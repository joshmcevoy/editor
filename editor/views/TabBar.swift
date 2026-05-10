import SwiftUI

struct EditorTab: Identifiable {
	let id: Int
	let name: String
}

struct EditorTabView: View {
	let Tab: EditorTab
	@State private var hovered = false
	
	var body: some View {
		HStack {
			Image(systemName: "doc.text").foregroundStyle(hovered ? .black : .white)
			Text(Tab.name).foregroundStyle(hovered ? .black : .white)
		}.padding(10)
			.background(hovered ? .gray : .black)
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
	var body: some View {
		let tabs: [EditorTab] = [EditorTab(id: 0, name: "Test"), EditorTab(id: 1, name: "Test2"), EditorTab(id: 2, name: "Test3"), EditorTab(id: 3, name: "Test4"), EditorTab(id: 4, name: "Test5")]
		
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
