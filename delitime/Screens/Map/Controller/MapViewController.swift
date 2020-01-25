//
//  ViewController.swift
//  delitime
//
//  Created by Andrey Posnov on 22/05/2019.
//  Copyright © 2019 Andrey Posnov. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    private var locationManager = CLLocationManager()
    private var carsFromSrv = [Car]()
    
    private var locationTuples: [(textField: UITextField?, mapItem: MKMapItem?)]!
    
    var carModelPass: Model?
    var carAddressPass: String?
    var carIdPass: Int?
    var carFuelPass: String?
    var carImgPassString: String?
    var carLatPass: Double?
    var carLonPass: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupMap()
        self.getUserPosition()
        self.getCars()
    }
    
    private func getCars() {
        /* Загружаем автомобили */
        MapNetworkService.getCars { [weak self] (response) in
            guard let self = self else { return }
            guard let carsSrv = response else { return }
            self.carsFromSrv =  carsSrv.cars ?? []
            for i in 0..<self.carsFromSrv.count {
                let car = self.carsFromSrv[i]
                let coordinates = CLLocationCoordinate2D(latitude: car.lat ?? 0.0, longitude: car.lon ?? 0.0)
                if let model = car.model {
                    let caronmap = CarOnMap(id: car.id ?? 0, fuel: car.fuel ?? "", model: model, locationName: "", coordinate: coordinates, imgString: car.model?.img ?? "", lat: car.lat ?? 0.0, lon: car.lon ?? 0.0)
                    self.mapView.addAnnotation(caronmap)
                }
            }
        } // конец network service
    }
    
    private func getUserPosition() {
        //Показываем где находится пользователь
        if (CLLocationManager.locationServicesEnabled())
        {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
        }
    }
    
    private func setupMap() {
        self.mapView.delegate = self
        /* кластеризация */
        self.mapView.register(CarOnMapView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        self.mapView.register(CarOnMapClusterView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }
    
    //Определить текущую позицию пользователя
    @IBAction func curLocation(_ sender: Any) {
        locationManager.startUpdatingLocation()
        self.mapView.setCenter(self.mapView.userLocation.coordinate, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "carDetail" {
            let des = segue.destination as! CarDetailViewController
            des.carModelPass = carModelPass
            des.carImgPassString = carImgPassString ?? ""
            des.carFuelPass = carFuelPass ?? ""
            des.carIdPass = carIdPass ?? 0
            des.carLatPass = carLatPass ?? 0.0
            des.carLonPass = carLonPass ?? 0.0
        }
    }
    
}

extension MapViewController:  MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let anno = view.annotation as? CarOnMap
        //проверяем что это не кластер
        if (anno != nil) {
            carImgPassString = anno?.imgString
            carIdPass = anno?.id
            carFuelPass = anno?.fuel
            carModelPass = anno?.model
            carLatPass = anno?.lat
            carLonPass = anno?.lon
            performSegue(withIdentifier: "carDetail", sender: view)
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    //узнаем где пользователь при запуске
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        manager.stopUpdatingLocation()
        let coordinations = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01,longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: coordinations, span: span)
        self.mapView.showsUserLocation = true
        self.mapView.setRegion(region, animated: true)
        manager.stopUpdatingLocation()
    }
}



