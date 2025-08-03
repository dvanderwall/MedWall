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
        // Temporarily disable shortcuts setup until proper intent definition files are created
        Logger.shared.log("Shortcuts setup temporarily disabled - intent definition files needed")
        
        // TODO: Create proper .intentdefinition files in Xcode and uncomment below
        // setupGenerateWallpaperShortcut()
        // setupGetRandomFactShortcut()
    }
    
    func triggerWallpaperUpdate() {
        // Trigger the wallpaper update shortcut
        // This would typically use URLScheme or other iOS integration
        Logger.shared.log("Triggering wallpaper update shortcut")
        
        // For now, just post a notification that the wallpaper should be updated
        NotificationCenter.default.post(name: .wallpaperUpdateRequested, object: nil)
    }
    
    private func setupGenerateWallpaperShortcut() {
        // This will be implemented once proper intent definition files are created
        Logger.shared.log("Generate wallpaper shortcut setup")
    }
    
    private func setupGetRandomFactShortcut() {
        // This will be implemented once proper intent definition files are created
        Logger.shared.log("Random fact shortcut setup")
    }
}

// MARK: - Notification Names
extension Notification.Name {
    static let wallpaperUpdateRequested = Notification.Name("wallpaperUpdateRequested")
}
