//
//  InmateViewController.swift
//  Ghost Hunt
//
//  Created by Andrew Palmer on 1/10/19.
//  Copyright © 2019 Andrew Palmer. All rights reserved.
//

import UIKit

class InmateViewController : UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }

    func setupView() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Stonewall-Tile.jpg")!)
        navigationController?.navigationBar.barTintColor = UIColor.IdahoMuseumBlue
        navigationItem.title = "Inmate"
        navigationController?.navigationBar.isHidden = false
        
        
        view.addSubview(timerLabel)
        addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: timerLabel)
        addConstraintsWithFormat(format: "V:|-16-[v0]-16-|", views: timerLabel)
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        
    }

    let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "This is the inmate page"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

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
