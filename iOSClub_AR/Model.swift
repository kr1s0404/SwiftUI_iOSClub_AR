//
//  Model.swift
//  iOSClub_AR
//
//  Created by Kris on 12/12/21.
//

import SwiftUI
import RealityKit
import Combine

enum ModelCategory: CaseIterable
{
    case Logo
    case iPhone
    case iPad
    case Watch
    case Accessories
    
    var label: String
    {
        get
        {
            switch self
            {
            case .Logo:
                return "Logo"
            case .iPhone:
                return "iPhone"
            case .iPad:
                return "iPad"
            case .Watch:
                return "手錶"
            case .Accessories:
                return "配件"
            }
        }
    }
}

class Model
{
    var name: String
    var category: ModelCategory
    var thumbnail: UIImage
    var modelEntity: ModelEntity?
    var scaleCompensation: Float
    
    private var cancellable: AnyCancellable? // 為了.sink
    
    init(name: String, category: ModelCategory, scaleCompensation: Float = 1.0)
    {
        self.name = name
        self.category = category
        self.thumbnail = UIImage(named: name) ?? UIImage(systemName: "photo")!
        self.scaleCompensation = scaleCompensation
    }
    
    func asyncLoadModelEntity()
    {
        let filename = self.name + ".usdz"
        
        // 異步加載3D模型
        cancellable = ModelEntity.loadModelAsync(named: filename)
            .sink(receiveCompletion: { loadCompletion in
                switch loadCompletion
                {
                    case .failure(let error): print("Error with \(filename)\n, Error: \(error.localizedDescription)")
                    case .finished: break
                }
            }, receiveValue: { modelEntity in
                self.modelEntity = modelEntity
                self.modelEntity?.scale *= self.scaleCompensation // 確保模型符合現實大小
                print("Success: \(self.name)")
            })
    }
}

struct Models
{
    var all: [Model] = []
    
    init()
    {
        // 0.32/100 = 符合實際世界大小
        // Logo
        let iOSClub = Model(name: "iOSClub", category: .Logo, scaleCompensation: 0.32/100)
        let Apple_Logo = Model(name: "Apple_Logo", category: .Logo, scaleCompensation: 0.32/100)
        self.all += [iOSClub, Apple_Logo]
        
        // iPhone
        let iPhone_13_Pro_Max = Model(name: "iPhone_13_Pro_Max", category: .iPhone, scaleCompensation: 0.32/100)
        let iPhone_13 = Model(name: "iPhone_13", category: .iPhone, scaleCompensation: 0.32/100)
        self.all += [iPhone_13_Pro_Max, iPhone_13]
        
        // iPad
        let iPad_Mini_6 = Model(name: "iPad_Mini_6", category: .iPad, scaleCompensation: 0.32/100)
        self.all += [iPad_Mini_6]
        
        // Apple Watch
        let Apple_Watch = Model(name: "Apple_Watch", category: .Watch, scaleCompensation: 0.32/100)
        self.all += [Apple_Watch]
        
        // Accessories
        let AirTag = Model(name: "AirTag", category: .Accessories, scaleCompensation: 0.32/100)
        self.all += [AirTag]
    }
    
    func get(category: ModelCategory) -> [Model]
    {
        return all.filter( { $0.category == category } )
    }
}
