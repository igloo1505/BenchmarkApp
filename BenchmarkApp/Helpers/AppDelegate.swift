//
//  AppDelegate.swift
//  BenchmarkApp
//
//  Created by Andrew Mueller on 2/24/21.
//

import UIKit
import Firebase


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("Welp this ran...")
        FirebaseApp.configure()
        return true
    }
}
