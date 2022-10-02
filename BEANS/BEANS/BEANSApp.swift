//
//  BEANSApp.swift
//  BEANS
//
//  Created by Brian Liew on 9/20/22.
//

import SwiftUI

@main
struct BEANSApp: App {
    private var persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
