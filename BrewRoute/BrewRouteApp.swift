//
//  BrewRouteApp.swift
//  BrewRoute
//
//  Created by Julian Pomales on 2/24/25.
//

import SwiftUI
import FirebaseCore

@main
struct BrewRouteApp: App {
    init() {
        FirebaseApp.configure()  // Initialize Firebase
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

