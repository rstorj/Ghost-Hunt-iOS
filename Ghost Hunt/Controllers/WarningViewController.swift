//
//  WarningViewController.swift
//  Ghost Hunt
//
//  Created by Zachary Broeg on 12/21/18.
//  Copyright © 2018 Andrew Palmer. All rights reserved.
//

import UIKit

class WarningViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
         setupView()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setupView() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Stonewall-Tile.jpg")!)
        navigationController?.navigationBar.barTintColor = UIColor.IdahoMuseumBlue
        navigationItem.title = "Caution!"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(startButton)
        view.addSubview(warningLabel)
        let spacing = view.frame.width / 2 - 80
        let vertSpacing = view.frame.height/2 - 120
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: warningLabel)
        addConstraintsWithFormat(format: "H:|-\(spacing)-[v0(160)]-\(spacing)-|", views: startButton)
        addConstraintsWithFormat(format: "V:|-\(vertSpacing)-[v0(240)]-\(vertSpacing)-|", views: warningLabel)
        addConstraintsWithFormat(format: "V:[v0(60)]-50-|", views: startButton)
    }

    let warningLabel: UILabel = {
        let label = UILabel()
        label.text = "WARNING:\n\nAugmented Reality can be dangerous. Always be aware of your surroundings!"
        label.textAlignment = .center
        label.numberOfLines = 5
        label.backgroundColor = UIColor.red
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.borderWidth = 3
        label.layer.shadowColor = UIColor.darkGray.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 6)
        label.layer.shadowOpacity = 0.6
        label.layer.shadowRadius = 6
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.white
        return label
    }()
    
    let startButton: UIButton = {
        let button = UIButton()
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
        button.setTitle("Begin", for: .normal)
        button.addTarget(self, action: #selector(continueButtonPressed), for: .touchUpInside)
        return button
    }()
    
    @objc func continueButtonPressed() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vc = MapViewController()
        let navigationController = UINavigationController(rootViewController: vc)
        appDelegate.window?.rootViewController = navigationController
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
