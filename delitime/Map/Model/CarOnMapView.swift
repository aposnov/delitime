//
//  CarOnMapView.swift
//  delitime
//
//  Created by Andrey Posnov on 25/05/2019.
//  Copyright © 2019 Andrey Posnov. All rights reserved.
//
import MapKit

class CarOnMapView: MKMarkerAnnotationView {

    internal override var annotation: MKAnnotation? { willSet { newValue.flatMap(configure(with:)) } }
}

private extension CarOnMapView {
    func configure(with annotation: MKAnnotation) {
        guard annotation is CarOnMap else { fatalError("Unexpected annotation type: \(annotation)") }
        
    
        markerTintColor = .black
        clusteringIdentifier = "cars"
        displayPriority = .required

        
    }
}

