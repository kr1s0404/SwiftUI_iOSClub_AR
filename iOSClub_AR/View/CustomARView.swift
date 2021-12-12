//
//  CustomARView.swift
//  iOSClub_AR
//
//  Created by Kris on 12/12/21.
//

import RealityKit
import ARKit
import FocusEntity
import SwiftUI
import Combine


// ARview的subView
class CustomARView: ARView
{
    var focusEntity: FocusEntity?
    var sessionSettings: SessionSettings
    
    private var peopleOcclusionCancellable: AnyCancellable?
    private var objectOcclusionCancellable: AnyCancellable?
    private var lidarDebugCancellable: AnyCancellable?
    private var multiuserCancellable: AnyCancellable?
    
    required init(frame frameRect: CGRect, sessionSettings: SessionSettings)
    {
        self.sessionSettings = sessionSettings
        
        super.init(frame: frameRect)
        
        focusEntity = FocusEntity(on: self, focus: .classic)
        configure()
        setupSubscribers()
        initializeSettings()
    }
    
    
    required init(frame frameRect: CGRect)
    {
        fatalError("init(frame:) has not been implemented")
    }
    
    
    // auto created by xCode
    @MainActor @objc required dynamic init?(coder decoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure()
    {
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        
        // 開啟LiDar功能的
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh)
        {
            config.sceneReconstruction = .mesh
        }
        
        session.run(config)
    }
    
    private func initializeSettings()
    {
        updatePeopleOcclusion(isEnable: sessionSettings.isPeopleOcclusionEnabled)
        updateObjectOcclusion(isEnable: sessionSettings.isObjectOcclusionEnabled)
        updateLidarDebug(isEnable: sessionSettings.isLidarDebugEnabled)
        updateMultiuser(isEnable: sessionSettings.isMultiuserEnabled)
    }
    
    // 參考：https://www.swiftbysundell.com/questions/is-weak-self-always-required/
    private func setupSubscribers()
    {
        self.peopleOcclusionCancellable = sessionSettings.$isPeopleOcclusionEnabled.sink { [weak self] isEnable in
            self?.updatePeopleOcclusion(isEnable: isEnable)
        }
        
        self.objectOcclusionCancellable = sessionSettings.$isObjectOcclusionEnabled.sink { [weak self] isEnable in
            self?.updateObjectOcclusion(isEnable: isEnable)
        }
        
        self.lidarDebugCancellable = sessionSettings.$isLidarDebugEnabled.sink { [weak self] isEnable in
            self?.updateLidarDebug(isEnable: isEnable)
        }
        
        self.multiuserCancellable = sessionSettings.$isMultiuserEnabled.sink { [weak self] isEnable in
            self?.updateMultiuser(isEnable: isEnable)
        }
    }
    
    private func updatePeopleOcclusion(isEnable: Bool)
    {
        print("\(#file)：人物遮蔽 \(isEnable)")
        
        guard ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) else { return }
        guard let configuration = self.session.configuration as? ARWorldTrackingConfiguration else { return }
        
        // 確認該裝置是已經啟用personSegmentationWithDepth
        if configuration.frameSemantics.contains(.personSegmentationWithDepth)
        {
            // 使用者點擊之後，如果已經啟用的話，就關掉
            configuration.frameSemantics.remove(.personSegmentationWithDepth)
        }
        else
        {
            // 使用者點擊之後，如果沒啟用，就啟用
            configuration.frameSemantics.insert(.personSegmentationWithDepth)
        }
        
        self.session.run(configuration) // 重新設置session的configuration
    }
    
    private func updateObjectOcclusion(isEnable: Bool)
    {
        print("\(#file)：物體遮蔽 \(isEnable)")
        
        // 道理同上
        if self.environment.sceneUnderstanding.options.contains(.occlusion)
        {
            self.environment.sceneUnderstanding.options.remove(.occlusion)
        }
        else
        {
            self.environment.sceneUnderstanding.options.insert(.occlusion)
        }
        
    }
    
    private func updateLidarDebug(isEnable: Bool)
    {
        print("\(#file)：光達偵測 \(isEnable)")
        
        // 道理同上上
        if self.debugOptions.contains(.showSceneUnderstanding)
        {
            self.debugOptions.remove(.showSceneUnderstanding)
        }
        else
        {
            self.debugOptions.insert(.showSceneUnderstanding)
        }
        
    }
    
    private func updateMultiuser(isEnable: Bool)
    {
        print("\(#file)：多人模式 \(isEnable)")
    }
}


