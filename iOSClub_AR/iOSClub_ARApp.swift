//
//  AppDelegate.swift
//  iOSClub_AR
//
//  Created by Kris on 12/11/21.
//

import SwiftUI
import Firebase


@main
struct iOSClub_ARApp: App
{
    @StateObject var placementSettings = PlacementSettings()
    @StateObject var sessionSettings = SessionSettings()
    
    init()
    {
        FirebaseApp.configure()
        
        Auth.auth().signInAnonymously { authResult, error in
            guard let user = authResult?.user else { return }
            
            let uid = user.uid
            print("當前使用者 \(uid)")
        }
    }
    
    
    var body: some Scene
    {
        WindowGroup
        {
            ContentView()
                .environmentObject(placementSettings)
                .environmentObject(sessionSettings)
        }
    }
}

