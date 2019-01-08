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
    var ghostYear:String = ""
    var ghostBio: String = ""
    var ghostLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var ghostPoints: Int = 0
    var locked:Bool = false
    var image:UIImage?
    
    enum Name: String {
        case Name1 = "Snowden"
        case Name2 = "Van Vlack"
        case Name3 = "Name 3"
        case Name4 = "Name 4"
        case Name5 = "Name 5"
        case Name6 = "Name 6"
        case Name7 = "Name 7"
        case Name8 = "Name 8"
        case Name9 = "Name 9"
        case Name10 = "Name 10"
        case Name11 = "Name 11"
        case Name12 = "Name 12"
        case Name13 = "Name 13"
        case Name14 = "Name 14"
        case Name15 = "Name 15"
        case Name16 = "Name 16"
    }
    
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
        self.ghostYear = ghostYear
        self.ghostBio = ghostBio
        self.ghostLocation = self.getLocation(locationString: ghostLocation)
        self.ghostPoints = ghostPoints
        self.locked = locked
    }
    
    func getModel(modelString: String) -> String {
        if let model = Model.init(rawValue: modelString) {
            switch model {
                
            case .Model1:
                return "snowden.scn"
            case .Model2:
                return "vanvlack.scn"
            case .Model3:
                return "snowden.scn"
            case .Model4:
                return "snowden.scn"
            case .Model5:
                return "snowden.scn"
            case .Model6:
                return "snowden.scn"
            case .Model7:
                return "snowden.scn"
            case .Model8:
                return "snowden.scn"
            case .Model9:
                return "snowden.scn"
            case .Model10:
                return "snowden.scn"
            case .Model11:
                return "snowden.scn"
            case .Model12:
                return "snowden.scn"
            case .Model13:
                return "snowden.scn"
            case .Model14:
                return "snowden.scn"
            case .Model15:
                return "snowden.scn"
            case .Model16:
                return "snowden.scn"
            }
        }
        return "snowden.scn"
    }
    
    func getLocation(locationString: String) -> CLLocationCoordinate2D {
        if let location = Location.init(rawValue: locationString) {
            switch location {
                case .Location1:
                    return CLLocationCoordinate2D(latitude: 43.602683, longitude: -116.161966)
                case .Location2:
                    return CLLocationCoordinate2D(latitude: 43.602405, longitude: -116.161986)
                case .Location3:
                    return CLLocationCoordinate2D(latitude: 1, longitude: 1)
                case .Location4:
                    return CLLocationCoordinate2D(latitude: 1, longitude: 1)
                case .Location5:
                    return CLLocationCoordinate2D(latitude: 1, longitude: 1)
                case .Location6:
                    return CLLocationCoordinate2D(latitude: 1, longitude: 1)
                case .Location7:
                    return CLLocationCoordinate2D(latitude: 1, longitude: 1)
                case .Location8:
                    return CLLocationCoordinate2D(latitude: 1, longitude: 1)
                case .Location9:
                    return CLLocationCoordinate2D(latitude: 1, longitude: 1)
                case .Location10:
                    return CLLocationCoordinate2D(latitude: 1, longitude: 1)
                case .Location11:
                    return CLLocationCoordinate2D(latitude: 1, longitude: 1)
                case .Location12:
                    return CLLocationCoordinate2D(latitude: 1, longitude: 1)
                case .Location13:
                    return CLLocationCoordinate2D(latitude: 1, longitude: 1)
                case .Location14:
                    return CLLocationCoordinate2D(latitude: 1, longitude: 1)
                case .Location15:
                    return CLLocationCoordinate2D(latitude: 1, longitude: 1)
                case .Location16:
                    return CLLocationCoordinate2D(latitude: 1, longitude: 1)
            }
        }
        return CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }
    
}
