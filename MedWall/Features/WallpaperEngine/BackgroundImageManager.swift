// MARK: - Background Image Manager
// File: MedWall/Features/WallpaperEngine/BackgroundImageManager.swift

import UIKit

class BackgroundImageManager {
    
    func getBackgroundImage(for theme: WallpaperTheme) -> UIImage? {
        switch theme.backgroundType {
        case .image(let imageName):
            return UIImage(named: imageName)
        case .medical(let type):
            return getMedicalBackgroundImage(type: type)
        default:
            return nil
        }
    }
    
    private func getMedicalBackgroundImage(type: WallpaperTheme.BackgroundType.MedicalImageType) -> UIImage? {
        // Return appropriate medical background images
        switch type {
        case .minimal:
            return createMinimalBackground()
        case .abstract:
            return createAbstractMedicalBackground()
        default:
            return nil
        }
    }
    
    private func createMinimalBackground() -> UIImage {
        // Create a simple gradient background
        let size = UIScreen.main.bounds.size
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { context in
            let colors = [UIColor.systemBlue.cgColor, UIColor.systemTeal.cgColor]
            let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                    colors: colors as CFArray,
                                    locations: nil)
            
            if let gradient = gradient {
                context.cgContext.drawLinearGradient(
                    gradient,
                    start: .zero,
                    end: CGPoint(x: size.width, y: size.height),
                    options: []
                )
            }
        }
    }
    
    private func createAbstractMedicalBackground() -> UIImage {
        // Create an abstract medical-themed background
        let size = UIScreen.main.bounds.size
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { context in
            // Base gradient
            let colors = [UIColor.systemBlue.cgColor, UIColor.systemIndigo.cgColor]
            let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                    colors: colors as CFArray,
                                    locations: nil)
            
            if let gradient = gradient {
                context.cgContext.drawLinearGradient(
                    gradient,
                    start: .zero,
                    end: CGPoint(x: size.width, y: size.height),
                    options: []
                )
            }
            
            // Add subtle medical symbols
            context.cgContext.setStrokeColor(UIColor.white.withAlphaComponent(0.1).cgColor)
            context.cgContext.setLineWidth(2.0)
            
            // Draw plus symbols
            let symbolSize: CGFloat = 20
            for x in stride(from: symbolSize, to: size.width, by: symbolSize * 4) {
                for y in stride(from: symbolSize, to: size.height, by: symbolSize * 4) {
                    drawPlusSymbol(in: context.cgContext, center: CGPoint(x: x, y: y), size: symbolSize)
                }
            }
        }
    }
    
    private func drawPlusSymbol(in context: CGContext, center: CGPoint, size: CGFloat) {
        let halfSize = size / 2
        
        // Vertical line
        context.move(to: CGPoint(x: center.x, y: center.y - halfSize))
        context.addLine(to: CGPoint(x: center.x, y: center.y + halfSize))
        
        // Horizontal line
        context.move(to: CGPoint(x: center.x - halfSize, y: center.y))
        context.addLine(to: CGPoint(x: center.x + halfSize, y: center.y))
        
        context.strokePath()
    }
}
