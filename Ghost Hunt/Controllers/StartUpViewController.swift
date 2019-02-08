//
//  StartUpViewController.swift
//  Ghost Hunt
//
//  Created by Zachary Broeg on 12/21/18.
//  Copyright © 2018 Andrew Palmer. All rights reserved.
//

import UIKit

class StartUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func setupView() {
        //self.view.backgroundColor = UIColor.gray
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Stonewall-Tile.jpg")!)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor.IdahoMuseumBlue
        navigationItem.title = "Ghost Hunt"
        let logo = UIImage(named: "cropped-ISHS-Header-Logos.png")
        let imageView = UIImageView(image:logo)
        view.addSubview(imageView)
        //let ratio = view.frame.width/200
        //print(ratio)
        //let imageSpacing = (self.view.frame.width - imageView.frame.width) / 2
        addConstraintsWithFormat(format: "H:|[v0]|", views: imageView)
        //let vertImageSpacing = (self.view.frame.height - imageView.frame.height) / 2
        addConstraintsWithFormat(format: "V:|-(-2)-[v0(\(view.frame.width/3.84))]", views: imageView)
        //imageView.adjustsImageSizeForAccessibilityContentSizeCategory = true
        //self.navigationItem.titleView = imageView
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        
        view.addSubview(continueButton)
        view.addSubview(updateButton)
        let spacing = view.frame.width/2 - 160 - 8
        addConstraintsWithFormat(format: "H:|-\(spacing)-[v0(160)]-16-[v1(160)]-\(spacing)-|", views: continueButton, updateButton)
        addConstraintsWithFormat(format: "V:[v0(60)]-50-|", views: continueButton)
        addConstraintsWithFormat(format: "V:[v0(60)]-50-|", views: updateButton)
    }
    
    let continueButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.IdahoMuseumBlue
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.shadowRadius = 6
        button.layer.shadowOpacity = 0.6
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.layer.cornerRadius =  5
        button.setTitle("Ghost Hunt", for: .normal)
        button.addTarget(self, action: #selector(continueButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let updateButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.IdahoMuseumBlue
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.shadowRadius = 6
        button.layer.shadowOpacity = 0.6
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.layer.cornerRadius =  5
        button.setTitle("Update Ghosts", for: .normal)
        button.addTarget(self, action: #selector(updateButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    @objc func continueButtonPressed() {
        
        let vc = WarningViewController()
        navigationItem.title = "Ghost Hunt"    // sets back button text for pushed vc
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func updateButtonPressed() {
        let vc = UpdateGhostsViewController()
        navigationItem.title = "Ghost Hunt" //sets back button text for pushed vc
        self.navigationController?.pushViewController(vc, animated: true)
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
