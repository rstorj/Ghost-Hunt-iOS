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

class InmateViewController : UIViewController, ARGhostNodeDelegate {
    
    var delegate: GhostModelDelegate!
    var ghostModel: GhostModel!
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }

    func setupView() {
        ghostModel = delegate.getGhostModel()
        arViewButton.setTitle("View \(ghostModel.ghostName)", for: .normal)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Stonewall-Tile.jpg")!)
        navigationController?.navigationBar.barTintColor = UIColor.IdahoMuseumBlue
        navigationItem.title = "\(ghostModel.ghostName)"
        navigationController?.navigationBar.isHidden = false
        inmateNameLabel.text = "\(ghostModel.ghostName) - \(ghostModel.ghostPoints) Points"
        inmateBioLabel.text = "\(ghostModel.ghostBio)"
        view.addSubview(inmateImageView)
        view.addSubview(inmateNameLabel)
        view.addSubview(inmateBioLabel)
        view.addSubview(arViewButton)
        let spacing = self.view.frame.width/2 - 80
        addConstraintsWithFormat(format: "H:|[v0]|", views: inmateImageView)
        addConstraintsWithFormat(format: "V:|-\(60)-[v0(\(self.view.frame.width/1.92))][v1(100)][v2][v3(60)]-50-|", views: inmateImageView, inmateNameLabel, inmateBioLabel, arViewButton)
        addConstraintsWithFormat(format: "H:|[v0]|", views: inmateNameLabel)
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: inmateBioLabel)
        addConstraintsWithFormat(format: "H:|-\(spacing)-[v0(160)]-\(spacing)-|", views: arViewButton)
    }
    
    func getCurrentGhost() -> GhostModel {
        return ghostModel
    }
    
    let inmateImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "inmates.png")
        return imageView
    }()

    let inmateNameLabel: UILabel = {
        let label = UILabel()
        label.text = "This is the inmate name"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let inmateBioLabel: VerticalAlignLabel = {
        let label = VerticalAlignLabel()
        label.text = "This is the inmate bio"
        label.textAlignment = .left
        label.numberOfLines = 10
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let arViewButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.borderWidth = 2
        button.backgroundColor = UIColor.lightGray
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.layer.borderColor = UIColor.IdahoMuseumBlue.cgColor
        button.layer.borderWidth = 2
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.shadowRadius = 6
        button.layer.shadowOpacity = 0.6
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.layer.cornerRadius =  5
        button.setTitle("View in AR", for: .normal)
        button.addTarget(self, action: #selector(arViewButtonPressed), for: .touchUpInside)
        return button
    }()
    
    @objc func arViewButtonPressed() {
        let vc = ARSceneViewController()
        vc.delegate = self
        self.navigationController?.navigationBar.barTintColor = UIColor.IdahoMuseumBlue
        navigationItem.title = "Inmate Page"    // sets back button text for pushed vc
        navigationController?.pushViewController(vc, animated: true)
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

public class VerticalAlignLabel: UILabel {
    enum VerticalAlignment {
        case top
        case middle
        case bottom
    }
    
    var verticalAlignment : VerticalAlignment = .top {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override public func textRect(forBounds bounds: CGRect, limitedToNumberOfLines: Int) -> CGRect {
        let rect = super.textRect(forBounds: bounds, limitedToNumberOfLines: limitedToNumberOfLines)
        
        if UIView.userInterfaceLayoutDirection(for: .unspecified) == .rightToLeft {
            switch verticalAlignment {
            case .top:
                return CGRect(x: self.bounds.size.width - rect.size.width, y: bounds.origin.y, width: rect.size.width, height: rect.size.height)
            case .middle:
                return CGRect(x: self.bounds.size.width - rect.size.width, y: bounds.origin.y + (bounds.size.height - rect.size.height) / 2, width: rect.size.width, height: rect.size.height)
            case .bottom:
                return CGRect(x: self.bounds.size.width - rect.size.width, y: bounds.origin.y + (bounds.size.height - rect.size.height), width: rect.size.width, height: rect.size.height)
            }
        } else {
            switch verticalAlignment {
            case .top:
                return CGRect(x: bounds.origin.x, y: bounds.origin.y, width: rect.size.width, height: rect.size.height)
            case .middle:
                return CGRect(x: bounds.origin.x, y: bounds.origin.y + (bounds.size.height - rect.size.height) / 2, width: rect.size.width, height: rect.size.height)
            case .bottom:
                return CGRect(x: bounds.origin.x, y: bounds.origin.y + (bounds.size.height - rect.size.height), width: rect.size.width, height: rect.size.height)
            }
        }
    }
    
    override public func drawText(in rect: CGRect) {
        let r = self.textRect(forBounds: rect, limitedToNumberOfLines: self.numberOfLines)
        super.drawText(in: r)
    }
}
