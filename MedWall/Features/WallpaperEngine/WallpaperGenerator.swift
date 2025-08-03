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
        Logger.shared.log("Generating wallpaper for fact: \(fact.content.prefix(50))...")
        
        let screenSize = await UIScreen.main.bounds.size
        let scale = await UIScreen.main.scale
        
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
        
        Logger.shared.log("Wallpaper generated successfully")
        
        // Save to Photos app (with permission handling)
        await saveWallpaperToPhotos(wallpaper)
        
        // Trigger shortcut to set wallpaper (iOS limitation workaround)
        await MainActor.run {
            ShortcutsService.shared.triggerWallpaperUpdate()
        }
    }
    
    private func drawBackground(theme: WallpaperTheme, in context: CGContext, size: CGSize) {
        let rect = CGRect(origin: .zero, size: size)
        
        switch theme.backgroundType {
        case .solid(let colorHex):
            if let color = UIColor(hex: colorHex) {
                context.setFillColor(color.cgColor)
                context.fill(rect)
            } else {
                Logger.shared.log("Invalid color hex: \(colorHex)", level: .warning)
                context.setFillColor(UIColor.systemBlue.cgColor)
                context.fill(rect)
            }
            
        case .gradient(let colors):
            let cgColors = colors.compactMap { UIColor(hex: $0)?.cgColor }
            if cgColors.count >= 2,
               let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                       colors: cgColors as CFArray,
                                       locations: nil) {
                context.drawLinearGradient(
                    gradient,
                    start: CGPoint(x: 0, y: 0),
                    end: CGPoint(x: size.width, y: size.height),
                    options: []
                )
            } else {
                Logger.shared.log("Invalid gradient colors: \(colors)", level: .warning)
                // Fallback to default gradient
                let defaultColors = [UIColor.systemBlue.cgColor, UIColor.systemPurple.cgColor]
                if let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                           colors: defaultColors as CFArray,
                                           locations: nil) {
                    context.drawLinearGradient(gradient, start: .zero, end: CGPoint(x: size.width, y: size.height), options: [])
                }
            }
            
        case .image(let imageName):
            if let image = UIImage(named: imageName) {
                image.draw(in: rect)
            } else {
                Logger.shared.log("Image not found: \(imageName)", level: .warning)
                drawDefaultBackground(in: context, size: size)
            }
            
        case .medical(let type):
            drawMedicalBackground(type: type, in: context, size: size)
        }
    }
    
    private func drawDefaultBackground(in context: CGContext, size: CGSize) {
        let colors = [UIColor.systemBlue.cgColor, UIColor.systemPurple.cgColor]
        if let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                   colors: colors as CFArray,
                                   locations: nil) {
            context.drawLinearGradient(
                gradient,
                start: .zero,
                end: CGPoint(x: size.width, y: size.height),
                options: []
            )
        }
    }
    
    private func drawMedicalBackground(type: WallpaperTheme.BackgroundType.MedicalImageType,
                                     in context: CGContext, size: CGSize) {
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
    
    @MainActor
    private func saveWallpaperToPhotos(_ image: UIImage) async {
        do {
            // Check permission status first
            let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
            
            switch status {
            case .notDetermined:
                let newStatus = await PHPhotoLibrary.requestAuthorization(for: .addOnly)
                if newStatus == .authorized || newStatus == .limited {
                    try await performSave(image)
                } else {
                    Logger.shared.log("Photos permission denied", level: .warning)
                }
            case .denied, .restricted:
                Logger.shared.log("Photos access denied or restricted", level: .warning)
            case .authorized, .limited:
                try await performSave(image)
            @unknown default:
                Logger.shared.log("Unknown photo library authorization status", level: .warning)
            }
        } catch {
            Logger.shared.log("Failed to save wallpaper: \(error)", level: .error)
        }
    }
    
    @MainActor
    private func performSave(_ image: UIImage) async throws {
        try await PHPhotoLibrary.shared().performChanges {
            PHAssetCreationRequest.creationRequestForAsset(from: image)
        }
        Logger.shared.log("Wallpaper saved to Photos")
    }
}
