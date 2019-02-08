//
//  TimerViewController.swift
//  Ghost Hunt
//
//  Created by Andrew Palmer on 11/20/18.
//  Copyright © 2018 Andrew Palmer. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {
    
    var timer:Timer?
        
    let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "Time Remaining: 1 hour, 30 minutes, 00 seconds"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Stonewall-Tile.jpg")!)
        setupView()
        // Do any additional setup after loading the view.
    }
    
    func setupView() {
        navigationController?.navigationBar.barTintColor = UIColor.IdahoMuseumBlue
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "Time Remaining"
        
        view.addSubview(timerLabel)
        addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: timerLabel)
        addConstraintsWithFormat(format: "V:|-16-[v0]-16-|", views: timerLabel)
    }
    
    func startUpdateTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { (timer) in
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute, .second]
            formatter.unitsStyle = .full
            
            let formattedString = formatter.string(from: TimeInterval((TimerModel.sharedTimer.getTimeLimit() - TimerModel.sharedTimer.getTimeElapsed())))!
            self.timerLabel.text = formattedString
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        timer?.invalidate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.isHidden = false
        startUpdateTimer()
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
