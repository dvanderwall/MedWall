// MARK: - Shared Utilities
// File: MedWall/Shared/Utilities/Logger.swift

import Foundation
import os.log

class Logger {
    static let shared = Logger()
    
    private let logger = os.Logger(subsystem: Bundle.main.bundleIdentifier ?? "MedWall", category: "general")
    
    enum Level {
        case debug, info, warning, error
        
        var osLogType: OSLogType {
            switch self {
            case .debug: return .debug
            case .info: return .info
            case .warning: return .default
            case .error: return .error
            }
        }
    }
    
    func log(_ message: String, level: Level = .info) {
        logger.log(level: level.osLogType, "\(message)")
    }
    
    private init() {}
}
