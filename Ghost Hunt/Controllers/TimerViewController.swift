//
//  TimerViewController.swift
//  Ghost Hunt
//
//  Created by Andrew Palmer on 11/20/18.
//  Copyright © 2018 Andrew Palmer. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        setupView()
        // Do any additional setup after loading the view.
    }
    
    func setupView() {
        navigationController?.navigationBar.barTintColor = UIColor.green
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "Time Remaining"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }

}
