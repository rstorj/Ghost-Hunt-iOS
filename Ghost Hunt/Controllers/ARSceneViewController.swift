//
//  ARSceneViewController.swift
//  Ghost Hunt
//
//  Created by Zachary Broeg on 11/21/18.
//  Copyright © 2018 Andrew Palmer. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

protocol ARGhostNodeDelegate {
    func getCurrentGhost() -> GhostModel
}

class ARSceneViewController: UIViewController, ARSCNViewDelegate {

    var sceneView: ARSCNView!   // ar scene view
    var ghostNode: SCNNode?    // ghost node in scene
    var button: SCNNode?    // ar button
    var uiMarker: SCNNode?   // ar ui marker
    var name: SCNNode?      // ar ui name
    var ghostModel: GhostModel!  // current ghost
    var ghostNodeDelegate: ARGhostNodeDelegate!
    var delegate: ARGhostNodeDelegate!
    var animations = [String : CAAnimation]()
    var idle:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // sets up ar scene view
    func setupView() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "Capture Ghost"
        
        ghostModel = delegate.getCurrentGhost()
        sceneView = ARSCNView(frame: view.frame)
        view = sceneView
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
        //sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        //sceneView.showsStatistics = true  // for debugging
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(tap:)))  // tap gesture recognizer
        sceneView.addGestureRecognizer(tapRecognizer)
    }
    
    // configures ar world tracking
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.worldAlignment = .camera
        configuration.planeDetection = .horizontal
        configuration.isLightEstimationEnabled = true
        
        if ARConfiguration.isSupported {
            print("configuration supported")
            sceneView.session.run(configuration)
        } else {
            print("configuration not supported by device")
        }
    }
    
    // Pause the view's session
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //navigationController?.navigationBar.isHidden = true
        sceneView.session.pause()
    }
    
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        if (ghostNode == nil) {
            guard let ghostScene = SCNScene(named: "art.scnassets/\(self.ghostModel.ghostName)/\(self.ghostModel.fileName)"),
                let ghost = ghostScene.rootNode.childNode(withName: "ghost", recursively: true)
                else { return }
            uiMarker = ghost.childNode(withName: "ui marker", recursively: true)
            button = uiMarker!.childNode(withName: "button", recursively: true)
            let billboardConstraint = SCNBillboardConstraint()
            uiMarker?.constraints = [billboardConstraint]
            name = uiMarker?.childNode(withName: "name", recursively: true)
            if !self.ghostModel.locked {
                button?.isHidden = true
                name?.isHidden = false
                if let defeatedNode = ghost.childNode(withName: "defeated", recursively: true) {
                    defeatedNode.isHidden = false
                }
                if let lookingaroundNode = ghost.childNode(withName: "lookingaround", recursively: true) {
                    lookingaroundNode.isHidden = true
                    lookingaroundNode.removeFromParentNode()
                }
            } else {
                name?.isHidden = true
                button?.isHidden = false
            }
            ghost.position = SCNVector3(x,y - 1,z - 1)
            self.ghostNode = ghost
            node.addChildNode(ghost)
            
            // Load all the DAE animations
            // TODO: Add animation selection to website and ghost model so animations can be
            //       swapped out. OR Have same animations for each ghost
            loadAnimation(withKey: "taunt", sceneName: "art.scnassets/\(ghostModel.ghostName)/TauntFixed", animationIdentifier: "TauntFixed-1")
            loadAnimation(withKey: "defeated", sceneName: "art.scnassets/\(ghostModel.ghostName)/DefeatedFixed", animationIdentifier: "DefeatedFixed-1")
            loadAnimation(withKey: "lookingaround", sceneName: "art.scnassets/\(ghostModel.ghostName)/LookingAroundFixed", animationIdentifier: "LookingAroundFixed-1")
            loadAnimation(withKey: "praying", sceneName: "art.scnassets/\(ghostModel.ghostName)/PrayingFixed", animationIdentifier: "PrayingFixed-1")
        }
    }
    
    @objc func handleTap(tap: UITapGestureRecognizer){
        if tap.state == .ended {
            let location: CGPoint = tap.location(in: sceneView)
            let hits = self.sceneView.hitTest(location, options: nil)
            if !hits.isEmpty {
                let tappedNode = hits.first?.node
                if (tappedNode?.name == "button") {
                    uiMarker?.isHidden = true
                    button?.isHidden = true
                    takeScreenshot()
                } else {
                    if let parentNode = tappedNode?.parent {
                        if (parentNode.name == "button") {
                            uiMarker?.isHidden = true
                            button?.isHidden = true
                            takeScreenshot()
                        } else {
                            if (self.ghostModel.locked && idle) {
                                // locked and tapped animation while idle
                                print("locked tapped animation")
                                playAnimation(key: "taunt")
                            } else if (!self.ghostModel.locked && idle) {
                                // unlocked and tapped animation while idle
                                print("unlocked tapped animation")
                                playAnimation(key: "praying")
                            } else {
                                // stop animation
                                print("stop animation -> return to idle")
                            }
                            //uiMarker?.isHidden.toggle()
                        }
                        idle = !idle
                    }
                }
                
            }
        }
    }
    
    func loadAnimation(withKey: String, sceneName:String, animationIdentifier:String) {
        let sceneURL = Bundle.main.url(forResource: sceneName, withExtension: "dae")
        let sceneSource = SCNSceneSource(url: sceneURL!, options: nil)
        
        if let animationObject = sceneSource?.entryWithIdentifier(animationIdentifier, withClass: CAAnimation.self) {
            // The animation will only play once
            animationObject.repeatCount = 5
            // To create smooth transitions between animations
            animationObject.fadeInDuration = CGFloat(1)
            animationObject.fadeOutDuration = CGFloat(0.5)
            
            // Store the animation for later use
            animations[withKey] = animationObject
        }
    }
    
    func playAnimation(key: String) {
        // Add the animation to start playing it right away
        sceneView.scene.rootNode.addAnimation(animations[key]!, forKey: key)
    }
    
    func stopAnimation(key: String) {
        // Stop the animation with a smooth transition
        sceneView.scene.rootNode.removeAnimation(forKey: key, blendOutDuration: CGFloat(0.5))
    }
    
    // Present an error message to the user
    func session(_ session: ARSession, didFailWithError error: Error) {
        print("Session failed. Changing worldAlignment property.")
        print(error.localizedDescription)
    }
    
    // Inform the user that the session has been interrupted, for example, by presenting an overlay
    func sessionWasInterrupted(_ session: ARSession) {
        
    }
    
    // Reset tracking and/or remove existing anchors if consistent tracking is required
    func sessionInterruptionEnded(_ session: ARSession) {
        
    }
    
    func takeScreenshot() {
        DispatchQueue.main.async {
            let flashOverlay = UIView(frame: self.sceneView.frame)
            flashOverlay.backgroundColor = UIColor.white
            self.sceneView.addSubview(flashOverlay)
            UIView.animate(withDuration: 0.5, animations: {
                flashOverlay.alpha = 0.0
            }, completion: { _ in
                flashOverlay.removeFromSuperview()
                let image = self.sceneView.snapshot()
                self.ghostModel.image = image
                self.ghostModel.locked = false
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                self.uiMarker?.isHidden = false
                self.name?.isHidden = false
            })
        }
        AudioServicesPlayAlertSound(1108)
        self.ghostNode!.childNode(withName: "defeated", recursively: true)?.isHidden = false
        self.ghostNode!.childNode(withName: "lookingaround", recursively: true)?.isHidden = true
        self.ghostNode!.childNode(withName: "lookingaround", recursively: true)?.removeFromParentNode()
    }
}

extension UIColor {
    open class var transparentLightBlue: UIColor {
        return UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 0.50)
    }
}
