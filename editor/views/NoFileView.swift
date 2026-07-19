import SwiftUI
internal import UniformTypeIdentifiers

struct NoFileView: View {
	
	@State private var isImporting: Bool = false
	@EnvironmentObject var appState: AppState
	
	var body: some View {

		Text("No file open").font(.largeTitle)
		Button("Open File or Folder") {
			isImporting = true
		}.fileImporter(isPresented: $isImporting, allowedContentTypes: [.item], onCompletion: { result in
			switch result {
			case .success(let url):
				appState.currentOpenFile = FileNode(
					name: url.lastPathComponent,
					path: url.path
				)
			case .failure(let error):
				print(error)
			}
		})
	}
	
}
