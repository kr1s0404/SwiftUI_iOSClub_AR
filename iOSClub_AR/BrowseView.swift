//
//  BrowseView.swift
//  iOSClub_AR
//
//  Created by Kris on 12/12/21.
//

import SwiftUI

struct BrowseView: View
{
    @Binding var showBrowse: Bool
    
    var body: some View
    {
        NavigationView
        {
            ScrollView(showsIndicators: false)
            {
                RecentGird(showBrowse: $showBrowse)
                ModelsByCategoryGrid(showBrowse: $showBrowse)
            }
            .navigationTitle(Text("可以使用的模型"))
            .toolbar
            {
                ToolbarItemGroup(placement: .navigationBarTrailing)
                {
                    Button(action: {
                        showBrowse.toggle()
                    }) {
                        Text("完成")
                            .bold()
                    }
                }
            }
        }
    }
}

struct RecentGird: View
{
    @EnvironmentObject var placementSettings: PlacementSettings
    
    @Binding var showBrowse: Bool
    
    var body: some View
    {
        // 如果最近使用模型陣列不為空的話
        if !placementSettings.recentlyPlaced.isEmpty
        {
            HorizontalGrid(showBrowse: $showBrowse, title: "最近使用", items: getRecentsUniqueOrder())
        }
    }
    
    func getRecentsUniqueOrder() -> [Model]
    {
        var recentsUniqueOrderArray: [Model] = []
        
        // 尚未被排列的set
        var modelNameSet: Set<String> = []
        
        for model in placementSettings.recentlyPlaced.reversed() // 將陣列反轉，第一個陣列元素為最常使用，最後面的元素為最少使用
        {
            if !modelNameSet.contains(model.name) // 確保不會有重複的model name跑進去陣列
            {
                recentsUniqueOrderArray.append(model)
                modelNameSet.insert(model.name)
            }
        }
        
        return recentsUniqueOrderArray
    }
}


struct ModelsByCategoryGrid: View
{
    let models = Models()
    
    @Binding var showBrowse: Bool
    
    var body: some View
    {
        VStack
        {
            ForEach(ModelCategory.allCases, id: \.self) { category in
                if let modelsByCategory = models.get(category: category)
                {
                    HorizontalGrid(showBrowse: $showBrowse, title: category.label, items: modelsByCategory)
                }
            }
        }
    }
}


struct HorizontalGrid: View
{
    // 固定每個模型的大小都是150
    private let gridItemLayout = [GridItem(.fixed(150))]
    
    @Binding var showBrowse: Bool
    
    @EnvironmentObject var placementSettings: PlacementSettings
    
    var title: String
    var items: [Model]
    
    
    var body: some View
    {
        VStack(alignment: .leading)
        {
            Separator()
            
            Text(title)
                .font(.title2.bold())
                .padding(.leading, 22)
                .padding(.top, 10)
            
            ScrollView(.horizontal, showsIndicators: false)
            {
                LazyHGrid(rows: gridItemLayout, spacing: 30)
                {
                    ForEach(items.indices) { i in
                        
                        let model = items[i]
                        ItemButton(model: model)
                        {
                            model.asyncLoadModelEntity()
                            self.placementSettings.selectedModel = model
                            print("選中\(model.name)作為放置目標")
                            showBrowse = false
                        }
                    }
                }
                .padding(.horizontal, 22)
                .padding(.vertical, 10)
            }
        }
    }
}

struct ItemButton: View
{
    let model: Model
    let action: () -> Void
    
    var body: some View
    {
        Button(action: {
            action()
        }) {
            Image(uiImage: model.thumbnail)
                .resizable()
                .frame(height: 150)
                .aspectRatio(1/1, contentMode: .fit)
                .background(Color(UIColor.secondarySystemFill))
                .cornerRadius(8)
        }
    }
}

// MARK: 分隔線
struct Separator: View
{
    var body: some View
    {
        Divider()
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
    }
}


struct BrowseView_Previews: PreviewProvider
{
    static var previews: some View
    {
        ContentView()
    }
}
