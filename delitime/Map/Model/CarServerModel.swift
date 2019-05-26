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
    var year: Int16
    var engineCapacity: Double
    var enginePower: Int16
    var transmission: String
    var equipment: String
    var img: String
    var nameFull: String
    var imgThumb: String
    
    init?(dict: [String: AnyObject]) {
        
        let id = dict["id"] as? Int16
        let lon = dict["lon"] as? Double
        let lat = dict["lat"] as? Double
        let model = dict["model"]!["name"] as? String
        let fuel = dict["fuel"] as? String
        let year = dict["model"]!["year"] as? Int16
        let engineCapacity = dict["model"]?["engine_capacity"] as? Double
        let enginePower = dict["model"]!["engine_power"] as? Int16
        let transmission = dict["model"]!["transmission"] as? String
        let equipment = dict["model"]!["equipment"] as? String
        let img = dict["model"]!["img"] as? String
        let nameFull = dict["model"]!["name_full"] as? String
        let imgThumb = dict["model"]!["img_thumb"] as? String
        
        self.id = id!
        self.lon = lon!
        self.lat = lat!
        self.model = model!
        self.fuel = fuel!
        if (year != nil){
        self.year = year!
        } else {
        self.year = 0
        }
        self.engineCapacity = engineCapacity!
        self.enginePower = enginePower!
        self.transmission = transmission!
        self.equipment = equipment!
        self.img = img!
        self.nameFull = nameFull!
        self.imgThumb = imgThumb!
    }
    
}
