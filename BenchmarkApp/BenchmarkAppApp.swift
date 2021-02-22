//
//  BenchmarkAppApp.swift
//  BenchmarkApp
//
//  Created by Andrew Mueller on 2/22/21.
//

import SwiftUI

@main
struct BenchmarkAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
