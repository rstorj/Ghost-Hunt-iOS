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

class ARFightSceneViewController: UIViewController, ARSCNViewDelegate {
    
    var sceneView: ARSCNView!   // ar scene view
    var attackerNode: SCNNode?    // ghost node in scene
    var defenderNode: SCNNode? // defender node in scene
    var attackerHealthNode: SCNNode?
    var defenderHealthNode: SCNNode?
    var button: SCNNode?    // ar button
    var uiMarker: SCNNode?   // ar ui marker
    var name: SCNNode?      // ar ui name
    var ghostModel: GhostModel!  // current ghost
    var ghostNodeDelegate: ARGhostNodeDelegate!
    var delegate: ARGhostNodeDelegate!
    var animations = [String : CAAnimation]()
    var attacking:Bool = false
    var attackable:Bool = true
    var defenderAttacking:Bool = false
    var timer:Timer?
    var attackerHealth: Float = 81
    var defenderHealth: Float = 81
    var isDefended = false
    
    let attackButton: UIButton = {
        let button = UIButton()
        button.adjustsImageWhenDisabled = true
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.borderWidth = 2
        button.backgroundColor = UIColor.lightGray
        button.setTitleColor(UIColor.white, for: UIControl.State.normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.layer.borderColor = UIColor.IdahoMuseumBlue.cgColor
        button.layer.borderWidth = 2
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.shadowRadius = 6
        button.layer.shadowOpacity = 0.6
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.layer.cornerRadius =  5
        button.setTitle("Strike", for: .normal)
        button.addTarget(self, action: #selector(attackButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let defendButton: UIButton = {
        let button = UIButton()
        button.adjustsImageWhenDisabled = true
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.borderWidth = 2
        button.backgroundColor = UIColor.lightGray
        button.setTitleColor(UIColor.white, for: UIControl.State.normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.layer.borderColor = UIColor.IdahoMuseumBlue.cgColor
        button.layer.borderWidth = 2
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.shadowRadius = 6
        button.layer.shadowOpacity = 0.6
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.layer.cornerRadius =  5
        button.setTitle("Defend", for: .normal)
        button.addTarget(self, action: #selector(defendButtonPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // sets up ar scene view
    func setupView() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.isHidden = false
        
        ghostModel = delegate.getCurrentGhost()
        navigationItem.title = "\(ghostModel.ghostName) Fight"
        sceneView = ARSCNView(frame: view.frame)
        view = sceneView
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
        
        view.addSubview(attackButton)
        view.addSubview(defendButton)
        let spacing = view.frame.width / 2 - 160 - 8
        addConstraintsWithFormat(format: "H:|-\(spacing)-[v0(160)]-8-[v1(160)]-\(spacing)-|", views: attackButton, defendButton)
        addConstraintsWithFormat(format: "V:[v0(60)]-50-|", views: attackButton)
        addConstraintsWithFormat(format: "V:[v0(60)]-50-|", views: defendButton)
    }
    
    func startUpdateTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 2.5, repeats: true) { (timer) in
            if (self.attackable && !self.defenderAttacking) {
                self.defenderAttacking = true
                
                self.playDefenderAttackAnimation()
            }
        }
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
        timer?.invalidate()
        //navigationController?.navigationBar.isHidden = true
        sceneView.session.pause()
    }
    
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        if (attackerNode == nil) {
            guard let ghostScene = SCNScene(named: "art.scnassets/fight.scn"),
                let attacker = ghostScene.rootNode.childNode(withName: "attacker", recursively: true),
                let defender = ghostScene.rootNode.childNode(withName: "defender", recursively: true)
                else { return }
            
            attacker.position = SCNVector3(x, y-1, z-2.50)
            defender.position = SCNVector3(x, y-1, z-1.25)
            self.defenderNode = defender
            self.attackerNode = attacker
            node.addChildNode(attacker)
            node.addChildNode(defender)
            attackerHealthNode = attacker.childNode(withName: "green", recursively: true)
            defenderHealthNode = defender.childNode(withName: "green", recursively: true)
            loadAnimation(withKey: "attack", sceneName: "art.scnassets/Ghost1/BoxingFixed", animationIdentifier: "BoxingFixed-1")
            loadAnimation(withKey: "defend", sceneName: "art.scnassets/Ghost9/ReactionFixed", animationIdentifier: "ReactionFixed-1")
            loadAnimation(withKey: "death", sceneName: "art.scnassets/Ghost1/StunnedFixed", animationIdentifier: "StunnedFixed-1")
        }
        startUpdateTimer()
    }
    
    func loadAnimation(withKey: String, sceneName:String, animationIdentifier:String) {
        let sceneURL = Bundle.main.url(forResource: sceneName, withExtension: "dae")
        let sceneSource = SCNSceneSource(url: sceneURL!, options: nil)
        
        if let animationObject = sceneSource?.entryWithIdentifier(animationIdentifier, withClass: CAAnimation.self) {
            // The animation will only play once
            animationObject.repeatCount = 1
            // To create smooth transitions between animations
            animationObject.fadeInDuration = CGFloat(1)
            animationObject.fadeOutDuration = CGFloat(0.5)
            
            // Store the animation for later use
            animations[withKey] = animationObject
        }
    }
    
    @objc func attackButtonPressed() {
        if (attackerNode != nil && !attacking) {
            attacking = true
            attackButton.isEnabled = false
            attackButton.setTitle("wait...", for: .normal)
            attackable = false
            playAttackAnimation()
        }
    }
    
    @objc func defendButtonPressed() {
        if (attackable && defenderAttacking) {
            isDefended = true
            defendButton.setTitle("wait...", for: .normal)
            perform(#selector(undefended), with: nil, afterDelay: 1.0)
        }
    }
    
    @objc func undefended() {
        isDefended = false
        defendButton.setTitle("Defend", for: .normal)
    }
    
    func playAttackAnimation() {
        attackerNode?.addAnimation(animations["attack"]!, forKey: "attack")
        perform(#selector(playDefenderAnimation), with: nil, afterDelay: 0.5)
        perform(#selector(attackerAttackable), with: nil, afterDelay: 2.0)
        perform(#selector(allowStrike), with: nil, afterDelay: 3.0)
    }
    
    func dealDamageToAttacker() {
        var defenseMultiplier: Float = 1.0
        if (isDefended) {
            defenseMultiplier = 0.5
        }
        attackerHealth -= Float.random(in: 1 ..< 15) * defenseMultiplier
        print("defended!")
        let scale = (attackerHealth/81) * 0.81
        if scale < 0 {
            attackerHealthNode?.scale = SCNVector3(0, 0, 0)
            attackerDeath()
        } else {
            attackerHealthNode?.scale = SCNVector3(scale, 0.16, 0.11)
        }
    }
    
    func attackerDeath() {
        timer?.invalidate()
        attackerNode?.addAnimation(animations["death"]!, forKey: "death")
        perform(#selector(destroyAttackerNode), with: nil, afterDelay: 2)
    }
    
    @objc func destroyAttackerNode() {
        attackerNode!.isHidden = true
    }
    
    @objc func destroyDefenderNode() {
        defenderNode!.isHidden = true
        attacking = true
        isDefended = true
    }
    
    func defenderDeath() {
        timer?.invalidate()
        defenderNode?.addAnimation(animations["death"]!, forKey: "death")
        perform(#selector(destroyDefenderNode), with: nil, afterDelay: 2)
    }
    
    func dealDamageToDefender() {
        defenderHealth -= Float.random(in: 1 ..< 15)
        let scale = (defenderHealth/81) * 0.81
        if scale < 0 {
            defenderHealthNode?.scale = SCNVector3(0, 0, 0)
            defenderDeath()
        } else {
            defenderHealthNode?.scale = SCNVector3(scale, 0.16, 0.11)
        }
    }
    
    @objc func attackerAttackable() {
        attackable = true
    }
    
    @objc func playDefenderAttackAnimation() {
        defenderNode?.addAnimation(animations["attack"]!, forKey: "attack")
        perform(#selector(playHitAttackerAnimation), with: nil, afterDelay: 0.5)
        perform(#selector(allowDefenderStrike), with: nil, afterDelay: 1.25)
    }
    
    @objc func playHitAttackerAnimation() {
        attackerNode?.addAnimation(animations["defend"]!, forKey: "defend")
        dealDamageToAttacker()
    }
    
    @objc func playDefenderAnimation() {
        defenderNode?.addAnimation(animations["defend"]!, forKey: "defend")
        dealDamageToDefender()
    }
    
    @objc func allowStrike() {
        attacking = false
        attackButton.isEnabled = true
        attackButton.setTitle("Strike", for: .normal)
    }
    
    @objc func allowDefenderStrike() {
        defenderAttacking = false
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
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String : AnyObject]()
        for (index, view) in views.enumerated() {
            view.translatesAutoresizingMaskIntoConstraints = false
            let key = "v\(index)"
            viewsDictionary[key] = view
        }
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
}
