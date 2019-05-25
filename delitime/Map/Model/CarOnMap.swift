//
//  CarOnMap.swift
//  delitime
//
//  Created by Andrey Posnov on 25/05/2019.
//  Copyright © 2019 Andrey Posnov. All rights reserved.
//

import MapKit

class CarOnMap: NSObject, MKAnnotation {
    var id: Int16
    var fuel: String
    var model: String
    var locationName: String
    var coordinate: CLLocationCoordinate2D
    
    init(id: Int16, fuel: String, model: String, locationName: String, coordinate: CLLocationCoordinate2D) {
        self.model = model
        self.id = id
        self.fuel = fuel
        self.locationName = locationName
        self.coordinate = coordinate
        
        super.init()
    }
    
    var title: String? {
        let newTitle = model+", "+fuel
        return newTitle
    }
    
    var subtitle: String? {
        return locationName
    }
}

