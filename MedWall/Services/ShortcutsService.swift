// MARK: - iOS Shortcuts Service
// File: MedWall/Services/ShortcutsService.swift

import Intents
import IntentsUI

class ShortcutsService: NSObject, ObservableObject {
    static let shared = ShortcutsService()
    
    private override init() {
        super.init()
    }
    
    func setupDefaultShortcuts() {
        setupGenerateWallpaperShortcut()
        setupGetRandomFactShortcut()
    }
    
    func triggerWallpaperUpdate() {
        // Trigger the wallpaper update shortcut
        // This would typically use URLScheme or other iOS integration
        Logger.shared.log("Triggering wallpaper update shortcut")
    }
    
    private func setupGenerateWallpaperShortcut() {
        let intent = GenerateWallpaperIntent()
        intent.suggestedInvocationPhrase = "Update my medical wallpaper"
        
        let shortcut = INShortcut(intent: intent)
        
        INVoiceShortcutCenter.shared.setShortcutSuggestions([shortcut])
    }
    
    private func setupGetRandomFactShortcut() {
        let intent = GetRandomFactIntent()
        intent.suggestedInvocationPhrase = "Tell me a medical fact"
        
        let shortcut = INShortcut(intent: intent)
        
        INVoiceShortcutCenter.shared.setShortcutSuggestions([shortcut])
    }
}
