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

class ARSceneViewController: UIViewController, ARSCNViewDelegate {

    var sceneView: ARSCNView!   // ar scene view
    var ghostNode: SCNNode?    // ghost node in scene
    var button: SCNNode?    // ar button
    var uiMarker: SCNNode?   // ar ui marker
    var name: SCNNode?      // ar ui name
    public var ghostIndex: Int!  // index of ghost in array
    public var mapVC: MapViewController!    // view controller to update ghost variables
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // sets up ar scene view
    func setupView() {
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "Capture Ghost"
        
        sceneView = ARSCNView(frame: view.frame)
        view = sceneView
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
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
        navigationController?.navigationBar.isHidden = true
        sceneView.session.pause()
    }
    
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        
        if (ghostNode == nil) {
            guard let ghostScene = SCNScene(named: "art.scnassets/\(self.mapVC.ghostObjects[self.ghostIndex].fileName)"),
                let ghost = ghostScene.rootNode.childNode(withName: "ghost", recursively: true)
                else { return }
            uiMarker = ghost.childNode(withName: "ui marker", recursively: true)
            button = uiMarker!.childNode(withName: "button", recursively: true)
            let billboardConstraint = SCNBillboardConstraint()
            uiMarker?.constraints = [billboardConstraint]
            name = uiMarker?.childNode(withName: "name", recursively: true)
            if !self.mapVC.ghostObjects[ghostIndex].locked {
                button?.isHidden = true
                name?.isHidden = false
            } else {
                name?.isHidden = true
                button?.isHidden = false
            }
            ghost.position = SCNVector3(x,y,z)
            self.ghostNode = ghost
            node.addChildNode(ghost)
        }
    }
    
    @objc func handleTap(tap: UITapGestureRecognizer){
        if tap.state == .ended {
            let location: CGPoint = tap.location(in: sceneView)
            let hits = self.sceneView.hitTest(location, options: nil)
            if !hits.isEmpty{
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
                            uiMarker?.isHidden.toggle()
                        }
                    }
                }
                
            }
        }
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
                self.mapVC.ghostObjects[self.ghostIndex].image = image
                self.mapVC.ghostObjects[self.ghostIndex].locked = false
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                self.uiMarker?.isHidden = false
                self.name?.isHidden = false
            })
        }
        AudioServicesPlayAlertSound(1108)
    }
}

extension UIColor {
    open class var transparentLightBlue: UIColor {
        return UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 0.50)
    }
}
