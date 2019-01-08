//
//  GhostStrategy.swift
//  Ghost Hunt
//
//  Created by Andrew Palmer on 1/7/19.
//  Copyright © 2019 Andrew Palmer. All rights reserved.
//

import Foundation

@objc protocol GhostStrategy {
    var ghosts: [Ghost] { get set }
    init(path: String)
}
