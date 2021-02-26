//
//  Authentication.swift
//  BenchmarkApp
//
//  Created by Andrew Mueller on 2/24/21.
//

import Foundation
import SwiftUI
import Combine


class UserAuth: ObservableObject {
    @Published var isAuthenticated: Bool = false {
        didSet {
            print("Fired this mothafucka")
            print(oldValue)
            print(self.isAuthenticated)
        }
    }
    @Published var authToken: String?
    @Published var userName: String?
}
