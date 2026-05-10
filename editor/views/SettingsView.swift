import SwiftUI

struct SettingView: View {
	@State private var selectedTheme = "Theme 1"

	var body: some View {
		let themes = ["Theme 1", "Theme 2"]
		
		TabView {
			Tab("Theme", systemImage: "paintbrush") {
				VStack {
					Text("Chosen theme")
					Picker("Chose a theme", selection: $selectedTheme) {
						ForEach(themes, id: \.self) {
							Text($0)
						}
					}
					.pickerStyle(.menu)
				}
			}
		}
		.scenePadding()
		.frame(maxWidth: 350, minHeight: 100)
	}
}
