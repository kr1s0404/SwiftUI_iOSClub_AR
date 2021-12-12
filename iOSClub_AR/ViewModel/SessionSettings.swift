//
//  SessionSettings.swift
//  iOSClub_AR
//
//  Created by Kris on 12/12/21.
//

import SwiftUI

class SessionSettings: ObservableObject
{
    @Published var isPeopleOcclusionEnabled: Bool = false
    @Published var isObjectOcclusionEnabled: Bool = false
    @Published var isLidarDebugEnabled: Bool = false
    @Published var isMultiuserEnabled: Bool = false
    
}


