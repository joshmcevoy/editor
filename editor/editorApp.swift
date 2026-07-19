import SwiftUI
import Combine

final class AppState: ObservableObject {
	@Published var currentOpenFile: FileNode? = nil
	@Published var liveShare: Bool = true // live share active? for the moment
	
	init() {
		self.currentOpenFile = FileNode(
			name: "test.swift",
			path: "/Users/josh/tmp2/Rope.swift",
			isDirectory: false,
			children: nil
		)
		self.liveShare = liveShare
	}
}

@main
struct editorApp: App {
	@StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
			//if (appState.currentOpenFile != nil) {
				MainView()
					.environmentObject(appState)
					.navigationTitle("Editor")
			/*} else {
				OpenView()
					.frame(width: 300, height: 300)
			}*/
        }.windowResizability(.contentSize)
		Settings {
			SettingView()
				.environmentObject(appState)
		}
    }
}
