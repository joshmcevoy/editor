import SwiftUI

struct NoFileView: View {
	
	var body: some View {
		Text("No file open").font(.largeTitle)
		Button("Open File or Folder") {
			print("Opened")
		}
	}
	
}
