//
//  Ghost.swift
//  Ghost Hunt
//
//  Created by Zachary Broeg on 11/21/18.
//  Copyright © 2018 Andrew Palmer. All rights reserved.
//

import Foundation

class GhostModel : NSObject
{
    var name: String = ""
    var locked :Bool = false
    
    
    init?(name: String, locked: Bool) {
        
        // Initialization should fail if there is no name or if the rating is negative.
        if name.isEmpty {
            return nil
        }
        
        // Initialize stored properties.
        self.name = name
       self.locked = locked
        
    }
   
    
}
