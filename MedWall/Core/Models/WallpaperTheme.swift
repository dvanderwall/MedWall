// MARK: - WallpaperTheme (needed for preview)
// File: MedWall/Core/Models/WallpaperTheme.swift

import SwiftUI

struct WallpaperTheme: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String
    let backgroundType: BackgroundType
    let textStyle: TextStyle
    let colorScheme: ColorScheme
    let isUserCreated: Bool
    
    enum BackgroundType: Codable {
        case gradient(colors: [String]) // Hex color strings
        case image(name: String)
        case solid(color: String) // Hex color string
        case medical(type: MedicalImageType)
        
        enum MedicalImageType: String, CaseIterable, Codable {
            case anatomy = "anatomy"
            case xray = "xray"
            case microscopic = "microscopic"
            case abstract = "abstract"
            case minimal = "minimal"
        }
    }
    
    struct TextStyle: Codable {
        let fontFamily: FontFamily
        let fontSize: FontSize
        let fontWeight: FontWeight
        let textAlignment: TextAlignment
        let lineSpacing: Double
        let shadowEnabled: Bool
        
        enum FontFamily: String, CaseIterable, Codable {
            case system = "System"
            case sanFrancisco = "San Francisco"
            case helvetica = "Helvetica"
            case avenir = "Avenir"
            case georgia = "Georgia"
        }
        
        enum FontSize: String, CaseIterable, Codable {
            case small = "Small"
            case medium = "Medium"
            case large = "Large"
            case extraLarge = "Extra Large"
            
            var pointSize: CGFloat {
                switch self {
                case .small: return 16
                case .medium: return 20
                case .large: return 24
                case .extraLarge: return 28
                }
            }
        }
        
        enum FontWeight: String, CaseIterable, Codable {
            case light = "Light"
            case regular = "Regular"
            case medium = "Medium"
            case semibold = "Semibold"
            case bold = "Bold"
            
            var weight: Font.Weight {
                switch self {
                case .light: return .light
                case .regular: return .regular
                case .medium: return .medium
                case .semibold: return .semibold
                case .bold: return .bold
                }
            }
        }
        
        enum TextAlignment: String, CaseIterable, Codable {
            case leading = "Leading"
            case center = "Center"
            case trailing = "Trailing"
            
            var alignment: Alignment {
                switch self {
                case .leading: return .leading
                case .center: return .center
                case .trailing: return .trailing
                }
            }
        }
    }
    
    struct ColorScheme: Codable {
        let textColor: String // Hex color
        let backgroundColor: String // Hex color
        let accentColor: String // Hex color
        let shadowColor: String // Hex color
        let adaptsToDarkMode: Bool
    }
    
    // Default theme for initial setup
    static let defaultTheme = WallpaperTheme(
        id: UUID(),
        name: "Clinical Blue",
        description: "Professional blue gradient with clean typography",
        backgroundType: .gradient(colors: ["#2196F3", "#64B5F6"]),
        textStyle: TextStyle(
            fontFamily: .sanFrancisco,
            fontSize: .medium,
            fontWeight: .semibold,
            textAlignment: .center,
            lineSpacing: 1.2,
            shadowEnabled: true
        ),
        colorScheme: ColorScheme(
            textColor: "#FFFFFF",
            backgroundColor: "#2196F3",
            accentColor: "#FF5722",
            shadowColor: "#000000",
            adaptsToDarkMode: true
        ),
        isUserCreated: false
    )
}
