// MARK: - Intent Definitions
// File: MedwallIntents/Intents/GenerateWallpaperIntent.swift

import Intents

@objc(GenerateWallpaperIntent)
class GenerateWallpaperIntent: INIntent {
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = GenerateWallpaperIntent()
        return copy
    }
}

@objc(GetRandomFactIntent)
class GetRandomFactIntent: INIntent {
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = GetRandomFactIntent()
        return copy
    }
}
