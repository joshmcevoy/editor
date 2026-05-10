import Foundation

enum TokenType {
	case whitespace
	case keyword
	case identifier
	case number
	case string
	case symbol
	case returnType
	case none
}

struct Token {
	var type: TokenType = TokenType.none
	var text: String = ""
	var start: Int = 0
	var length: Int = 0
	var lineNum: Int = 0
}

class Lexer {
	
	public var output: [(TokenType, String)] = []
	
	public var outputTokens: [Token] = []
	
	public init(text: String) {
		let rules: [(TokenType, Regex<AnyRegexOutput>)] = [
			(.returnType, Regex(/^(?:->|:)\s*([A-Za-z_][A-Za-z0-9_]*)/)),
			(.whitespace, Regex(/^\n/)),
			(.whitespace, Regex(/^[ \t]+/)),
			// hardcoded keywords for the moment
			(.keyword, Regex(/^(let|var|func|class|import|private|public|init|return|if|else|while|for|in|as|is|catch|throws|throw|self|true|false|nil)\b/)),
			(.identifier, Regex(/^[A-Za-z_][A-Za-z0-9_]*/)),
			(.number, Regex(/^\d+(\.\d+)?/)),
			(.string, Regex(/^"([^"\\]|\\.)*"/)),
			(.symbol, Regex(/^[{}()\[\].,;=+\-*\/]/)),
			
		]
		
		var testString = text
		var lineNum = 0
		var pos = 0
		
		while testString.count > 0 {
			var matchedSomething = false
			var newToken = Token(text: String(testString.first!))

			for (tokenType, regex) in rules {
				if let match = testString.firstMatch(of: regex) {
					let matchedText = String(match.0)
					let tokenLength = match.0.count
					
					newToken = Token(
						type: tokenType,
						text: matchedText,
						start: pos,
						length: tokenLength,
						lineNum: lineNum
					)
					
					testString = String(testString.dropFirst(tokenLength))
					outputTokens.append(newToken)
					
					if (matchedText.contains("\n")) {
						let parts = matchedText.components(separatedBy: "\n")

						lineNum += parts.count - 1
						pos = parts.last?.count ?? 0
					  } else {
						pos += tokenLength
					}
					
					
					matchedSomething = true
					break
				}
				
			}
			
			// Unknown token
			if !matchedSomething {
				outputTokens.append(Token(
					type: .none,
					text: String(testString.first!),
					start: pos,
					length: 1,
					lineNum: lineNum
				))

				testString = String(testString.dropFirst(1))
				pos += 1
			}
		}

	}
	
}
