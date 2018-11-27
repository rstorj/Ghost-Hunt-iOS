//
//  ImageRecognitionViewController.swift
//  Ghost Hunt
//
//  Created by Andrew Palmer on 11/26/18.
//  Copyright © 2018 Andrew Palmer. All rights reserved.
//

import UIKit
import ARKit

class ImageRecognitionViewController: UIViewController, ARSCNViewDelegate {
    
    var sceneView:ARSCNView!

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
    }
    
    // configures ar world tracking
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.worldAlignment = .camera
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

}
