import SwiftUI
import Combine

final class AppState: ObservableObject {
	@Published var currentOpenFile: FileNode? = nil
	
	init() {
		self.currentOpenFile = FileNode(
			name: "test.swift",
			path: "/Users/josh/tmp2/Rope.swift",
			isDirectory: false,
			children: nil
		)
	}
}

@main
struct editorApp: App {
	@StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            MainView()
				.environmentObject(appState)
				.navigationTitle("Editor")
        }
		Settings {
			SettingView()
				.environmentObject(appState)
		}
    }
}
