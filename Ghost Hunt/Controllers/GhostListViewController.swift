//
//  GhostListViewController.swift
//  Ghost Hunt
//
//  Created by Andrew Palmer on 11/21/18.
//  Copyright © 2018 Andrew Palmer. All rights reserved.
//

import UIKit

class GhostListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let ghostNames:[String] = ["Ghost Name 1", "Ghost Name 2", "Ghost Name 3", "Ghost Name 4", "Ghost Name 5", "Ghost Name 6", "Ghost Name 7", "Ghost Name 8", "Ghost Name 1", "Ghost Name 2", "Ghost Name 3", "Ghost Name 4", "Ghost Name 5", "Ghost Name 6", "Ghost Name 7", "Ghost Name 8"]
    private let ghostStatus:[String] = ["Undiscovered", "Undiscovered", "Undiscovered", "Undiscovered", "Undiscovered", "Undiscovered", "Undiscovered", "Undiscovered", "Undiscovered", "Undiscovered", "Undiscovered", "Undiscovered", "Undiscovered", "Undiscovered", "Undiscovered", "Undiscovered"]
    private let ghostYear:[String] = ["1887", "1887", "1887", "1887", "1887", "1887", "1887", "1887", "1887", "1887", "1887", "1887", "1887", "1887", "1887", "1887"]
    
    let ghostTableView: UITableView = {
        let tableView = UITableView()
        tableView.isSpringLoaded = true
        tableView.bounces = true
        tableView.isScrollEnabled = true
        return tableView
    }()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ghostNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! GhostCell
        cell.textLabel?.text = ghostNames[indexPath.row]
        cell.detailTextLabel?.text = ghostYear[indexPath.row]
        cell.statusLabel.text = ghostStatus[indexPath.row]
        cell.profileImageView.image = UIImage(named: "round_sentiment_very_dissatisfied_black_36pt_2x.png") // TODO: find images for prisoners
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        view.backgroundColor = UIColor.gray
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "Ghosts"
        ghostTableView.register(GhostCell.self, forCellReuseIdentifier: "cellId")
        ghostTableView.delegate = self
        ghostTableView.dataSource = self
        ghostTableView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height /*- 76*/)
        view.addSubview(ghostTableView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
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

}

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
        statusLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: self.frame.width*2 + 12).isActive = true
        statusLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        statusLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
