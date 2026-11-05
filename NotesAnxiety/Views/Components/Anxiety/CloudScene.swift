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
            lightenRain(in: scene.rootNode)
        } else {
            print("Failed Load Scene")
        }
        
        return view
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        // The slider updates this view constantly; only act on a level change.
        guard let scene = uiView.scene, context.coordinator.shownLevel != anxietyLevelType else { return }
        context.coordinator.shownLevel = anxietyLevelType
        updateWeather(in: scene.rootNode)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    final class Coordinator {
        var shownLevel: AnxietyLevelType?
    }

    /// How many numbered rain planes show at this level; the unnumbered base
    /// plane shows whenever there is any rain.
    private var rainCount: Int {
        switch anxietyLevelType {
        case .minimal, .empty: 0
        case .mild: 4
        case .moderate: 18
        case .severe: 23
        }
    }

    private func updateWeather(in node: SCNNode) {
        if let name = node.name {
            if name.contains("lightning") {
                // The model's own animation drives the bolts' opacity, so a
                // fade alone can't keep them off at lower levels.
                node.isHidden = anxietyLevelType != .severe
            } else if name.contains("Plane") {
                let number = Int(name.filter(\.isNumber)) ?? 0
                fade(node, isVisible: rainCount > 0 && number <= rainCount)
            }
        }
        for child in node.childNodes {
            updateWeather(in: child)
        }
    }

    /// The model's rain is dark; the sky behind it needs it pale.
    private func lightenRain(in node: SCNNode, isRain: Bool = false) {
        let isRain = isRain || node.name?.contains("Plane") == true
        if isRain {
            for material in node.geometry?.materials ?? [] {
                material.lightingModel = .constant
                material.diffuse.contents = UIColor(red: 0.90, green: 0.95, blue: 1, alpha: 1)
            }
        }
        for child in node.childNodes {
            lightenRain(in: child, isRain: isRain)
        }
    }

    private func fade(_ node: SCNNode, isVisible: Bool) {
        node.runAction(.fadeOpacity(to: isVisible ? 1.0 : 0.0, duration: 0.5), forKey: "weatherFade")
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
