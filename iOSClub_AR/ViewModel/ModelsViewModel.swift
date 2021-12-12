//
//  ModelsViewModel.swift
//  iOSClub_AR
//
//  Created by Kris on 12/13/21.
//

import Foundation
import SwiftUI
import FirebaseFirestore


class ModelsViewModel: ObservableObject
{
    @Published var models: [Model] = []
    
    private let datebase = Firestore.firestore()
    
    func fetchData()
    {
        datebase.collection("Models").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Firebase資料庫中沒有這個文件")
                return
            }
            
            self.models = documents.map { (queryDocumentSnapshot) -> Model in
                let data = queryDocumentSnapshot.data()
                
                let name = data["name"] as? String ?? ""
                let categoryText = data["category"] as? String ?? ""
                let category = ModelCategory(rawValue: categoryText)
                let scaleCompensation = data["scaleCompensation"] as? Double ?? 1.0
                
                return Model(name: name, category: category!, scaleCompensation: Float(scaleCompensation))
            }
        }
    }
}
