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
    
    
    //узнаем адрес по координатам
    func getAddressFromLatLon(pdblLatitude: Double, withLongitude pdblLongitude: Double)  {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    print(pm.country!)
                    print(pm.locality!)
                    print(pm.subLocality!)
                    print(pm.thoroughfare!)
                    print(pm.postalCode!)
                    print(pm.subThoroughfare!)
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                    
                   print(addressString)
                   
                }
        })
  
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
        
        if (anno != nil) {
            
         getAddressFromLatLon(pdblLatitude: anno!.lat, withLongitude: anno!.lon)
        
         carImgPassString = anno?.imgString
         carIdPass = anno?.id
         carFuelPass = anno?.fuel
         carModelPass = anno?.model
        
            
         performSegue(withIdentifier: "carDetail", sender: view)
        }
        
    }
    
   
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "carDetail" {
             let des = segue.destination as! CarDetailViewController
            des.carModelPass = carModelPass!
            des.carImgPassString = carImgPassString!
            des.carFuelPass = carFuelPass!
         //   des.carAddressPass = carAddressPass!
            des.carIdPass = carIdPass!
     
        }
    }
  
  

}








