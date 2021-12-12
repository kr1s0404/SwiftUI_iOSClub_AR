//
//  ControlView.swift
//  iOSClub_AR
//
//  Created by Kris on 12/12/21.
//

import SwiftUI

struct ControlView: View
{
    @Binding var isControlVisible: Bool
    @Binding var showBrowse: Bool

    
    var body: some View
    {
        VStack
        {
            ControVisibilityToggleButton(isControlVisible: $isControlVisible)
            
            Spacer()
            
            if isControlVisible
            {
                ControlButtonBar(showBrowse: $showBrowse)
            }
        }
    }
}

struct ControVisibilityToggleButton: View
{
    @Binding var isControlVisible: Bool
    
    var body: some View
    {
        HStack
        {
            Spacer()
            
            ZStack
            {
                Color.black.opacity(0.3)
                
                Button(action: {
                    isControlVisible.toggle()
                }) {
                    Image(systemName: isControlVisible ? "rectangle" : "slider.horizontal.below.rectangle")
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                        .buttonStyle(PlainButtonStyle())
                }
            }
            .frame(width: 50, height: 50)
            .cornerRadius(8)
        }
        .padding(.top, 35)
        .padding(.trailing, 20)
    }
}

struct ControlButtonBar: View
{
    @Binding var showBrowse: Bool
    
    @EnvironmentObject var placementSettings: PlacementSettings
    
    var body: some View
    {
        HStack
        {
            
            // 最近使用過的模型
            mostRecentlyPlacedButton().hidden(placementSettings.recentlyPlaced.isEmpty)
            
            Spacer()
            
            // 瀏覽模型頁面
            ControlButton(systemName: "square.grid.2x2", action: {
                showBrowse.toggle()
            })
                .sheet(isPresented: $showBrowse, content: {
                    BrowseView(showBrowse: $showBrowse)
                })
            
            Spacer()
            
            // 設定頁面
            ControlButton(systemName: "slider.horizontal.3", action: {
                
            })
        }
        .frame(maxWidth: 500)
        .padding(25)
        .background(Color.black.opacity(0.3))
    }
}

struct ControlButton: View
{
    let systemName: String
    let action: () -> Void
    
    var body: some View
    {
        Button(action: {
            action()
        }) {
            Image(systemName: systemName)
                .font(.system(size: 35))
                .foregroundColor(.white)
                .buttonStyle(PlainButtonStyle())
        }
        .frame(width: 50, height: 50)
    }
}

struct mostRecentlyPlacedButton: View
{
    @EnvironmentObject var placementSettigns: PlacementSettings
    
    var body: some View
    {
        Button(action: {
            placementSettigns.selectedModel = placementSettigns.recentlyPlaced.last
        }) {
            // 如果最近放置的model array不為空陣列的話，就顯示最近放置模型的縮圖
            if let mostRecentlyPlcaedModel = placementSettigns.recentlyPlaced.last
            {
                Image(uiImage: mostRecentlyPlcaedModel.thumbnail)
                    .resizable()
                    .frame(width: 46)
                    .aspectRatio(1/1, contentMode: .fit)
            }
            else // 如果最近放置的陣列為空的話，就顯示時鐘
            {
                // 已經被hidden取代掉了，所以不會顯示時鐘
                Image(systemName: "clock.arrow.circlepath")
                    .font(.system(size: 35))
                    .foregroundColor(.white)
                    .buttonStyle(PlainButtonStyle())
            }
        }
        .frame(width: 50, height: 50)
        .background(Color.white)
        .cornerRadius(8)
    }
}



struct ControlView_Previews: PreviewProvider
{
    static var previews: some View
    {
        ContentView()
    }
}
