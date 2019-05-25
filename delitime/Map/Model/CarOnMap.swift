//
//  CarOnMap.swift
//  delitime
//
//  Created by Andrey Posnov on 25/05/2019.
//  Copyright © 2019 Andrey Posnov. All rights reserved.
//

import MapKit

class CarOnMap: NSObject, MKAnnotation {
//    var id: Int16
//    var lon: Double
//    var lat: Double
//    var fuel: String
    var model: String
    var locationName: String
    var coordinate: CLLocationCoordinate2D
    
    init(model: String, locationName: String, coordinate: CLLocationCoordinate2D) {
        self.model = model
        self.locationName = locationName
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}
