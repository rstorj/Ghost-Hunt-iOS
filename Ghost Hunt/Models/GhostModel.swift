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
    var fileName:String = ""
    var ghostName:String = ""
    var ghostYear:String = ""
    var locked:Bool = false
    
    
    init?(fileName: String, ghostName: String, ghostYear: String, locked: Bool) {
        
        // Initialization should fail if there is no name or if the rating is negative.
        if fileName.isEmpty {
            return nil
        }
        
        // Initialize stored properties.
        self.fileName = fileName
        self.ghostName = ghostName
        self.ghostYear = ghostYear
        self.locked = locked
        
    }
   
    
}
