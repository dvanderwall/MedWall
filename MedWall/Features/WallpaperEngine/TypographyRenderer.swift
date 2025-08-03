// MARK: - Typography Renderer
// File: MedWall/Features/WallpaperEngine/TypographyRenderer.swift

import UIKit
import CoreText

class TypographyRenderer {
    
    func renderText(layout: TextLayoutEngine.TextLayout, theme: WallpaperTheme, in context: CGContext) {
        // Flip coordinate system for Core Text
        context.saveGState()
        context.textMatrix = .identity
        context.translateBy(x: 0, y: layout.frame.maxY)
        context.scaleBy(x: 1, y: -1)
        
        // Create Core Text frame
        let path = CGPath(rect: CGRect(origin: .zero, size: layout.frame.size), transform: nil)
        let framesetter = CTFramesetterCreateWithAttributedString(layout.attributedText)
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
        
        // Draw the text
        CTFrameDraw(frame, context)
        
        context.restoreGState()
    }
}
