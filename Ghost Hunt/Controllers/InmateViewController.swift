//
//  InmateViewController.swift
//  Ghost Hunt
//
//  Created by Andrew Palmer on 1/10/19.
//  Copyright © 2019 Andrew Palmer. All rights reserved.
//

import UIKit

protocol GhostModelDelegate {
    func getGhostModel() -> GhostModel
}

class InmateViewController : UIViewController {
    
    var delegate: GhostModelDelegate!
    var ghostModel: GhostModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }

    func setupView() {
        ghostModel = delegate.getGhostModel()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Stonewall-Tile.jpg")!)
        navigationController?.navigationBar.barTintColor = UIColor.IdahoMuseumBlue
        navigationItem.title = "\(ghostModel.ghostName)"
        navigationController?.navigationBar.isHidden = false
        inmateLabel.text = "\(ghostModel.ghostBio)"
        view.addSubview(inmateLabel)
        addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: inmateLabel)
        addConstraintsWithFormat(format: "V:|-16-[v0]-16-|", views: inmateLabel)
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        
    }

    let inmateLabel: UILabel = {
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
