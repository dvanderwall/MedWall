// MARK: - Main Tab View
// File: MedWall/Features/Main/MainTabView.swift

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Tab = .home
    
    enum Tab: CaseIterable {
        case home, library, settings, statistics
        
        var title: String {
            switch self {
            case .home: return "Home"
            case .library: return "Library"
            case .settings: return "Settings"
            case .statistics: return "Stats"
            }
        }
        
        var icon: String {
            switch self {
            case .home: return "house"
            case .library: return "books.vertical"
            case .settings: return "gear"
            case .statistics: return "chart.bar"
            }
        }
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: Tab.home.icon)
                    Text(Tab.home.title)
                }
                .tag(Tab.home)
            
            LibraryView()
                .tabItem {
                    Image(systemName: Tab.library.icon)
                    Text(Tab.library.title)
                }
                .tag(Tab.library)
            
            SettingsView()
                .tabItem {
                    Image(systemName: Tab.settings.icon)
                    Text(Tab.settings.title)
                }
                .tag(Tab.settings)
            
            StatisticsView()
                .tabItem {
                    Image(systemName: Tab.statistics.icon)
                    Text(Tab.statistics.title)
                }
                .tag(Tab.statistics)
        }
        .accentColor(.blue)
    }
}
