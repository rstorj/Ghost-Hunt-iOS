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
        self.view.backgroundColor = UIColor.orange
        
        
        
        view.addSubview(startButton)
        addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: startButton)
        addConstraintsWithFormat(format: "V:|-16-[v0]-16-|", views: startButton)
    }
    
    let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "This is Van Vlacks Page"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let startButton: UIButton = {
        let button = UIButton()
        button.setTitle("Continue", for: .normal)
        button.addTarget(self, action: #selector(continueButtonPressed), for: .touchUpInside)
        return button
    }()
    // pushes timer view controller onto the navigation controller
    @objc func continueButtonPressed() {
        
        let vc = MapViewController()
        // sets back button text for pushed vc
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
