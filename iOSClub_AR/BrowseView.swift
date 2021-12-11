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
