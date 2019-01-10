//
//  UpdateGhostsController.swift
//  Ghost Hunt
//
//  Created by Andrew Palmer on 1/8/19.
//  Copyright © 2019 Andrew Palmer. All rights reserved.
//

import UIKit
import CoreData

class UpdateGhostsViewController: UIViewController {
    
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
    
    func setupView() {
        self.view.backgroundColor = UIColor.gray
        navigationController?.navigationBar.barTintColor = UIColor.IdahoMuseumBlue
        navigationItem.title = "Update Ghosts"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(updateButton)
        view.addSubview(updateLabel)
        let spacing = view.frame.width / 2 - 80
        let vertSpacing = view.frame.height/2 - 120
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: updateLabel)
        addConstraintsWithFormat(format: "H:|-\(spacing)-[v0(160)]-\(spacing)-|", views: updateButton)
        addConstraintsWithFormat(format: "V:|-\(vertSpacing)-[v0(240)]-\(vertSpacing)-|", views: updateLabel)
        addConstraintsWithFormat(format: "V:[v0(60)]-50-|", views: updateButton)
    }
    
    let updateLabel: UILabel = {
        let label = UILabel()
        label.text = "NOTE:\n\nWiFi is required to complete this update. The current list of ghosts will be updated based on the website."
        label.textAlignment = .center
        label.numberOfLines = 6
        label.backgroundColor = UIColor.lightGray
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.borderWidth = 3
        label.layer.shadowColor = UIColor.darkGray.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 6)
        label.layer.shadowOpacity = 0.6
        label.layer.shadowRadius = 6
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.white
        return label
    }()
    
    let updateButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.borderWidth = 2
        button.backgroundColor = UIColor.lightGray
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.layer.borderColor = UIColor.IdahoMuseumBlue.cgColor
        button.layer.borderWidth = 2
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.shadowRadius = 6
        button.layer.shadowOpacity = 0.6
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.layer.cornerRadius =  5
        button.setTitle("Download Ghosts", for: .normal)
        button.addTarget(self, action: #selector(downloadGhosts), for: .touchUpInside)
        return button
    }()
    
    @objc func downloadGhosts() {
        updateButton.setTitle("", for: .normal)
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: self.view.frame.width/2 - 50, y: self.view.frame.height - 130, width: 100, height: 100))
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.white
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        getJSON(path: "http://ec2-34-220-116-162.us-west-2.compute.amazonaws.com/api/read.php");
    }
    
    func getJSON(path: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        //creating a NSURL
        let url = NSURL(string: path)
        
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
            if data != nil {
                
                let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Ghost")
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
                do {
                    try managedContext.execute(deleteRequest)
                    try managedContext.save()
                }
                catch {
                    print ("There was an error deleting")
                }
                
                if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                    
                    //getting the ghosts tag array from json and converting it to NSArray
                    if let ghostArray = jsonObj!.value(forKey: "ghosts") as? NSArray {
                        //looping through all the elements
                        for ghost in ghostArray{
                            
                            //converting the element to a dictionary
                            if let ghostDict = ghost as? NSDictionary {
                                
                                // setting up default values incase data is invalid
                                var ghostFileName = "snowden.scn"
                                var ghostName = "Snowden"
                                var ghostBio = "bio"
                                var ghostLocation = "location1"
                                var ghostPoints:Int = 0
                                
                                //getting the values from the dictionary
                                if let name = (ghostDict.value(forKey: "name") as? String) {
                                    print(name)
                                    ghostName = name
                                }
                                if let bio = (ghostDict.value(forKey: "bio") as? String) {
                                    print(bio)
                                    ghostBio = bio
                                }
                                if let model = (ghostDict.value(forKey: "model") as? String) {
                                    print(model)
                                    ghostFileName = model
                                }
                                if let location = (ghostDict.value(forKey: "location") as? String) {
                                    print(location)
                                    ghostLocation = location
                                }
                                if let points:String = (ghostDict.value(forKey: "points") as? String) {
                                    print(points)
                                    if let pointsInt:Int = Int(points) {
                                        ghostPoints = pointsInt
                                    }
                                }
                                
                                let entity = NSEntityDescription.entity(forEntityName: "Ghost", in: managedContext)!
                                let ghost = NSManagedObject(entity: entity, insertInto: managedContext)
                                ghost.setValue(ghostName, forKey: "name")
                                ghost.setValue(ghostBio, forKey: "bio")
                                ghost.setValue(ghostFileName, forKey: "model")
                                ghost.setValue(ghostLocation, forKey: "location")
                                ghost.setValue(ghostPoints, forKey: "points")
                                do {
                                    try managedContext.save()
                                } catch let error as NSError {
                                    print("error, could not save: \(error) - \(error.userInfo)")
                                }
                                
                            }
                        }
                    }
                }
            } else {
                print("data is nil")
            }
        }).resume()
        UIApplication.shared.endIgnoringInteractionEvents()
        navigationController?.popViewController(animated: true)
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
