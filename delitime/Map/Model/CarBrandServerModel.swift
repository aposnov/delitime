//
//  CarBrandServerModel.swift
//  delitime
//
//  Created by Andrey Posnov on 25/05/2019.
//  Copyright © 2019 Andrey Posnov. All rights reserved.
//

import Foundation

class CarBrandServerModel {
    let name: String
    let year: Int16
    let engineCapacity: Double
    let enginePower: Int16
    let transmission: String
    let equipment: String
    let img: String
    let nameFull: String
    let imgThumb: String
    
   init?(dict: [String: AnyObject]) {
       
        guard let name = dict["model"]!["name"] as? String,
        let year = dict["model"]!["year"] as? Int16,
        let engineCapacity = dict["model"]?["engineCapacity"] as? Double,
        let enginePower = dict["model"]!["enginePower"] as? Int16,
        let transmission = dict["model"]!["transmission"] as? String,
        let equipment = dict["model"]!["equipment"] as? String,
        let img = dict["model"]!["img"] as? String,
        let nameFull = dict["model"]!["nameFull"] as? String,
            let imgThumb = dict["model"]!["nameFull"] as? String else { return nil }
    
        self.name = name
        self.year = year
        self.engineCapacity = engineCapacity
        self.enginePower = enginePower
        self.transmission = transmission
        self.equipment = equipment
        self.img = img
        self.nameFull = nameFull
        self.imgThumb = imgThumb
    }
}


