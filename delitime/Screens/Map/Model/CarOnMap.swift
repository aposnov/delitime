//
//  CarOnMap.swift
//  delitime
//
//  Created by Andrey Posnov on 25/05/2019.
//  Copyright © 2019 Andrey Posnov. All rights reserved.
//

import MapKit

class CarOnMap: NSObject, MKAnnotation {
    var id: Int
    var fuel: String
    var model: Model
    var locationName: String
    var coordinate: CLLocationCoordinate2D
    var imgString: String
    var lat: Double
    var lon: Double
    
    init(id: Int, fuel: String, model: Model, locationName: String, coordinate: CLLocationCoordinate2D, imgString: String, lat: Double, lon: Double) {
        self.model = model
        self.id = id
        self.fuel = fuel
        self.locationName = locationName
        self.coordinate = coordinate
        self.imgString = imgString
        self.lat = lat
        self.lon = lon
        
        super.init()
    }
    
    var title: String? {
        let newTitle = (model.name ?? "")+" "+fuel
        return newTitle
    }
    
    var subtitle: String? {
        return locationName
    }
    
  
}

