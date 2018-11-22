//
//  ViewController.swift
//  Ghost Hunt
//
//  Created by Andrew Palmer on 11/16/18.
//  Copyright © 2018 Andrew Palmer. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    
    let toggleButton = MapViewController.generateButtonWithImage(image: UIImage(named:"round_add_circle_black_36pt_2x.png")!, borderColor: UIColor.green.cgColor, cornerRadius: 36)
    let ghostListButton = MapViewController.generateButtonWithImage(image: UIImage(named: "round_view_list_black_36pt_2x.png")!, borderColor: UIColor.green.cgColor, cornerRadius: 36)
    let timerButton = MapViewController.generateButtonWithImage(image: UIImage(named: "round_timer_black_36pt_2x.png")!, borderColor: UIColor.green.cgColor, cornerRadius: 36)
    let cameraButton = MapViewController.generateButtonWithImage(image: UIImage(named: "round_camera_alt_black_36pt_3x.png")!, borderColor: UIColor.green.cgColor, cornerRadius: 43)
    
    let ghostPin1 = MapViewController.generateCustomPointAnnotationWithTitle(title: "Ghost 1 Name")   // ghost 1 pin
    let ghostPin2 = MapViewController.generateCustomPointAnnotationWithTitle(title: "Ghost 2 Name")   // ghost 2 pin
    let ghostPin3 = MapViewController.generateCustomPointAnnotationWithTitle(title: "Ghost 3 Name")   // ghost 3 pin
    let ghostPin4 = MapViewController.generateCustomPointAnnotationWithTitle(title: "Ghost 4 Name")   // ghost 4 pin
    let ghostPin5 = MapViewController.generateCustomPointAnnotationWithTitle(title: "Ghost 5 Name")   // ghost 5 pin
    let ghostPin6 = MapViewController.generateCustomPointAnnotationWithTitle(title: "Ghost 6 Name")   // ghost 6 pin
    let ghostPin7 = MapViewController.generateCustomPointAnnotationWithTitle(title: "Ghost 7 Name")   // ghost 7 pin
    let ghostPin8 = MapViewController.generateCustomPointAnnotationWithTitle(title: "Ghost 8 Name")   // ghost 8 pin
    
    var customPins: [CustomPointAnnotation]!
    
    let coordinate1 = CLLocationCoordinate2D(latitude: 1, longitude: 1) // ghost 1 location
    let coordinate2 = CLLocationCoordinate2D(latitude: 1, longitude: 1) // ghost 2 location
    let coordinate3 = CLLocationCoordinate2D(latitude: 1, longitude: 1) // ghost 3 location
    let coordinate4 = CLLocationCoordinate2D(latitude: 1, longitude: 1) // ghost 4 location
    let coordinate5 = CLLocationCoordinate2D(latitude: 1, longitude: 1) // ghost 5 location
    let coordinate6 = CLLocationCoordinate2D(latitude: 1, longitude: 1) // ghost 6 location
    let coordinate7 = CLLocationCoordinate2D(latitude: 1, longitude: 1) // ghost 7 location
    let coordinate8 = CLLocationCoordinate2D(latitude: 1, longitude: 1) // ghost 8 location
    
    var toggled: Bool = false   // ui button toggle
    var cameraButtonEnabled: Bool = false   // used to determine if ready for an AR situation
    var pinAnnotationView:MKPinAnnotationView!  // used to display custom pins
    var mapView:MKMapView?  // map view
    var locationManager:CLLocationManager?  // used to track user location
    

    override func viewDidLoad() {
        super.viewDidLoad()
        customPins = [ghostPin1, ghostPin2, ghostPin3, ghostPin4, ghostPin5, ghostPin6, ghostPin7, ghostPin8]
        setupNavigationBar()
        requestLocation()
        //setupMap()    // TODO: comment this out for use at State Pen
        setupMapForTesting() // TODO: comment this out when local testing is complete
        addButtons()
    }
    
    // general setup of navigation bar, starts hidden
    func setupNavigationBar() {
        self.navigationController?.navigationBar.barTintColor = UIColor.green
        navigationItem.title = "Map"
        self.navigationController?.navigationBar.isHidden = true
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
            for i in 0...7 {
                if (customPins[i].coordinate.latitude - userCoordinate.latitude < 0.00001 && customPins[i].coordinate.latitude - userCoordinate.latitude > -0.0001) {
                    if (customPins[i].coordinate.longitude - userCoordinate.longitude < 0.00001 && customPins[i].coordinate.longitude - userCoordinate.longitude > -0.0001) {
                        customPins[i].subtitle = "Nearby!"
                        if !augmentedRealityReady {
                            augmentedRealityReady = true
                            enableCameraButton()
                        }
                    } else {
                        customPins[i].subtitle = "(\(customPins[i].coordinate.latitude), \(customPins[i].coordinate.longitude))"
                        if !augmentedRealityReady && cameraButtonEnabled {
                            disableCameraButton()
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
    
    // for testing purposes only. sets map to user location and adds test annotations
    func setupMapForTesting() {
        mapView = MKMapView(frame: view.frame)
        mapView?.delegate = self
        mapView?.mapType = MKMapType.hybrid
        mapView?.showsBuildings = true
        mapView?.isScrollEnabled = false
        mapView?.isRotateEnabled = false
        mapView?.isZoomEnabled = false
        mapView?.showsUserLocation = true
        if let location = locationManager?.location {
            mapView?.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), latitudinalMeters: 200, longitudinalMeters: 200)
            
            let testCoordinate1 = CLLocationCoordinate2D(latitude: location.coordinate.latitude + 0.0003, longitude: location.coordinate.longitude)
            addCustomPinAtCoordinate(coordinate: testCoordinate1, customPin: ghostPin1)
            ghostPin1.subtitle = "(\(testCoordinate1.latitude), \(testCoordinate1.longitude))"
            
            let testCoordinate2 = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude + 0.0003)
            addCustomPinAtCoordinate(coordinate: testCoordinate2, customPin: ghostPin2)
            ghostPin2.subtitle = "(\(testCoordinate2.latitude), \(testCoordinate2.longitude))"
            
            let testCoordinate3 = CLLocationCoordinate2D(latitude: location.coordinate.latitude + 0.0003, longitude: location.coordinate.longitude + 0.0003)
            addCustomPinAtCoordinate(coordinate: testCoordinate3, customPin: ghostPin3)
            ghostPin3.subtitle = "(\(testCoordinate3.latitude), \(testCoordinate3.longitude))"
            
            let testCoordinate4 = CLLocationCoordinate2D(latitude: location.coordinate.latitude - 0.0003, longitude: location.coordinate.longitude + 0.0003)
            addCustomPinAtCoordinate(coordinate: testCoordinate4, customPin: ghostPin4)
            ghostPin4.subtitle = "(\(testCoordinate4.latitude), \(testCoordinate4.longitude))"
            
            let testCoordinate5 = CLLocationCoordinate2D(latitude: location.coordinate.latitude - 0.0003, longitude: location.coordinate.longitude - 0.0003)
            addCustomPinAtCoordinate(coordinate: testCoordinate5, customPin: ghostPin5)
            ghostPin5.subtitle = "(\(testCoordinate5.latitude), \(testCoordinate5.longitude))"
            
            let testCoordinate6 = CLLocationCoordinate2D(latitude: location.coordinate.latitude + 0.0003, longitude: location.coordinate.longitude - 0.0003)
            addCustomPinAtCoordinate(coordinate: testCoordinate6, customPin: ghostPin6)
            ghostPin6.subtitle = "(\(testCoordinate6.latitude), \(testCoordinate6.longitude))"
            
            let testCoordinate7 = CLLocationCoordinate2D(latitude: location.coordinate.latitude - 0.0003, longitude: location.coordinate.longitude)
            addCustomPinAtCoordinate(coordinate: testCoordinate7, customPin: ghostPin7)
            ghostPin7.subtitle = "(\(testCoordinate7.latitude), \(testCoordinate7.longitude))"
            
            let testCoordinate8 = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude - 0.0003)
            addCustomPinAtCoordinate(coordinate: testCoordinate8, customPin: ghostPin8)
            ghostPin8.subtitle = "(\(testCoordinate8.latitude), \(testCoordinate8.longitude))"
            
        }
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
        addConstraintsWithFormat(format: "H:|-36-[v0(72)]", views: timerButton)
        addConstraintsWithFormat(format: "V:[v0(72)]-36-|", views: timerButton)
        timerButton.isEnabled = false
        timerButton.alpha = 0
        
        ghostListButton.addTarget(self, action: #selector(ghostListButtonPressed), for: .touchUpInside)
        view.addSubview(ghostListButton)
        addConstraintsWithFormat(format: "H:|-36-[v0(72)]", views: ghostListButton)
        addConstraintsWithFormat(format: "V:[v0(72)]-36-|", views: ghostListButton)
        ghostListButton.isEnabled = false
        ghostListButton.alpha = 0
        
        toggleButton.addTarget(self, action: #selector(toggleButtonPressed), for: .touchUpInside)
        view.addSubview(toggleButton)
        addConstraintsWithFormat(format: "H:|-36-[v0(72)]", views: toggleButton)
        addConstraintsWithFormat(format: "V:[v0(72)]-36-|", views: toggleButton)
        
        cameraButton.addTarget(self, action: #selector(cameraButtonPressed), for: .touchUpInside)
        cameraButton.isEnabled = false
        cameraButton.alpha = 0
        view.addSubview(cameraButton)
        let divider = view.frame.size.width/2 - 43
        addConstraintsWithFormat(format: "H:|-\(divider)-[v0(86)]-\(divider)-|", views: cameraButton)
        addConstraintsWithFormat(format: "V:[v0(86)]-43-|", views: cameraButton)
    }
    
    // animates buttons up or back down
    @objc func toggleButtonPressed() {
        toggled = !toggled
        if toggled {
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.toggleButton.setImage(UIImage(named: "round_arrow_drop_down_circle_black_36pt_2x.png"), for: .normal)
                
                self.ghostListButton.isEnabled = true
                self.ghostListButton.alpha = 1
                self.ghostListButton.frame = CGRect(x: 36, y: self.view.frame.size.height - 72 * 2.75, width: 72, height: 72)
                
                self.timerButton.isEnabled = true
                self.timerButton.alpha = 1
                self.timerButton.frame = CGRect(x: 36, y: self.view.frame.size.height - 72 * 4, width: 72, height: 72)
            }) { (success) in
            }
        } else {
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.toggleButton.setImage(UIImage(named: "round_add_circle_black_36pt_2x.png"), for: .normal)
                
                self.ghostListButton.isEnabled = false
                self.ghostListButton.alpha = 0
                self.ghostListButton.frame = CGRect(x: 36, y: self.view.frame.size.height - 108, width: 72, height: 72)
                
                self.timerButton.isEnabled = false
                self.timerButton.alpha = 0
                self.timerButton.frame = CGRect(x: 36, y: self.view.frame.size.height - 108, width: 72, height: 72)
            }) { (success) in
            }
        }
    }
    
    // animates camera to be enabled
    func enableCameraButton() {
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.cameraButton.isEnabled = true
            self.cameraButton.alpha = 1
        }) { (success) in
            print("camera enabled")
        }
    }
    
    // animates camera to be disabled
    func disableCameraButton() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.cameraButton.isEnabled = false
            self.cameraButton.alpha = 0
        }) { (success) in
            print("camera disabled")
        }
    }
    
    // pushes ghost list controller onto the navigation controller
    @objc func ghostListButtonPressed() {
        self.toggleButtonPressed()
        let vc = TimerViewController()
        self.navigationController?.navigationBar.barTintColor = UIColor.green
        navigationItem.title = "Map"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // pushes timer view controller onto the navigation controller
    @objc func timerButtonPressed() {
        self.toggleButtonPressed()
        let vc = TimerViewController()
        self.navigationController?.navigationBar.barTintColor = UIColor.green
        navigationItem.title = "Map"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // pushes AR camera onto the navigation controller
    @objc func cameraButtonPressed() {
        
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
    public static func generateButtonWithImage(image: UIImage, borderColor: CGColor, cornerRadius: CGFloat) -> UIButton {
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.imageView?.layer.cornerRadius = cornerRadius
        button.layer.borderWidth = 2
        button.backgroundColor = UIColor.lightGray
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.layer.borderColor = borderColor
        button.layer.borderWidth = 2
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.shadowRadius = 6
        button.layer.shadowOpacity = 0.6
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.layer.cornerRadius =  cornerRadius
        return button
    }
    
    // returns custom point annotation
    public static func generateCustomPointAnnotationWithTitle(title: String) -> CustomPointAnnotation {
        let customPointAnnotation = CustomPointAnnotation()
        customPointAnnotation.pinImage = "round_sentiment_very_dissatisfied_black_36pt_2x.png"
        customPointAnnotation.title = title
        customPointAnnotation.subtitle = "Wandering the area..."
        return customPointAnnotation
    }
    
}

