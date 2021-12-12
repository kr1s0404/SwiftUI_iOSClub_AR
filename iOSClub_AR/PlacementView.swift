//
//  PlacementView.swift
//  iOSClub_AR
//
//  Created by Kris on 12/12/21.
//

import SwiftUI

struct PlacementView: View
{
    @EnvironmentObject var placementSettings: PlacementSettings
    
    
    var body: some View
    {
        HStack
        {
            Spacer()
            
            PlacementButton(systemName: "xmark.circle.fill")
            {
                // 取消所選模型
                placementSettings.selectedModel = nil
            }
            
            Spacer()
            
            PlacementButton(systemName: "checkmark.circle.fill")
            {
                // 指派選擇模型
                placementSettings.confirmedModel = placementSettings.selectedModel
                
                // 指派完之後把它給清空
                placementSettings.selectedModel = nil
            }
            
            Spacer()
        }
        .padding(25)
    }
}

struct PlacementButton: View
{
    let systemName: String
    let action: () -> Void
    
    var body: some View
    {
        Button(action: {
            action()
        }) {
            Image(systemName: systemName)
                .font(.system(size: 50, weight: .light, design: .default))
                .foregroundColor(.white)
                .buttonStyle(PlainButtonStyle())
        }
        .frame(width: 75, height: 75)
    }
}

