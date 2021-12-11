//
//  ContentView.swift
//  iOSClub_AR
//
//  Created by Kris on 12/11/21.
//

import SwiftUI
import RealityKit

struct ContentView : View
{
    // 顯示工具列的Toggle按鈕變數
    @State var isControlVisible: Bool = true
    
    // 顯示3D模型畫面的按鈕變數
    @State var showBrowse: Bool = false
    
    var body: some View
    {
        ZStack(alignment: .bottom)
        {
            ARViewContainer()
            ControlView(isControlVisible: $isControlVisible, showBrowse: $showBrowse)
        }
        .ignoresSafeArea()
    }
}


struct ARViewContainer: UIViewRepresentable
{
    
    func makeUIView(context: Context) -> ARView
    {
        
        let arView = ARView(frame: .zero)
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

#if DEBUG
struct ContentView_Previews : PreviewProvider
{
    static var previews: some View
    {
        ContentView()
    }
}
#endif
