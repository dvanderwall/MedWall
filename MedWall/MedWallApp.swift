//
//  MedWallApp.swift
//  MedWall
//
//  Created by David Vanderwall on 8/3/25.
//

import SwiftUI

@main
struct MedWallApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
