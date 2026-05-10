import SwiftUI

struct MainView: View {
    var body: some View {
        HStack(spacing: 0) {
			NavigationSplitView {
				SideBar()
			} detail: {
				VStack {
					TabBar()
						.frame(maxWidth: .infinity)
					 
					EditorView()
						.frame(maxWidth: .infinity, maxHeight: .infinity)
				}
			}
            
			
        }
    }
}

#Preview {
    MainView()
}
