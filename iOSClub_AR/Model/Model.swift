//
//  Model.swift
//  iOSClub_AR
//
//  Created by Kris on 12/12/21.
//

import SwiftUI
import RealityKit
import Combine

enum ModelCategory: String, CaseIterable
{
    case Logo
    case iPhone
    case iPad
    case iMac
    case mac
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
            case .iMac:
                return "iMac"
            case .mac:
                return "mac"
            case .Watch:
                return "手錶"
            case .Accessories:
                return "配件"
            }
        }
    }
}

class Model: ObservableObject, Identifiable
{
    var id: String = UUID().uuidString
    var name: String
    var category: ModelCategory
    @Published var thumbnail: UIImage
    var modelEntity: ModelEntity?
    var scaleCompensation: Float
    
    private var cancellable: AnyCancellable? // 為了.sink
    
    init(name: String, category: ModelCategory, scaleCompensation: Float = 1.0)
    {
        self.name = name
        self.category = category
        self.thumbnail = UIImage(systemName: "photo")!
        self.scaleCompensation = scaleCompensation
        
        FirebaseStorageHelper.asyncDownloadToFileSystem(relativePath: "thumbnails/\(self.name).png") { localURL in
            do
            {
                let imageData = try Data(contentsOf: localURL)
                self.thumbnail = UIImage(data: imageData) ?? self.thumbnail
            }
            catch
            {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func asyncLoadModelEntity()
    {
        FirebaseStorageHelper.asyncDownloadToFileSystem(relativePath: "models/\(self.name).usdz") { localURL in
            
            // 異步加載3D模型
            self.cancellable = ModelEntity.loadModelAsync(contentsOf: localURL)
                .sink(receiveCompletion: { loadCompletion in
                    switch loadCompletion
                    {
                    case .failure(let error): print("Error with \(self.name)\n, Error: \(error.localizedDescription)")
                        case .finished: break
                    }
                }, receiveValue: { modelEntity in
                    self.modelEntity = modelEntity
                    self.modelEntity?.scale *= self.scaleCompensation // 確保模型符合現實大小
                    print("Success: \(self.name)")
                })
        }
    }
}

// 舊版取得模型的方式，新版改成用存在firebase上面
//struct Models
//{
//    var all: [Model] = []
//
//    init()
//    {
//        // scaleCompensation = 實際世界大小
//        // Logo
//        let iOSClub = Model(name: "iOSClub", category: .Logo, scaleCompensation: 150/100)
//        let Apple_Logo = Model(name: "Apple_Logo", category: .Logo, scaleCompensation: 10/100)
//        self.all += [iOSClub, Apple_Logo]
//
//        // iPhone
//        let iPhone_13_Pro_Max = Model(name: "iPhone_13_Pro_Max", category: .iPhone, scaleCompensation: 10/100)
//        let iPhone_13 = Model(name: "iPhone_13", category: .iPhone, scaleCompensation: 10/100)
//        let iPhone_12_Pro = Model(name: "iPhone_12_Pro", category: .iPhone, scaleCompensation: 10/100)
//        self.all += [iPhone_13_Pro_Max, iPhone_13, iPhone_12_Pro]
//
//        // iPad
//        let iPad_Mini_6 = Model(name: "iPad_Mini_6", category: .iPad, scaleCompensation: 10/100)
//        let iPad_Pro = Model(name: "iPad_Pro", category: .iPad, scaleCompensation: 10/100)
//        self.all += [iPad_Mini_6, iPad_Pro]
//
//        // iMac
//        let iMac = Model(name: "iMac", category: .iMac, scaleCompensation: 10/100)
//        self.all += [iMac]
//
//        // mac
//        let Mac_Mini_M1 = Model(name: "Mac_Mini_M1", category: .mac, scaleCompensation: 10/100)
//        self.all += [Mac_Mini_M1]
//
//        // Apple Watch
//        let Apple_Watch = Model(name: "Apple_Watch", category: .Watch, scaleCompensation: 5/100)
//        self.all += [Apple_Watch]
//
//        // Accessories
//        let AirTag = Model(name: "AirTag", category: .Accessories, scaleCompensation: 10/100)
//        self.all += [AirTag]
//    }
//
//    func get(category: ModelCategory) -> [Model]
//    {
//        return all.filter( { $0.category == category } )
//    }
//}
