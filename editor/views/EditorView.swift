import AppKit
import Foundation
import SwiftUI

@Observable
final class EditorModel {
	
}

struct EditorView: NSViewRepresentable {
	
	func makeNSView(context: Context) -> NSView {
		let editorView = EditorNSView()

		let scrollView = NSScrollView()
		scrollView.documentView = editorView

		scrollView.hasVerticalScroller = true
		scrollView.hasHorizontalScroller = true
		scrollView.autohidesScrollers = false

		scrollView.borderType = .noBorder
		scrollView.drawsBackground = true
		scrollView.backgroundColor = .textBackgroundColor

		return scrollView
	}
	
	func updateNSView(_ nsView: NSView, context: Context) {
	}
	
}


class EditorNSView: NSView {
	private var lines: [String] = []
	private var tokens: [Token] = []

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

		let url = URL(fileURLWithPath: "/Users/josh/tmp/test.swift")

		var contents = "Err"
		do {
			contents = try String(contentsOf: url, encoding: .utf8)
		} catch {
			print("Failed to load file: \(error)")
		}
		
		let fileContent = Rope(text: contents)
		tokens = Lexer(text: fileContent.toString()).outputTokens
		lines = fileContent.toString().components(separatedBy: "\n")
		
		updateFrameSize()
		needsDisplay = true
    }

	override var isFlipped: Bool { true }
	
	// hard coded for the moment
	let font = NSFont.monospacedSystemFont(ofSize: 14, weight: .regular)
	var lineHeight: CGFloat { font.ascender - font.descender + font.leading }
	
	let padding: CGFloat = 12
	
	private func updateFrameSize() {
		let height = CGFloat(lines.count) * lineHeight + padding * 2
		self.frame.size = CGSize(width: 2000, height: height)
	}
	
	let defaultColours: [TokenType: NSColor] = [
		.keyword: NSColor(rgb: 0xC1121F),
		.identifier: NSColor.textColor,
		.number: NSColor(rgb: 0x669BBC),
		.string: NSColor(rgb: 0xFF7D00),
		.symbol: NSColor.textColor,
		.returnType: NSColor(rgb: 0x52796F)
	]
	
	override func draw(_ dirtyRect: NSRect) {
		super.draw(dirtyRect)
		
		for i in 0..<lines.count {
			let lineAttr = NSMutableAttributedString(
				string: lines[i],
				attributes: [
					.font: NSFont.monospacedSystemFont(ofSize: 14, weight: .regular),
					.foregroundColor: NSColor.textColor
				]
			)
			
			for token in tokens where token.lineNum == i {
				let range = NSRange(location: token.start, length: token.length)

				if range.location >= 0 &&
				   range.location + range.length <= lineAttr.length {

					lineAttr.addAttribute(
						.foregroundColor,
						value: defaultColours[token.type, default: NSColor.textColor],
						range: range
					)
				} else {
					print("-----")
					print("Invalid token range:")
					print("line:", i)
					print("line text:", lines[i])
					print("line length:", lineAttr.length)
					print("token:", token)
					print("range:", range)
				}
			}

			let lineNumWidth = drawLineNumber(lineNum: i)
			let lineNumberY = i * Int(lineHeight) + Int(padding)
			
			lineAttr.draw(at: CGPoint(x: lineNumWidth + Int(padding * 2), y: lineNumberY + 3))
			
		}
	}
	
	func drawLineNumber(lineNum: Int) -> Int {
		let lineNumAttr = NSAttributedString(
			string: String(lineNum + 1),
			attributes: [
				.font: NSFont.monospacedSystemFont(ofSize: 14, weight: .regular),
				.foregroundColor: NSColor(.gray)
			]
		)
		
		let lineNumberY = lineNum * Int(lineHeight) + Int(padding)
		lineNumAttr.draw(at: CGPoint(x: Int(padding), y: lineNumberY + 3))
		
		return Int(lineNumAttr.size().width)
	}
	
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
