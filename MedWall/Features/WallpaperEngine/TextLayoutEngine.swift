// MARK: - Text Layout Engine
// File: MedWall/Features/WallpaperEngine/TextLayoutEngine.swift

import UIKit
import CoreText

class TextLayoutEngine {
    
    struct TextLayout {
        let attributedText: NSAttributedString
        let frame: CGRect
        let lineHeight: CGFloat
        let alignment: NSTextAlignment
    }
    
    func calculateLayout(text: String, theme: WallpaperTheme, canvasSize: CGSize) -> TextLayout {
        let font = UIFont.systemFont(
            ofSize: theme.textStyle.fontSize.pointSize,
            weight: theme.textStyle.fontWeight.uiKitWeight
        )
        
        let textColor = UIColor(hex: theme.colorScheme.textColor) ?? .white
        let shadowColor = UIColor(hex: theme.colorScheme.shadowColor) ?? .black
        
        var attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: textColor
        ]
        
        // Add shadow if enabled
        if theme.textStyle.shadowEnabled {
            let shadow = NSShadow()
            shadow.shadowColor = shadowColor.withAlphaComponent(0.5)
            shadow.shadowOffset = CGSize(width: 1, height: 1)
            shadow.shadowBlurRadius = 2
            attributes[.shadow] = shadow
        }
        
        // Add paragraph style
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = theme.textStyle.textAlignment.nsTextAlignment
        paragraphStyle.lineSpacing = CGFloat(theme.textStyle.lineSpacing)
        attributes[.paragraphStyle] = paragraphStyle
        
        let attributedText = NSAttributedString(string: text, attributes: attributes)
        
        // Calculate text frame
        let maxWidth = canvasSize.width * 0.8 // 80% of screen width
        let maxHeight = canvasSize.height * 0.6 // 60% of screen height
        
        let textSize = attributedText.boundingRect(
            with: CGSize(width: maxWidth, height: maxHeight),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        ).size
        
        let textFrame = CGRect(
            x: (canvasSize.width - textSize.width) / 2,
            y: (canvasSize.height - textSize.height) / 2,
            width: textSize.width,
            height: textSize.height
        )
        
        return TextLayout(
            attributedText: attributedText,
            frame: textFrame,
            lineHeight: font.lineHeight,
            alignment: theme.textStyle.textAlignment.nsTextAlignment
        )
    }
}
