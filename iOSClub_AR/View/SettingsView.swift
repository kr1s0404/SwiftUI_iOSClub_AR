//
//  SessionView.swift
//  iOSClub_AR
//
//  Created by Kris on 12/12/21.
//

import SwiftUI

enum Setting
{
    case peopleOcclusion
    case objectOcclusion
    case lidarDebug
    case multiuser
    
    var label:  String
    {
        get
        {
            switch self
            {
            case .peopleOcclusion:
                return "人物遮蔽"
            case .objectOcclusion:
                return "物體遮蔽"
            case .lidarDebug:
                return "LiDar"
            case .multiuser:
                return "多人模式"
            }
        }
    }
    
    var systemName: String
    {
        get
        {
            switch self
            {
            case .peopleOcclusion:
                return "person.fill.viewfinder"
            case .objectOcclusion:
                return "cube.transparent.fill"
            case .lidarDebug:
                return "camera.aperture"
            case .multiuser:
                return "person.3.fill"
            }
        }
    }
}

struct SettingsView: View
{
    @Binding var showSettings: Bool
    
    
    var body: some View
    {
        NavigationView
        {
            SettingGrid()
                .navigationBarTitle(Text("設定"))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar
                {
                    ToolbarItemGroup(placement: .navigationBarTrailing)
                    {
                        Button(action: {
                            showSettings.toggle()
                        }) {
                            Text("完成")
                                .bold()
                        }
                    }
                }
        }
    }
}



struct SettingGrid: View
{
    @EnvironmentObject var sessionSettings: SessionSettings
    
    private var girdItemLayout = [GridItem(.adaptive(minimum: 100, maximum: 100), spacing: 25)]
    
    
    var body: some View
    {
        ScrollView
        {
            LazyVGrid(columns: girdItemLayout, spacing: 15)
            {
                SettingToggleButton(setting: .peopleOcclusion, isOn: $sessionSettings.isPeopleOcclusionEnabled)
                SettingToggleButton(setting: .objectOcclusion, isOn: $sessionSettings.isObjectOcclusionEnabled)
                SettingToggleButton(setting: .lidarDebug, isOn: $sessionSettings.isLidarDebugEnabled)
                SettingToggleButton(setting: .multiuser, isOn: $sessionSettings.isMultiuserEnabled)
                
            }
        }
        .padding(.top, 35)
    }
}


struct SettingToggleButton: View
{
    let setting: Setting
    
    @Binding var isOn: Bool
    
    
    var body: some View
    {
        Button(action: {
            isOn.toggle()
            print("\(#file) - \(setting): \(isOn.description)")
        }) {
            VStack
            {
                Image(systemName: setting.systemName)
                    .font(.system(size: 35))
                    .foregroundColor(isOn ? Color.green : Color(UIColor.secondaryLabel))
                    .buttonStyle(PlainButtonStyle())
                
                Text(setting.label)
                    .font(.system(size: 17, weight: .medium, design: .default))
                    .foregroundColor(isOn ? Color(UIColor.label) : Color(UIColor.secondaryLabel))
                    .padding(5)
            }
        }
        .frame(width: 100, height: 100)
        .background(Color(UIColor.secondarySystemFill))
        .cornerRadius(20)
    }
}
