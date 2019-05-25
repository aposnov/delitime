//
//  CarToCD.swift
//  delitime
//
//  Created by Andrey Posnov on 25/05/2019.
//  Copyright © 2019 Andrey Posnov. All rights reserved.
//

import Foundation

class CarServerModel {
    var id: Int16
    var lon: Double
    var lat: Double
    var model: String
    var fuel: String
    
    init?(dict: [String: AnyObject]) {
        
        let id = dict["id"] as? Int16
        let lon = dict["lon"] as? Double
        let lat = dict["lat"] as? Double
        let model = dict["model"]!["name"] as? String
        let fuel = dict["fuel"] as? String
        
        self.id = id!
        self.lon = lon!
        self.lat = lat!
        self.model = model!
        self.fuel = fuel!
        
    }
    
}
