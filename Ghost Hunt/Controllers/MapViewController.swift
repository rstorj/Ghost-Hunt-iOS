//
//  ViewController.swift
//  Ghost Hunt
//
//  Created by Andrew Palmer on 11/16/18.
//  Copyright © 2018 Andrew Palmer. All rights reserved.
//

import UIKit
import MapKit
import ARKit
import CoreData
import MaterialComponents.MaterialButtons


class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, ARGhostNodeDelegate, GhostModelsDelegate {
    
    let defaultFileNames: [String] = ["model1", "model2", "model3", "model4", "model5", "model6", "model7", "model8"]
    let defaultNames: [String] = ["Snowden", "Ghost 2", "Ghost 3", "Ghost 4", "Ghost 5", "Ghost 6", "Ghost 7", "Ghost 8"]
    let defaultBios: [String] = ["default bio", "default bio", "default bio", "default bio", "default bio", "default bio", "default bio", "default bio"]
    let defaultLocations: [String] = ["location1", "location2", "location3", "location4", "location5", "location6", "location7", "location8"]
    
    let toggleButton = MapViewController.generateButtonWithImage(image: UIImage(named:"baseline_menu_white_24dp.png")!.withRenderingMode(.alwaysTemplate), cornerRadius: 28, theColor: UIColor.IdahoMuseumBlue)
    let ghostListButton = MapViewController.generateButtonWithImage(image: UIImage(named: "baseline_list_white_24dp.png")!.withRenderingMode(.alwaysTemplate), cornerRadius: 28, theColor: UIColor.MuseumLightGray)
    let timerButton = MapViewController.generateButtonWithImage(image: UIImage(named: "baseline_alarm_white_24dp.png")!.withRenderingMode(.alwaysTemplate), cornerRadius: 28, theColor: UIColor.MuseumLightGray)
    let cameraButton = MapViewController.generateButtonWithImage(image: UIImage(named: "baseline_photo_camera_white_24dp.png")!.withRenderingMode(.alwaysTemplate), cornerRadius: 28,theColor: UIColor.IdahoMuseumBlue)
    let imageRecognitionButton = MapViewController.generateButtonWithImage(image: UIImage(named: "baseline_wallpaper_white_24dp.png")!.withRenderingMode(.alwaysTemplate), cornerRadius: 28, theColor: UIColor.MuseumLightGray)
    
    var customPins: [CustomPointAnnotation] = []
    
    var ghostIndex: Int = 0    // TODO: get rid of this default value. Should be nil to start
    public var ghostObjects: [GhostModel] = []
    
    private var ghosts: [NSManagedObject] = []
    
    var toggled: Bool = false   // ui button toggle
    var cameraButtonEnabled: Bool = false   // used to determine if ready for an AR situation
    var pinAnnotationView:MKPinAnnotationView!  // used to display custom pins
    var mapView:MKMapView?  // map view
    var locationManager:CLLocationManager?  // used to track user location
    var timer:Timer?
    
    public var blurView:UIVisualEffectView?   // used to blue the app when in background
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCurrentGhosts()
        startUpdateTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        requestLocation()
        setupMap()
        addButtons()
      
       // self.navigationItem.rightBarButtonItem =  UIBarButtonItem(image: UIImage(named: "baseline_alarm_white_24dp.png"), style: .done, target: self, action: #selector(timerButtonPressed))
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(title:"Ghosts", style: .done, target: self, action: #selector(ghostListButtonPressed))

        
        
        enableCameraButton()
        
        
    }
    
    func startUpdateTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            if TimerModel.sharedTimer.getTimeElapsed() >= TimerModel.sharedTimer.getTimeLimit() {
                print("time to end game")
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let vc = GhostListViewController()
                vc.gameOver = true
                vc.delegate = self
                let navigationContrller = UINavigationController(rootViewController: vc)
                navigationContrller.navigationBar.barTintColor = UIColor.IdahoMuseumBlue
                appDelegate.window?.rootViewController = navigationContrller
            }
        }
    }
    
    func getCurrentGhosts() {
        if (ghostObjects.count == 0) {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Ghost")
            do {
                ghosts = try managedContext.fetch(fetchRequest)
                for ghost in ghosts {
                    setupGhost(ghost: ghost)
                }
            } catch let error as NSError {
                print("could not fetch: \(error) - \(error.userInfo)")
            }
            if (ghosts.count == 0) {
                setDefaultGhosts()
            }
        }
    }
    
    func setupGhost(ghost: NSManagedObject) {
        let ghostFileName: String = ghost.value(forKey: "model") as! String
        let ghostName: String = ghost.value(forKey: "name") as! String
        let ghostBio: String = ghost.value(forKey: "bio") as! String
        let ghostLocation: String = ghost.value(forKey: "location") as! String
        let ghostPoints: Int = ghost.value(forKey: "points") as! Int
        
        // using values to create models
        let ghostModel = GhostModel(fileName: ghostFileName, ghostName: ghostName, ghostYear: "1887", ghostBio: ghostBio, ghostLocation: ghostLocation, ghostPoints: ghostPoints, locked: false)
        ghostModel.image = UIImage(named: "round_sentiment_very_dissatisfied_black_36pt_2x.png")
        self.ghostObjects.append(ghostModel)
        
        // add pin to map at ghost location
        let ghostPin = MapViewController.generateCustomPointAnnotationWithTitle(title: ghostModel.ghostName)   // ghost  pin
        self.customPins.append(ghostPin)
        self.addCustomPinAtCoordinate(coordinate: ghostModel.getLocation(locationString: ghostLocation), customPin: ghostPin)
    }
    
    func setDefaultGhosts() {
        for i in 0...7 {
            // using hard coded default values to create models
            let ghostModel = GhostModel(fileName: defaultFileNames[i], ghostName: defaultNames[i], ghostYear: "1887", ghostBio: defaultBios[i], ghostLocation: defaultLocations[i], ghostPoints: 25, locked: true)
            ghostModel.image = UIImage(named: "round_sentiment_very_dissatisfied_black_36pt_2x.png")
            self.ghostObjects.append(ghostModel)
            
            // add pin to map at ghost location
            let ghostPin = MapViewController.generateCustomPointAnnotationWithTitle(title: ghostModel.ghostName)   // ghost  pin
            self.customPins.append(ghostPin)
            self.addCustomPinAtCoordinate(coordinate: ghostModel.getLocation(locationString: defaultLocations[i]), customPin: ghostPin)
        }
        
    }
    
    // returns current ghost model of the delegate (sends info to ARSceneViewController)
    func getCurrentGhost() -> GhostModel {
        return ghostObjects[ghostIndex]
    }
    
    // returns ghost objects of the delegate (sends info to GhostListViewController)
    func getGhostModels() -> [GhostModel] {
        return ghostObjects
    }
    
    // general setup of navigation bar, starts hidden
    func setupNavigationBar() {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor.IdahoMuseumBlue
        navigationItem.title = "Map"
        //self.navigationController?.navigationBar.isHidden = true
    }
    
    // sets up location manager and asks user to allow location
    func requestLocation() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.startUpdatingLocation()
    }
    
    // 37.33283141 -122.0312186
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let userCoordinate = manager.location?.coordinate {
            var augmentedRealityReady = false
            if customPins.count > 0 {
                for i in 0...customPins.count - 1 {
                    if (customPins[i].coordinate.latitude - userCoordinate.latitude < 0.00001 && customPins[i].coordinate.latitude - userCoordinate.latitude > -0.0001) {
                        if (customPins[i].coordinate.longitude - userCoordinate.longitude < 0.00001 && customPins[i].coordinate.longitude - userCoordinate.longitude > -0.0001) {
                            customPins[i].subtitle = "Nearby!"
                            if !augmentedRealityReady {
                                augmentedRealityReady = true
                                ghostIndex = i
                                enableCameraButton()
                            }
                        } else {
                            if !augmentedRealityReady && cameraButtonEnabled {
                                //disableCameraButton() //TODO: uncomment this
                                customPins[i].subtitle = "Wandering the area..."
                                ghostIndex = i  // change this to -1
                            }
                        }
                    }
                }
            }
            cameraButtonEnabled = augmentedRealityReady
        }
    }
    
    // sets up map view to State Pen location
    func setupMap() {
        mapView = MKMapView(frame: view.frame)
        mapView?.delegate = self
        mapView?.mapType = MKMapType.hybrid
        mapView?.showsBuildings = true
        mapView?.isScrollEnabled = false
        mapView?.isRotateEnabled = false
        mapView?.isZoomEnabled = false
        mapView?.showsUserLocation = true
        mapView?.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.602401, longitude: -116.162292), latitudinalMeters: 200, longitudinalMeters: 200)
        view = mapView
    }
    
    // adds custom pin to map at given coordinate
    func addCustomPinAtCoordinate(coordinate: CLLocationCoordinate2D, customPin: CustomPointAnnotation) {
        customPin.coordinate = coordinate
        pinAnnotationView = MKPinAnnotationView(annotation: customPin, reuseIdentifier: "pin")
        mapView?.addAnnotation(customPin)
    }
    
    // generates and places buttons
    func addButtons() {
        timerButton.addTarget(self, action: #selector(timerButtonPressed), for: .touchUpInside)
        view.addSubview(timerButton)
        addConstraintsWithFormat(format: "H:[v0(56)]-16-|", views: timerButton)
        addConstraintsWithFormat(format: "V:[v0(56)]-16-|", views: timerButton)
        timerButton.isEnabled = false
        timerButton.alpha = 0
        
        ghostListButton.addTarget(self, action: #selector(ghostListButtonPressed), for: .touchUpInside)
        view.addSubview(ghostListButton)
        addConstraintsWithFormat(format: "H:[v0(56)]-16-|", views: ghostListButton)
        addConstraintsWithFormat(format: "V:[v0(56)]-16-|", views: ghostListButton)
        ghostListButton.isEnabled = false
        ghostListButton.alpha = 0
        
        cameraButton.addTarget(self, action: #selector(cameraButtonPressed), for: .touchUpInside)
        cameraButton.isEnabled = false
        cameraButton.alpha = 0
        view.addSubview(cameraButton)
        let divider = view.frame.size.width/2 - 43
        addConstraintsWithFormat(format: "H:|-\(divider)-[v0(56)]-\(divider)-|", views: cameraButton)
        addConstraintsWithFormat(format: "V:[v0(56)]-16-|", views: cameraButton)
        
        imageRecognitionButton.addTarget(self, action: #selector(imageRecognitionButtonPressed), for: .touchUpInside)
        view.addSubview(imageRecognitionButton)
        addConstraintsWithFormat(format: "H:[v0(56)]-16-|", views: imageRecognitionButton)
        addConstraintsWithFormat(format: "V:[v0(56)]-16-|", views: imageRecognitionButton)
        imageRecognitionButton.isEnabled = false
        imageRecognitionButton.alpha = 0
        
        toggleButton.addTarget(self, action: #selector(toggleButtonPressed), for: .touchUpInside)
        view.addSubview(toggleButton)
        addConstraintsWithFormat(format: "H:[v0(56)]-16-|", views: toggleButton)
        addConstraintsWithFormat(format: "V:[v0(56)]-16-|", views: toggleButton)
        toggleButton.alpha = 1
    }
    
    // animates buttons up or back down
    @objc func toggleButtonPressed() {
        toggled = !toggled
        if toggled {
            
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.toggleButton.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/4)
                self.toggleButton.setImage(UIImage(named:"baseline_add_white_24dp.png"), for: .normal)
                self.ghostListButton.isEnabled = true
                self.ghostListButton.alpha = 1
                self.ghostListButton.frame = CGRect(x: self.view.frame.size.width - 72, y: self.view.frame.size.height - 144, width: 56, height: 56)
                
                self.timerButton.isEnabled = true
                self.timerButton.alpha = 1
                self.timerButton.frame = CGRect(x: self.view.frame.size.width - 72, y: self.view.frame.size.height - 216, width: 56, height: 56)
                
                self.imageRecognitionButton.isEnabled = true
                self.imageRecognitionButton.alpha = 1
                self.imageRecognitionButton.frame = CGRect(x: self.view.frame.size.width - 72, y: self.view.frame.size.height - 288, width: 56, height: 56)
            }) { (success) in
            }
        } else {
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.toggleButton.transform = CGAffineTransform(rotationAngle: 0)
                self.toggleButton.setImage(UIImage(named:"baseline_menu_white_24dp.png"), for: .normal)

                self.ghostListButton.isEnabled = false
                self.ghostListButton.alpha = 0
                self.ghostListButton.frame = CGRect(x: self.view.frame.size.width - 72, y: self.view.frame.size.height - 72, width: 56, height: 56)
                
                self.timerButton.isEnabled = false
                self.timerButton.alpha = 0
                self.timerButton.frame = CGRect(x: self.view.frame.size.width - 72, y: self.view.frame.size.height - 72, width: 56, height: 56)
                
                self.imageRecognitionButton.isEnabled = false
                self.imageRecognitionButton.alpha = 0
                self.imageRecognitionButton.frame = CGRect(x: self.view.frame.size.width - 72, y: self.view.frame.size.height - 72, width: 56, height: 56)
            }) { (success) in
            }
        }
    }
    
    // animates camera to be enabled
    func enableCameraButton() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.cameraButton.isEnabled = true
            self.cameraButton.alpha = 1
        }) { (success) in
            print("camera enabled")
        }
    }
    
    // animates camera to be disabled
    func disableCameraButton() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.cameraButton.isEnabled = false
            self.cameraButton.alpha = 0
        }) { (success) in
            print("camera disabled")
        }
    }
    
    // pushes ghost list controller onto the navigation controller
    @objc func ghostListButtonPressed() {
        self.toggleButtonPressed()
        let vc = GhostListViewController()
        vc.delegate = self
        self.navigationController?.navigationBar.barTintColor = UIColor.IdahoMuseumBlue
        navigationItem.title = "Map"    // sets back button text for pushed vc
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // pushes timer view controller onto the navigation controller
    @objc func timerButtonPressed() {
        self.toggleButtonPressed()
        let vc = TimerViewController()
        self.navigationController?.navigationBar.barTintColor = UIColor.IdahoMuseumBlue
        navigationItem.title = "Map"    // sets back button text for pushed vc
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // pushes AR camera onto the navigation controller
    @objc func cameraButtonPressed() {
        if (self.toggled) {
            self.toggleButtonPressed()
        }
        let vc = ARSceneViewController()
        vc.delegate = self
        self.navigationController?.navigationBar.barTintColor = UIColor.IdahoMuseumBlue
        navigationItem.title="Map"  // sets back button text for pushed vc
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // pushed image recognition ar view controller onto the navigation controller
    @objc func imageRecognitionButtonPressed() {
        self.toggleButtonPressed()
        let vc = ImageRecognitionViewController()
        self.navigationController?.navigationBar.barTintColor = UIColor.IdahoMuseumBlue
        navigationItem.title = "Map"    // sets back button text for pushed vc
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // constraint generator takes in format and creates constraints
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String : AnyObject]()
        for (index, view) in views.enumerated() {
            view.translatesAutoresizingMaskIntoConstraints = false
            let key = "v\(index)"
            viewsDictionary[key] = view
        }
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    // annotation Setup
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !annotation.isKind(of: MKUserLocation.self) else {
            // returns nil so user location is displayed instead of custom annotation
            return nil
        }
        
        let reuseIdentifier = "pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        let customPointAnnotation = annotation as! CustomPointAnnotation
        annotationView?.image = UIImage(named: customPointAnnotation.pinImage)
        
        return annotationView
    }
    
    // returns a round button to be added to view
    public static func generateButtonWithImage(image: UIImage, cornerRadius: CGFloat, theColor: UIColor) -> UIButton {
        let button = MDCFloatingButton()
        button.setImage(image, for: .normal)
        button.setElevation(ShadowElevation(rawValue: 6), for: .normal)
        button.setElevation(ShadowElevation(rawValue: 12), for: .highlighted)
        button.tintColor = UIColor.white
        button.backgroundColor = theColor
        button.layer.cornerRadius =  cornerRadius
        return button
    }
    
    // returns custom point annotation
    public static func generateCustomPointAnnotationWithTitle(title: String) -> CustomPointAnnotation {
        let customPointAnnotation = CustomPointAnnotation()
        customPointAnnotation.pinImage = "round_sentiment_very_dissatisfied_black_36pt_1x.png"
        customPointAnnotation.title = title
        customPointAnnotation.subtitle = "Wandering the area..."
        return customPointAnnotation
    }
    
}

