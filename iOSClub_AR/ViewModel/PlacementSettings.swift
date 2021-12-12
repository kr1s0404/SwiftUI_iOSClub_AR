//
//  PlacementSettings.swift
//  iOSClub_AR
//
//  Created by Kris on 12/12/21.
//

import SwiftUI
import RealityKit
import Combine

class PlacementSettings: ObservableObject
{
    // 當使用者在BrowseView選擇模型時，這個變數會被呼叫
    @Published var selectedModel: Model?
    {
        willSet(newValue)
        {
            print("以選中 \(String(describing: newValue?.name))")
        }
    }
    
    // 當使用者選擇要放置的模型時，被選中的模型會(selectedModel)被指派到確認模型(confirmedModel)
    @Published var confirmedModel: Model?
    {
        willSet(newValue)
        {
            guard let model = newValue else {
                print("清除確認模型")
                return
            }
            
            print("選定模型為\(model.name)")
            
            recentlyPlaced.append(model)
        }
    }
    
    // 這個變數替ScenceEvents.Update訂閱者(Subscriber)保留Cancellable物件
    var senceObserver: Cancellable?
    
    // 這個變數保留了最近使用過的模型，最後一個index存放的會是最後一個使用的model
    @Published var recentlyPlaced: [Model] = []
    
}
