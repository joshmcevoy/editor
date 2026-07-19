import AppKit

final class BorderedTransparentView: NSView {

	var borderColor: NSColor = .systemBlue {
		didSet { needsDisplay = true }
	}

	var borderWidth: CGFloat = 2 {
		didSet { needsDisplay = true }
	}

	override var isOpaque: Bool {
		false
	}

	override func draw(_ dirtyRect: NSRect) {
		super.draw(dirtyRect)

		let inset = borderWidth / 2
		let rect = bounds.insetBy(dx: inset, dy: inset)

		let path = NSBezierPath(rect: rect)

		borderColor.setStroke()
		path.lineWidth = borderWidth
		path.stroke()
	}
}
