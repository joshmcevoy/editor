import AppKit
import Foundation
import SwiftUI

struct EditorView: NSViewRepresentable {
	
	let loadedFile: FileNode?
	
	func makeNSView(context: Context) -> NSScrollView {
		let editorView = EditorNSView(loadedFile: loadedFile)
		
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
	
	func updateNSView(_ scrollView: NSScrollView, context: Context) {
		guard let editorView = scrollView.documentView as? EditorNSView else {
			return
		}

		editorView.loadedFile = loadedFile
		editorView.needsDisplay = true
	}
}

struct Cursor {
	var row: Int = 0
	var col: Int = 0
}

class EditorNSView: NSView {
	private var fileContent: Rope? = nil
	private var lines: [String] = []
	private var tokens: [Token] = []
	
	public var loadedFile: FileNode? = nil {
		didSet {
			cursor = Cursor(row: 0, col: 0)
			loadFile()
			needsDisplay = true
		}
	}
	
	private var cursor: Cursor = Cursor(row: 0, col: 0)
	
	var lineIndexes: [Int] = []
	private func rebuildLineIndexes() {
		lineIndexes = [0]
		
		var index = 0
		
		for line in lines.dropLast() {
			index += line.count + 1
			lineIndexes.append(index)
		}
	}
	
	init(loadedFile: FileNode?) {
		self.loadedFile = loadedFile
		super.init(frame: .zero)
		
		loadFile()
		loadTheme()
		
		let liveshare = LiveShare()
	}
	
	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		
		needsDisplay = true
	}
	
	func loadFile() {
		let url = URL(fileURLWithPath: loadedFile?.path ?? "err")
		
		var contents = "Err"
		do {
			contents = try String(contentsOf: url, encoding: .utf8)
		} catch {
			print("Failed to load file: \(error)")
		}
		
		fileContent = Rope(text: contents)
		tokens = Lexer(text: fileContent!.toString()).outputTokens
		
		lines = fileContent!.toString().components(separatedBy: "\n")
		
		rebuildLineIndexes()
		updateFrameSize()
	}
	
	let loadedTheme: [TokenType: NSColor] = [:]
	
	func loadTheme() {
		let defaultTheme = "default.json"
		
		let themeLoader = ThemeLoader()
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
	
	// MARK: Drawing
	
	private var gutterWidth: CGFloat {
		textWidth(text: String(lines.count))
	}
	
	private var textStartX: CGFloat {
		padding + gutterWidth + padding
	}
	
	private var textStartY: CGFloat {
		padding + 3
	}
	
	override func draw(_ dirtyRect: NSRect) {
		super.draw(dirtyRect)
		
		
		for i in 0..<lines.count {
			//fix tabs being unevenly spaced
			let paragraphStyle = NSMutableParagraphStyle()
			paragraphStyle.defaultTabInterval = textWidth() * 4
			paragraphStyle.tabStops = []
			
			let lineAttr = NSMutableAttributedString(
				string: lines[i],
				attributes: [
					.font: NSFont.monospacedSystemFont(ofSize: 14, weight: .regular),
					.foregroundColor: NSColor.textColor,
					.paragraphStyle: paragraphStyle
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
				} /*else {
				   print("-----")
				   print("Invalid token range:")
				   print("line:", i)
				   print("line text:", lines[i])
				   print("line length:", lineAttr.length)
				   print("token:", token)
				   print("range:", range)
				   }*/
			}
			
			drawLineNumber(lineNum: i)
			let lineY = textStartY + CGFloat(i) * lineHeight
			
			lineAttr.draw(at: CGPoint(
				x: textStartX,
				y: lineY
			))
		}
		
		drawCursor()
	}
	
	func drawLineNumber(lineNum: Int) {
		let lineNumAttr = NSAttributedString(
			string: String(lineNum + 1),
			attributes: [
				.font: font,
				.foregroundColor: NSColor.gray
			]
		)
		
		let lineY = textStartY + CGFloat(lineNum) * lineHeight
		
		lineNumAttr.draw(at: CGPoint(
			x: padding,
			y: lineY
		))
	}
	
	func textWidth(text: String = "A") -> CGFloat {
		let lineNumAttr = NSAttributedString(
			string: text,
			attributes: [
				.font: NSFont.monospacedSystemFont(ofSize: 14, weight: .regular),
				.foregroundColor: NSColor(.gray)
			]
		)
		
		return lineNumAttr.size().width
	}
	
	func drawCursor() {
		guard cursor.row >= 0, cursor.row < lines.count else { return }
		
		let x = textStartX + CGFloat(cursor.col) * textWidth()
		let y = textStartY + CGFloat(cursor.row) * lineHeight
		
		/*
		 print(cursor.col)
		 print(cursor.row)
		 print("-----")
		 */
		
		
		let cursorRect = NSRect(
			x: floor(x),
			y: y,
			width: 1.5,
			height: lineHeight
		)
		
		NSColor.textColor.setFill()
		cursorRect.fill()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: Editor interaction
	
	override func resetCursorRects() {
		let cursorRect = self.bounds
		self.addCursorRect(cursorRect, cursor: .iBeam)
	}
	
	override func mouseDown(with event: NSEvent) {
		let locationInView = convert(event.locationInWindow, from: nil)
		
		let clickedX = locationInView.x - textStartX
		let clickedY = locationInView.y
		
		let clickedCol = Int(clickedX / textWidth())
		let clickedRow = Int(clickedY / lineHeight) - 1
		
		let line = lines[clickedRow]
		
		cursor.col = clickedCol
		cursor.row = clickedRow
		
		needsDisplay = true
	}
	
	override var acceptsFirstResponder: Bool { return true }
	
	private var tabsInLine: Int {
		return lines[cursor.row].count { $0 == "\t" }
	}
	
	// convert cursor loc to text index
	private var getIndex: Int {
		return lineIndexes[cursor.row] + cursor.col - (tabsInLine * 3)
	}
	
	func updateCursorPos(row: Int, col: Int) {
		print("updating cursor pos")
		guard cursor.row + row <= lines.count && cursor.row + row > 0  else { return }
		guard cursor.col + col <= lines[cursor.row].count + (tabsInLine * 3) && cursor.col + col >= 0 else { return }
		
		if (row != 0) {
			// if cursor is at the end of a line, wrap it to the end of the next
			if (cursor.col > lines[cursor.row + row].count) {
				cursor.col = lines[cursor.row + row].count + (tabsInLine * 3)
			}
		}
		
		cursor.row += row
		cursor.col += col
		
		reloadText()
	}
	
	private func reloadText() {
		let text = fileContent!.toString()

		lines = text.components(separatedBy: "\n")
		tokens = Lexer(text: text).outputTokens
		rebuildLineIndexes()
		updateFrameSize()
		needsDisplay = true
	}
	
	func insert(char: String) {
		fileContent?.insert(index: getIndex, text: char)

		reloadText()
		cursor.col += char.count
	}
	
	func delete(row: Int, col: Int) {
		guard getIndex > 0 else { return }
		fileContent?.delete(index: getIndex - 1)
		
		reloadText()
		cursor.col -= 1
	}
	
	override func keyDown(with event: NSEvent) {
		if let specialKey = event.specialKey {
			switch specialKey {
			case .upArrow:
				updateCursorPos(row: -1, col: 0)
			case .downArrow:
				updateCursorPos(row: 1, col: 0)
			case .leftArrow:
				updateCursorPos(row: 0, col: -1)
			case .rightArrow:
				updateCursorPos(row: 0, col: 1)
			case .delete:
				delete(row: cursor.row, col: cursor.col)
			default:
				super.keyDown(with: event)
				return
			}
			
			needsDisplay = true
			return
		}
		
		if event.keyCode == 48 {
			print("Tab key detected via keyCode")
			return // Stop the event from propagating
		}
		
		if let char = event.characters {
			insert(char: char)
		}
		
	}
	
}
