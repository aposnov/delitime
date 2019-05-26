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

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    var carsFromSrv = [CarServerModel]()
    
    var locationTuples: [(textField: UITextField?, mapItem: MKMapItem?)]!
    
    var carModelPass: String?
    var carAddressPass: String?
    var carIdPass: Int16?
    var carFuelPass: String?
    var carImgPassString: String?
    var carLatPass: Double?
    var carLonPass: Double?
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        /* кластеризация */
        mapView.register(CarOnMapView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(CarOnMapClusterView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
  
        //Показываем где находится пользователь
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        /* Загружаем автомобили */
        DispatchQueue.main.async {
                MapNetworkService.getCars {(response) in
               
                self.carsFromSrv = response.carsFromSrv
                for i in 0..<self.carsFromSrv.count {
                let car = self.carsFromSrv[i]
                    let coordinates = CLLocationCoordinate2D(latitude: car.lat, longitude: car.lon)
                    let caronmap = CarOnMap(id: car.id, fuel: car.fuel, model: car.model, locationName: "", coordinate: coordinates, imgString: car.img, lat: car.lat, lon: car.lon)
                    self.mapView.addAnnotation(caronmap)
                }
          
            } // конец network service
            
        } //конец dispatch

        
    }
    
    //Определить текущую позицию пользователя
    @IBAction func curLocation(_ sender: Any) {
        locationManager.startUpdatingLocation()
        self.mapView.setCenter(self.mapView.userLocation.coordinate, animated: true)
    }
    
    
  
    //узнаем где пользователь при запуске
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations[0] as CLLocation
        
        manager.stopUpdatingLocation()
        
        let coordinations = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01,longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: coordinations, span: span)
        
        
        mapView.showsUserLocation = true
        mapView.setRegion(region, animated: true)
        manager.stopUpdatingLocation()
    }
   
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
    
   
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "carDetail" {
            
            let des = segue.destination as! CarDetailViewController
            des.carModelPass = carModelPass!
            des.carImgPassString = carImgPassString!
            des.carFuelPass = carFuelPass!
            des.carIdPass = carIdPass!
            des.carLatPass = carLatPass!
            des.carLonPass = carLonPass!
     
        }
    }
  
  

}








