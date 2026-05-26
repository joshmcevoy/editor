import SwiftUI

struct MainView: View {
	@EnvironmentObject var appState: AppState
	
    var body: some View {
        HStack(spacing: 0) {
			NavigationSplitView {
				SideBar()
			} detail: {
				VStack {
					
					if (appState.currentOpenFile != nil) {
						TabBar()
							.frame(maxWidth: .infinity)
						
						EditorView(loadedFile: appState.currentOpenFile)
						.frame(maxWidth: .infinity, maxHeight: .infinity)
					} else {
						NoFileView()
					}
					
				}
			}
        }
    }
}

#Preview {
    MainView()
}
