import Foundation

class Theme {
	
	public init() {
		let loadedTheme = UserDefaults.standard.string(forKey: "currentTheme") ?? "default"
		
		let url = URL(fileURLWithPath: "/Users/josh/tmp/themes/\(loadedTheme).json")
		var contents = "Err"
		do {
			contents = try String(contentsOf: url, encoding: .utf8)
		} catch {
			print("Failed to load file: \(error)")
		}
		
		print(contents)
	}
	
}
