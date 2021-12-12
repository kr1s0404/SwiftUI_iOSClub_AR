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
    
    // 選擇模型的環境變數
    @EnvironmentObject var placementSettings: PlacementSettings

    
    var body: some View
    {
        ZStack(alignment: .bottom) 
        {
            ARViewContainer()
            
            if placementSettings.selectedModel == nil
            {
                ControlView(isControlVisible: $isControlVisible, showBrowse: $showBrowse)
            }
            else
            {
                PlacementView()
            }
        }
        .ignoresSafeArea()
    }
}


struct ARViewContainer: UIViewRepresentable
{
    @EnvironmentObject var placementSettings: PlacementSettings

    
    
    func makeUIView(context: Context) -> CustomARView
    {
        
        let arView = CustomARView(frame: .zero)
        
        // 訂閱(Subscribe)ScenceEvnets.Update
        placementSettings.senceObserver = arView.scene.subscribe(to: SceneEvents.Update.self, { (event) in
            updateScnec(for: arView)
        })
        
        return arView
        
    }
    
    func updateUIView(_ uiView: CustomARView, context: Context) {}
    
    
    private func updateScnec(for arView: CustomARView)
    {
        // 只有在用戶選擇focusEntity時才顯示放置實體模型
        arView.focusEntity?.isEnabled = placementSettings.selectedModel != nil
        
        // 如果確認按鈕被點擊，新增模型到現實場景
        if let confirmedModel = placementSettings.confirmedModel, let modelEntity = confirmedModel.modelEntity {
            
            // 放置模型
            place(modelEntity, in: arView)
            
            // 選擇完畢之後清空
            placementSettings.confirmedModel = nil
            
        }
    }
    
    private func place(_ modelEntity: ModelEntity, in arView: ARView)
    {
        // 1.
        // 複製一個實體模型(modelEntity)，在這邊祂創造了一個完全相同的複製模型且帶有references
        // 此外它還可以讓我們在同一個場景裡有多同樣重複的模型出現
        let clonedEntrty = modelEntity.clone(recursive: true)
        
        // 2.
        // 模型變形旋轉功能
        clonedEntrty.generateCollisionShapes(recursive: true)
        arView.installGestures([.translation, .rotation] ,for: clonedEntrty)
        
        //3.
        // 創造一個anchorEntity並且增加cloneEntity到anchorEntuty
        let anchorEntity = AnchorEntity(plane: .any)
        anchorEntity.addChild(clonedEntrty)
        
        //4.
        // 最後，新增anchorEntity到arView.Scene
        arView.scene.addAnchor(anchorEntity)
    }
    
}

#if DEBUG
struct ContentView_Previews : PreviewProvider
{
    static var previews: some View
    {
        ContentView()
            .environmentObject(PlacementSettings())
    }
}
#endif
