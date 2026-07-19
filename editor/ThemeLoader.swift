import Foundation

struct Theme: Decodable {
	let name: String
	let colours: [String: String]
}

class ThemeLoader {
	
	public init() {
		let loadedTheme = UserDefaults.standard.string(forKey: "currentTheme") ?? "default"
		
		var theme: Theme? = nil
		
		let url = URL(fileURLWithPath: "/Users/josh/tmp/themes/\(loadedTheme).json")
		var contents = "Err"
		do {
			contents = try String(contentsOf: url, encoding: .utf8)
			
			let jsonData = contents.data(using: .utf8)!
			theme = try! JSONDecoder().decode(Theme.self, from: jsonData)
			
		} catch {
			print("Failed to load file: \(error)")
		}
		
		if let theme = theme {
			for (keyword, colour) in theme.colours {
				print(keyword)
				print(TokenType(rawValue: keyword))
				print("\n")
			}
		}
	}
	
}
