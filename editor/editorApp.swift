import SwiftUI

@main
struct editorApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
		Settings {
			SettingView()
		}
    }
}
