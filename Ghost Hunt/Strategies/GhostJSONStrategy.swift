//
//  GhostJSONStrategy.swift
//  Ghost Hunt
//
//  Created by Andrew Palmer on 1/7/19.
//  Copyright © 2019 Andrew Palmer. All rights reserved.
//

import Foundation

class GhostJSONStrategy : NSObject, GhostStrategy {
    
    var ghosts: [Ghost] = []
    
    required init(path: String) {
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let ghostDictionary = try! JSONDecoder().decode([String:[Ghost]].self, from: data)
        if let gs = ghostDictionary["ghosts"] {
            ghosts = gs
        }
    }
    
}
