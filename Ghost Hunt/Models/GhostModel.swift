//
//  Ghost.swift
//  Ghost Hunt
//
//  Created by Zachary Broeg on 11/21/18.
//  Copyright © 2018 Andrew Palmer. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class GhostModel : NSObject {
    var fileName:String = ""
    var ghostName:String = ""
    var ghostDirName:String = ""
    var ghostYear:String = ""
    var ghostBio: String = ""
    var ghostLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var ghostPoints: Int = 0
    var locked:Bool = true
    var image:UIImage?
    
    enum Model: String {
        case Model1 = "model1"
        case Model2 = "model2"
        case Model3 = "model3"
        case Model4 = "model4"
        case Model5 = "model5"
        case Model6 = "model6"
        case Model7 = "model7"
        case Model8 = "model8"
        case Model9 = "model9"
        case Model10 = "model10"
        case Model11 = "model11"
        case Model12 = "model12"
        case Model13 = "model13"
        case Model14 = "model14"
        case Model15 = "model15"
        case Model16 = "model16"
    }
    
    enum Location: String {
        case Location1 = "location1"
        case Location2 = "location2"
        case Location3 = "location3"
        case Location4 = "location4"
        case Location5 = "location5"
        case Location6 = "location6"
        case Location7 = "location7"
        case Location8 = "location8"
        case Location9 = "location9"
        case Location10 = "location10"
        case Location11 = "location11"
        case Location12 = "location12"
        case Location13 = "location13"
        case Location14 = "location14"
        case Location15 = "location15"
        case Location16 = "location16"
    }
    
    init(fileName: String, ghostName: String, ghostYear: String, ghostBio:String, ghostLocation:String, ghostPoints:Int, locked: Bool) {
        super.init()
        // Initialize stored properties.
        self.fileName = self.getModel(modelString: fileName)
        self.ghostName = ghostName
        self.ghostDirName = self.getDirName(modelString: fileName)
        self.ghostYear = ghostYear
        self.ghostBio = ghostBio
        self.ghostLocation = self.getLocation(locationString: ghostLocation)
        self.ghostPoints = ghostPoints
        self.locked = locked
    }
    
    func getDirName(modelString: String) -> String {
        if let name = Model.init(rawValue: modelString) {
            switch name {
            case .Model1:
                return "Ghost1"
            case .Model2:
                return "Ghost2"
            case .Model3:
                return "Ghost3"
            case .Model4:
                return "Ghost4"
            case .Model5:
                return "Ghost5"
            case .Model6:
                return "Ghost6"
            case .Model7:
                return "Ghost7"
            case .Model8:
                return "Ghost8"
            case .Model9:
                return "Ghost9"
            case .Model10:
                return "Ghost10"
            case .Model11:
                return "Ghost11"
            case .Model12:
                return "Ghost12"
            case .Model13:
                return "Ghost13"
            case .Model14:
                return "Ghost14"
            case .Model15:
                return "Ghost15"
            case .Model16:
                return "Ghost16"
            }
        }
        return "Ghost1"
    }
    
    func getModel(modelString: String) -> String {
        if let model = Model.init(rawValue: modelString) {
            switch model {
                
            case .Model1:
                return "ghost1.scn"
            case .Model2:
                return "ghost2.scn"
            case .Model3:
                return "ghost3.scn"
            case .Model4:
                return "ghost4.scn"
            case .Model5:
                return "ghost5.scn"
            case .Model6:
                return "ghost6.scn"
            case .Model7:
                return "ghost7.scn"
            case .Model8:
                return "ghost8.scn"
            case .Model9:
                return "ghost9.scn"
            case .Model10:
                return "ghost10.scn"
            case .Model11:
                return "ghost11.scn"
            case .Model12:
                return "ghost12.scn"
            case .Model13:
                return "ghost13.scn"
            case .Model14:
                return "ghost14.scn"
            case .Model15:
                return "ghost15.scn"
            case .Model16:
                return "ghost16.scn"
            }
        }
        return "ghost1.scn"
    }
    
    func getLocation(locationString: String) -> CLLocationCoordinate2D {
        if let location = Location.init(rawValue: locationString) {
            switch location {
                case .Location1:  // top left
                    return CLLocationCoordinate2D(latitude: 43.602686, longitude: -116.163052)
                case .Location2:  // top mid
                    return CLLocationCoordinate2D(latitude: 43.602686, longitude: -116.161985)
                case .Location3:  // top right
                    return CLLocationCoordinate2D(latitude: 43.602686, longitude: -116.161370)
                case .Location4:  // medtop left
                    return CLLocationCoordinate2D(latitude: 43.602564, longitude: -116.163052)
                case .Location5: // medtop mid
                    return CLLocationCoordinate2D(latitude: 43.602564, longitude: -116.161985)
                case .Location6: //medtop right
                    return CLLocationCoordinate2D(latitude: 43.602564, longitude: -116.161370)
                case .Location7: // center left
                    return CLLocationCoordinate2D(latitude: 43.602397, longitude: -116.163052)
                case .Location8:    // center mid
                    return CLLocationCoordinate2D(latitude: 43.602397, longitude: -116.161985)
                case .Location9:    // center right
                    return CLLocationCoordinate2D(latitude: 43.602397, longitude: -116.161370)
                case .Location10:  //medbottom left
                    return CLLocationCoordinate2D(latitude: 43.602226, longitude: -116.163052)
                case .Location11:  //medbottom mid
                    return CLLocationCoordinate2D(latitude: 43.602226, longitude: -116.161985)
                case .Location12:  //medbottom right
                    return CLLocationCoordinate2D(latitude: 43.602226, longitude: -116.161370)
                case .Location13:  //bottom random?
                    return CLLocationCoordinate2D(latitude: 43.602111, longitude: -116.162449)
                case .Location14:  //bottom left
                    return CLLocationCoordinate2D(latitude: 43.601830, longitude: -116.163052)
                case .Location15:  // bottom mid
                    return CLLocationCoordinate2D(latitude: 43.601830, longitude: -116.161985)
                case .Location16:  // bottom right
                    return CLLocationCoordinate2D(latitude: 43.601830, longitude: -116.161370)
            }
        }
        return CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }
    
}
