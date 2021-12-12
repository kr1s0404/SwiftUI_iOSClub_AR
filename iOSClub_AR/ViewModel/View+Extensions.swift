//
//  View+Extensions.swift
//  iOSClub_AR
//
//  Created by Kris on 12/12/21.
//

import SwiftUI

extension View
{
    
    // Dynamically Hide/Unhide SwiftUI View
    @ViewBuilder func hidden(_ shouldHide: Bool) -> some View
    {
        switch shouldHide
        {
            case true:
                self.hidden()
            case false:
                self
        }
    }
}
