//
//  CarToCD.swift
//  delitime
//
//  Created by Andrey Posnov on 25/05/2019.
//  Copyright © 2019 Andrey Posnov. All rights reserved.
//

import Foundation

struct CarServerModel: Codable {
    var cars: [Car]?
}
struct Car: Codable {
    var id: Int?
    var lon: Double?
    var lat: Double?
    var model: Model?
    var fuel: String?
}

struct Model: Codable {
    var name: String?
    var year: Int?
    var engine_capacity: Double?
    var engine_power: Int?
    var transmission: String?
    var equipment: String?
    var img: String?
    var name_full: String?
    var img_thumb: String?
}


