import SwiftUI
import Firebase

@main
struct MedWallApp: App {
    @StateObject private var appConfiguration = AppConfiguration()
    
    init() {
        FirebaseApp.configure()
        setupAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appConfiguration)
                .onAppear {
                    appConfiguration.initializeApp()
                }
        }
    }
    
    private func setupAppearance() {
        // Configure global app appearance
        UITabBar.appearance().backgroundColor = UIColor.systemBackground
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor.label
        ]
    }
}
