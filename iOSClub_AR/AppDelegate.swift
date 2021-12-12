//
//  AppDelegate.swift
//  iOSClub_AR
//
//  Created by Kris on 12/11/21.
//

import SwiftUI

@main
struct iOSClub_ARApp: App
{
    @StateObject var placementSettings = PlacementSettings()
    
    var body: some Scene
    {
        WindowGroup
        {
            ContentView()
                .environmentObject(placementSettings)
        }
    }
}

