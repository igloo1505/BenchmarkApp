//
//  BenchmarkAppApp.swift
//  BenchmarkApp
//
//  Created by Andrew Mueller on 2/22/21.
//

import SwiftUI
import Firebase



@main struct BenchmarkAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @ObservedObject var userAuth = UserAuth()
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            if self.userAuth.authToken == nil {
                LoginView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(userAuth)
            }
            else {
                CategoriesView()
                    .environmentObject(userAuth)
            }
        }
    }
    
    class AppDelegate: UIResponder, UIApplicationDelegate {
        func application(_ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions:
            [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
      }
    }
    
}
