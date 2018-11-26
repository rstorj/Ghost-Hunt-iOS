//
//  ARSceneViewController.swift
//  Ghost Hunt
//
//  Created by Zachary Broeg on 11/21/18.
//  Copyright © 2018 Andrew Palmer. All rights reserved.
//

import UIKit
import ARKit

class ARSceneViewController: UIViewController, ARSCNViewDelegate {

    var sceneView: ARSCNView!   // ar scene view
    var ghostNode: SCNNode?    // ghost node in scene
    
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
            guard let ghostScene = SCNScene(named: "art.scnassets/snowden.scn"),
                let ghost = ghostScene.rootNode.childNode(withName: "snowden", recursively: true)
                else { return }
            ghost.position = SCNVector3(x,y,z)
            self.ghostNode = ghost
            node.addChildNode(ghost)
            
            // Example of 3d text object
            /*let text:SCNText = SCNText(string: "Snowden", extrusionDepth: CGFloat(1))

            let material:SCNMaterial = SCNMaterial()
            material.diffuse.contents = UIColor.green
            text.materials = [material]
            
            let textNode = SCNNode()
            textNode.position = SCNVector3(x,y+0.5,z)
            textNode.scale = SCNVector3(0.01, 0.01, 0.01)
            textNode.geometry = text
            
            node.addChildNode(textNode)*/
            
            
        }
    }
    
    @objc func handleTap(tap: UITapGestureRecognizer){
        
        if tap.state == .ended {
            let location: CGPoint = tap.location(in: sceneView)
            let hits = self.sceneView.hitTest(location, options: nil)
            if !hits.isEmpty{
                let tappedNode = hits.first?.node
                print("tapped on: \(String(describing: tappedNode?.name))")
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
                UIImageWriteToSavedPhotosAlbum(self.sceneView.snapshot(), nil, nil, nil)
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
