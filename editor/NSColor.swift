// Source - https://stackoverflow.com/a/24263296
// Posted by Sulthan, modified by community. See post 'Timeline' for change history
// Retrieved 2026-05-10, License - CC BY-SA 3.0

// Usage:
// let color = NSColor(red: 0xFF, green: 0xFF, blue: 0xFF)
// let color2 = NSColor(rgb: 0xFFFFFF)

import AppKit

extension NSColor {
   convenience init(red: Int, green: Int, blue: Int) {
	   assert(red >= 0 && red <= 255, "Invalid red component")
	   assert(green >= 0 && green <= 255, "Invalid green component")
	   assert(blue >= 0 && blue <= 255, "Invalid blue component")

	   self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
	   self.init(
		   red: (rgb >> 16) & 0xFF,
		   green: (rgb >> 8) & 0xFF,
		   blue: rgb & 0xFF
	   )
   }
}
