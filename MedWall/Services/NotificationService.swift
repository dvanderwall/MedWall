// MARK: - Notification Service
// File: MedWall/Services/NotificationService.swift

import UserNotifications
import UIKit

class NotificationService: NSObject, ObservableObject {
    static let shared = NotificationService()
    
    @Published var authorizationStatus: UNAuthorizationStatus = .notDetermined
    
    private override init() {
        super.init()
        checkAuthorizationStatus()
    }
    
    func requestPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    Logger.shared.log("Notification permission error: \(error)", level: .error)
                }
                self.checkAuthorizationStatus()
            }
        }
    }
    
    func scheduleWallpaperRotationReminder(interval: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = "New Medical Fact Available"
        content.body = "Your wallpaper is ready to be updated with a new medical fact!"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: true)
        let request = UNNotificationRequest(identifier: "wallpaper-rotation", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                Logger.shared.log("Failed to schedule notification: \(error)", level: .error)
            }
        }
    }
    
    func scheduleDailyLearningReminder(at hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Daily Learning Reminder"
        content.body = "Time to review your medical facts and maintain your streak!"
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "daily-reminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                Logger.shared.log("Failed to schedule daily reminder: \(error)", level: .error)
            }
        }
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    private func checkAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.authorizationStatus = settings.authorizationStatus
            }
        }
    }
}
