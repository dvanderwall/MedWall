// MARK: - Wallpaper Generator
// File: MedWall/Features/WallpaperEngine/WallpaperGenerator.swift

import UIKit
import CoreGraphics
import Photos

class WallpaperGenerator: ObservableObject {
    static let shared = WallpaperGenerator()
    
    private let textLayoutEngine = TextLayoutEngine()
    private let backgroundImageManager = BackgroundImageManager()
    private let typographyRenderer = TypographyRenderer()
    
    private init() {}
    
    func generateWallpaper(fact: MedicalFact, theme: WallpaperTheme) async -> UIImage? {
        let screenSize = UIScreen.main.bounds.size
        let scale = UIScreen.main.scale
        
        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                let renderer = UIGraphicsImageRenderer(
                    size: screenSize,
                    format: UIGraphicsImageRendererFormat()
                )
                
                let image = renderer.image { context in
                    let cgContext = context.cgContext
                    
                    // Draw background
                    self.drawBackground(theme: theme, in: cgContext, size: screenSize)
                    
                    // Calculate text layout
                    let textLayout = self.textLayoutEngine.calculateLayout(
                        text: fact.content,
                        theme: theme,
                        canvasSize: screenSize
                    )
                    
                    // Render text
                    self.typographyRenderer.renderText(
                        layout: textLayout,
                        theme: theme,
                        in: cgContext
                    )
                    
                    // Add watermark/branding if needed
                    self.addBranding(in: cgContext, size: screenSize)
                }
                
                DispatchQueue.main.async {
                    continuation.resume(returning: image)
                }
            }
        }
    }
    
    func generateAndSetWallpaper(fact: MedicalFact, theme: WallpaperTheme) async {
        guard let wallpaper = await generateWallpaper(fact: fact, theme: theme) else {
            Logger.shared.log("Failed to generate wallpaper", level: .error)
            return
        }
        
        // Save to Photos app
        await saveWallpaperToPhotos(wallpaper)
        
        // Trigger shortcut to set wallpaper (iOS limitation workaround)
        ShortcutsService.shared.triggerWallpaperUpdate()
    }
    
    private func drawBackground(theme: WallpaperTheme, in context: CGContext, size: CGSize) {
        let rect = CGRect(origin: .zero, size: size)
        
        switch theme.backgroundType {
        case .solid(let colorHex):
            if let color = UIColor(hex: colorHex) {
                context.setFillColor(color.cgColor)
                context.fill(rect)
            }
            
        case .gradient(let colors):
            let cgColors = colors.compactMap { UIColor(hex: $0)?.cgColor }
            if let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                       colors: cgColors as CFArray,
                                       locations: nil) {
                context.drawLinearGradient(
                    gradient,
                    start: CGPoint(x: 0, y: 0),
                    end: CGPoint(x: size.width, y: size.height),
                    options: []
                )
            }
            
        case .image(let imageName):
            if let image = UIImage(named: imageName) {
                image.draw(in: rect)
            }
            
        case .medical(let type):
            drawMedicalBackground(type: type, in: context, size: size)
        }
    }
    
    private func drawMedicalBackground(type: WallpaperTheme.BackgroundType.MedicalImageType,
                                     in context: CGContext, size: CGSize) {
        // Implementation for medical-themed backgrounds
        let rect = CGRect(origin: .zero, size: size)
        
        switch type {
        case .minimal:
            // Clean gradient
            let colors = [UIColor.systemBlue.cgColor, UIColor.systemTeal.cgColor]
            if let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                       colors: colors as CFArray,
                                       locations: nil) {
                context.drawLinearGradient(
                    gradient,
                    start: CGPoint(x: 0, y: 0),
                    end: CGPoint(x: size.width, y: size.height),
                    options: []
                )
            }
        case .abstract:
            // Abstract medical pattern
            drawAbstractMedicalPattern(in: context, size: size)
        default:
            // Default background
            context.setFillColor(UIColor.systemBlue.cgColor)
            context.fill(rect)
        }
    }
    
    private func drawAbstractMedicalPattern(in context: CGContext, size: CGSize) {
        // Draw subtle medical-themed abstract pattern
        context.setFillColor(UIColor.systemBlue.cgColor)
        context.fill(CGRect(origin: .zero, size: size))
        
        // Add subtle pattern elements
        context.setStrokeColor(UIColor.white.withAlphaComponent(0.1).cgColor)
        context.setLineWidth(1.0)
        
        // Draw grid pattern
        let spacing: CGFloat = 50
        for i in stride(from: 0, through: size.width, by: spacing) {
            context.move(to: CGPoint(x: i, y: 0))
            context.addLine(to: CGPoint(x: i, y: size.height))
        }
        for i in stride(from: 0, through: size.height, by: spacing) {
            context.move(to: CGPoint(x: 0, y: i))
            context.addLine(to: CGPoint(x: size.width, y: i))
        }
        context.strokePath()
    }
    
    private func addBranding(in context: CGContext, size: CGSize) {
        // Add subtle MedWall branding
        let brandingText = "MedWall"
        let font = UIFont.systemFont(ofSize: 10, weight: .light)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.white.withAlphaComponent(0.3)
        ]
        
        let brandingSize = brandingText.size(withAttributes: attributes)
        let brandingRect = CGRect(
            x: size.width - brandingSize.width - 10,
            y: size.height - brandingSize.height - 10,
            width: brandingSize.width,
            height: brandingSize.height
        )
        
        brandingText.draw(in: brandingRect, withAttributes: attributes)
    }
    
    private func saveWallpaperToPhotos(_ image: UIImage) async {
        do {
            try await PHPhotoLibrary.shared().performChanges {
                PHAssetCreationRequest.creationRequestForAsset(from: image)
            }
            Logger.shared.log("Wallpaper saved to Photos")
        } catch {
            Logger.shared.log("Failed to save wallpaper: \(error)", level: .error)
        }
    }
}
