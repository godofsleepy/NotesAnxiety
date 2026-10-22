//
//  CloudScene.swift
//  NotesAnxiety
//
//  Created by Rifat Khadafy on 28/07/24.
//

import Foundation
import SwiftUI
import SceneKit

struct CloudScene : UIViewRepresentable {
    var anxietyLevelType: AnxietyLevelType
    
    func makeUIView(context: Context) -> SCNView {
        let view = SCNView()
        view.allowsCameraControl = false
        view.autoenablesDefaultLighting = true
        view.antialiasingMode = .multisampling4X
        view.backgroundColor = .clear
        
        if let scene = SCNScene(named: "cloud-rain.scn") {
            view.scene = scene
            scene.isPaused = false
            playAnimationKeys(for: scene.rootNode)
        } else {
            print("Failed Load Scene")
        }
        
        return view
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        if let scene = uiView.scene {
            switch anxietyLevelType {
            case .minimal:
                setNodeVisibility(for: scene.rootNode, nodeName: "Plane", isVisible: false)
                setNodeVisibility(for: scene.rootNode, nodeName: "lightning", isVisible: false)
            case .mild:
                setNodeVisibility(for: scene.rootNode, nodeName: "Plane", isVisible: true)
                setRainIntensity(for: scene.rootNode, count: 4)
                setNodeVisibility(for: scene.rootNode, nodeName: "lightning", isVisible: false)
            case .moderate:
                setRainIntensity(for: scene.rootNode, count: 18)
                setNodeVisibility(for: scene.rootNode, nodeName: "Plane", isVisible: true)
                setNodeVisibility(for: scene.rootNode, nodeName: "lightning", isVisible: false)
            case .severe:
                setRainIntensity(for: scene.rootNode, count: 23)
                setNodeVisibility(for: scene.rootNode, nodeName: "Plane", isVisible: true)
                setNodeVisibility(for: scene.rootNode, nodeName: "lightning", isVisible: true)
            case .empty:
                print("def")
            }
            
        }
    }
    
    func setRainIntensity(for node: SCNNode, count: Int) {
        let nodePrefix = "Plane"
        
        for i in 1...23 {
            let nodeName = String(format: "\(nodePrefix)%03d", i)
            let isVisible = i <= count
            setNodeVisibility(for: node, nodeName: nodeName, isVisible: isVisible)
        }
    }
    
    func setNodeVisibility(for node: SCNNode, nodeName: String, isVisible: Bool) {
        if node.name?.contains(nodeName) == true {
            let fadeDuration: TimeInterval = 0.5
            let fadeAction = SCNAction.fadeOpacity(to: isVisible ? 1.0 : 0.0, duration: fadeDuration)
            node.runAction(fadeAction)
        }
        for child in node.childNodes {
            setNodeVisibility(for: child, nodeName: nodeName, isVisible: isVisible)
        }
    }
    
    func playAnimationKeys(for node: SCNNode) {
        let animationKeys = node.animationKeys
        for key in animationKeys {
            //            print("Node: \(node.name ?? "Unnamed"), Animation Key: \(key)")
            if let animationPlayer = node.animationPlayer(forKey: key) {
                animationPlayer.play()
            } else {
                print(" -> No Animation Player found for key \(key)")
            }
        }
        
        for child in node.childNodes {
            playAnimationKeys(for: child)
        }
    }
}
