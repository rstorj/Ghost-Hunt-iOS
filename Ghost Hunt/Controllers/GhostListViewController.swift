//
//  GhostListViewController.swift
//  Ghost Hunt
//
//  Created by Zachary Broeg on 11/21/18.
//  Copyright © 2018 Andrew Palmer. All rights reserved.
//

import UIKit

protocol GhostModelsDelegate {
    func getGhostModels() -> [GhostModel]
}

class GhostListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var delegate:GhostModelsDelegate!
    var ghostModels: [GhostModel]!
    
    let ghostTableView: UITableView = {
        let tableView = UITableView()
        tableView.isSpringLoaded = true
        tableView.backgroundColor = UIColor.gray
        tableView.bounces = true
        tableView.isScrollEnabled = true
        return tableView
    }()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ghostModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! GhostCell
        cell.backgroundColor = UIColor.gray
        cell.textLabel?.text = ghostModels[indexPath.row].ghostName
        cell.detailTextLabel?.text = ghostModels[indexPath.row].ghostYear
        if (ghostModels[indexPath.row].locked) {
            cell.statusLabel.text = "Undiscovered"
            cell.isUserInteractionEnabled = false
        } else {
            cell.statusLabel.text = "Captured!"
            cell.profileImageView.image = ghostModels[indexPath.row].image!
            cell.isUserInteractionEnabled = true
        }
        cell.profileImageView.image = UIImage(named: "round_sentiment_very_dissatisfied_black_36pt_2x.png")
        // TODO: find images for prisoners
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // logic for checking which index was clicked and then calling to a viewcontroller based on that.
        // could be better implemented but it works for now.
        // TODO: create a single page that is popped to and info is updated based on ghostModels[indexPath.row]
        //       might include a delegate design pattern to pass the data to the vc
        if(indexPath.row == 0) {
            callSnowden()
            print("calling Snowden")
        }
        if(indexPath.row == 1) {
            callVanVlack()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
   
    func setupView() {
        ghostModels = delegate.getGhostModels()
        view.backgroundColor = UIColor.gray
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "Ghosts"
        ghostTableView.register(GhostCell.self, forCellReuseIdentifier: "cellId")
        ghostTableView.delegate = self
        ghostTableView.dataSource = self
        ghostTableView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        view.addSubview(ghostTableView)
        self.ghostTableView.tableFooterView = UIView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isHidden = false
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
    
    // MARK:- This is where we are calling out to the inmate ViewControllers
    @objc func callSnowden() {
        
        let vc = SnowdenViewController()
        self.navigationController?.navigationBar.barTintColor = UIColor.blue
        navigationItem.title = "Inmate List"    // sets back button text for pushed vc
        self.navigationController?.pushViewController(vc, animated: true)
        print("we are in snowden")
    }
    
    @objc func callVanVlack() {
        
        let vc = VanVlackViewController()
        self.navigationController?.navigationBar.barTintColor = UIColor.blue
        navigationItem.title = "Inmate List"    // sets back button text for pushed vc
        self.navigationController?.pushViewController(vc, animated: true)
        print("we are in VanVlack")
    }
    
}
// MARK: - GhostCell class creation
class GhostCell : UITableViewCell {
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 30
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.blue.cgColor
        imageView.layer.borderWidth = 2
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.blue
        label.text = ""
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 76, y: textLabel!.frame.origin.y - 4, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 76, y: detailTextLabel!.frame.origin.y + 4, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        addSubview(statusLabel)
        
        //constraint anchors, x y width height
        profileImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        statusLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        statusLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: self.frame.width).isActive = true
        statusLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        statusLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
