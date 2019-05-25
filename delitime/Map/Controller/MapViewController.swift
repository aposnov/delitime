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

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    var carsFromSrv = [CarServerModel]()
    var cars: [Car] = []
    var locationTuples: [(textField: UITextField?, mapItem: MKMapItem?)]!
    
    override func viewWillAppear(_ animated: Bool) {
        
        //Загружаем автомобили из КД
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        
        do {
            cars = try context.fetch(fetchRequest)
        } catch {
            print (error.localizedDescription)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Показываем где находится пользователь
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            
            mapView.showsUserLocation = true
        }
        
        //Загружаем автомобили в фоне
        DispatchQueue.global(qos: .background).async {
        MapNetworkService.getCars {(response) in
            self.carsFromSrv = response.carsFromSrv
            for i in 0..<self.carsFromSrv.count {
                self.saveCarsToCD(id: self.carsFromSrv[i].id, lon: self.carsFromSrv[i].lon, lat: self.carsFromSrv[i].lat, model: self.carsFromSrv[i].model, fuel:  self.carsFromSrv[i].fuel)
            }
        }
        }
        
        //Отображаем авто на карте
        DispatchQueue.main.async {
            for i in 0..<self.cars.count {
                let car = self.cars[i]
            let coordinates = CLLocationCoordinate2D(latitude: car.lat, longitude: car.lon)
            let caronmap = CarOnMap(model: car.model!, locationName: "test", coordinate: coordinates)
                self.mapView.addAnnotation(caronmap)
            }
        }

        
    }
    
    //функция сохраняет автомобили в кордату
    func saveCarsToCD(id: Int16, lon: Double, lat: Double, model: String, fuel: String) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Car", in: context)
        let carObject = NSManagedObject(entity: entity!, insertInto: context) as! Car
        carObject.id = id
        carObject.lat = lat
        carObject.lon = lon
        carObject.model = model
        carObject.fuel = fuel
        
        do {
            try context.save()
        } catch {
            print (error.localizedDescription)
        }
        
    }
    
    //узнаем адрес по координатам
    func formatAddressFromPlacemark(placemark: CLPlacemark) -> String {
        return (placemark.addressDictionary!["FormattedAddressLines"] as!
            [String]).joined(separator: ", ")
    }
    
    //узнаем где пользователь
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations[0] as CLLocation
        
        manager.stopUpdatingLocation()
        
        let coordinations = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.2,longitudeDelta: 0.2)
        let region = MKCoordinateRegion(center: coordinations, span: span)
        
        mapView.setRegion(region, animated: true)

    }
   

}


