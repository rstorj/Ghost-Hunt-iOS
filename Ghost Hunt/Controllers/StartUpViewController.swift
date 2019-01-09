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
    
    func setupView() {
        self.view.backgroundColor = UIColor.gray
        navigationController?.navigationBar.barTintColor = UIColor.green
        navigationItem.title = "Ghost Hunt"
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
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.borderWidth = 2
        button.backgroundColor = UIColor.lightGray
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.layer.borderColor = UIColor.green.cgColor
        button.layer.borderWidth = 2
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.shadowRadius = 6
        button.layer.shadowOpacity = 0.6
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.layer.cornerRadius =  5
        button.setTitle("Continue", for: .normal)
        button.addTarget(self, action: #selector(continueButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let updateButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.borderWidth = 2
        button.backgroundColor = UIColor.lightGray
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.layer.borderColor = UIColor.green.cgColor
        button.layer.borderWidth = 2
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.shadowRadius = 6
        button.layer.shadowOpacity = 0.6
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.layer.cornerRadius =  5
        button.titleLabel?.numberOfLines = 2
        button.setTitle("Update Ghosts (WiFi Required)", for: .normal)
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
        navigationItem.title = "Ghost Hunt"
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
