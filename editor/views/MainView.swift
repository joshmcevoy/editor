import SwiftUI

struct MainView: View {
	@EnvironmentObject var appState: AppState
	
    var body: some View {
        HStack(spacing: 0) {
			HStack {
				SideBar()
					.frame(maxWidth: 200, maxHeight: .infinity)
				VStack {
					if (appState.currentOpenFile != nil) {
						TabBar()
							.frame(maxWidth: .infinity)
						HStack {
							EditorView(loadedFile: appState.currentOpenFile)
								.frame(maxWidth: .infinity, maxHeight: .infinity)
						}
						StatusBar()
							.frame(maxWidth: .infinity, maxHeight: 20)
							.background(.gray)
					} else {
						NoFileView()
					}
					
				}
			}
			
			/*
			NavigationSplitView {
				SideBar()
					.scrollContentBackground(.hidden)
					.background {
						Color(nsColor: .windowBackgroundColor)
							.ignoresSafeArea()
					}
			} detail: {
				VStack {
					if (appState.currentOpenFile != nil) {
						TabBar()
							.frame(maxWidth: .infinity)
						HStack {
							EditorView(loadedFile: appState.currentOpenFile)
								.frame(maxWidth: .infinity, maxHeight: .infinity)
						}
						StatusBar()
							.frame(maxWidth: .infinity, maxHeight: 20)
							.background(.gray)
					} else {
						NoFileView()
					}
					
				}
			}*/
        }
    }
}
