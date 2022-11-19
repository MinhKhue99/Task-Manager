//
//  Task_ManagerApp.swift
//  Task Manager
//
//  Created by Phạm Minh Khuê on 19/11/2022.
//

import SwiftUI

@main
struct Task_ManagerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
