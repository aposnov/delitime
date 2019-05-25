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
    var carsBrandFromSrv = [CarBrandServerModel]()
    var cars: [Car] = []
    var carBrands: [CarModel] = []
    
    var locationTuples: [(textField: UITextField?, mapItem: MKMapItem?)]!
    
    var carModelPass: String?
    
    override func viewWillAppear(_ animated: Bool) {
        
       /* Загружаем автомобили из CoreData */
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//
//        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
//
//        do {
//            cars = try context.fetch(fetchRequest)
//        } catch {
//            print (error.localizedDescription)
//        }
//
//        let fetchRequestZ: NSFetchRequest<CarModel> = CarModel.fetchRequest()
//
//        do {
//            carBrands = try context.fetch(fetchRequestZ)
//        } catch {
//            print (error.localizedDescription)
//        }
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
                    let caronmap = CarOnMap(id: car.id, fuel: car.fuel, model: car.model, locationName: "", coordinate: coordinates)
                
                    self.mapView.addAnnotation(caronmap)
                

                
             //   self.saveCarsToCD(id: self.carsFromSrv[i].id, lon: self.carsFromSrv[i].lon, lat: self.carsFromSrv[i].lat, model: self.carsFromSrv[i].model, fuel:  self.carsFromSrv[i].fuel)
            }
            /* загружаем бренды в кд */
//            self.carsBrandFromSrv = response.carsBrandFromSrv
//            for i in 0..<self.carsBrandFromSrv.count {
//                self.saveCarsBrandToCD(name: self.carsBrandFromSrv[i].name, year: self.carsBrandFromSrv[i].year, engineCapacity: self.carsBrandFromSrv[i].engineCapacity, enginePower: self.carsBrandFromSrv[i].enginePower, transmission: self.carsBrandFromSrv[i].transmission, equipment: self.carsBrandFromSrv[i].equipment, img: self.carsBrandFromSrv[i].img, nameFull: self.carsBrandFromSrv[i].nameFull, imgThumb: self.carsBrandFromSrv[i].imgThumb)
//            }
        }
            
        }
        
        /* Отображаем авто на карте из Core Data */
        
//        DispatchQueue.main.async {
//            for i in 0..<self.cars.count {
//                let car = self.cars[i]
//                let coordinates = CLLocationCoordinate2D(latitude: car.lat, longitude: car.lon)
//                let caronmap = CarOnMap(id: car.id, fuel: car.fuel!, model: car.model!, locationName: "", coordinate: coordinates)
//                self.mapView.addAnnotation(caronmap)
//            }
//        }

        
    }
    
    //Определить текущую позицию пользователя
    @IBAction func curLocation(_ sender: Any) {
        locationManager.startUpdatingLocation()
        self.mapView.setCenter(self.mapView.userLocation.coordinate, animated: true)
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
    
   
    func saveCarsBrandToCD(name: String, year: Int16, engineCapacity: Double, enginePower: Int16, transmission: String, equipment: String, img: String, nameFull: String, imgThumb: String) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "CarModel", in: context)
        let carObject = NSManagedObject(entity: entity!, insertInto: context) as! CarModel
        carObject.name = name
        carObject.year = year
        carObject.engineCapacity = engineCapacity
        carObject.enginePower = enginePower
        carObject.transmission = transmission
        carObject.equipment = equipment
        carObject.img = img
        carObject.nameFull = nameFull
        carObject.imgThumb = imgThumb
        
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
       
        carModelPass = (view.annotation?.title)!
         performSegue(withIdentifier: "carDetail", sender: view)
        
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "carDetail" {
            
            let des = segue.destination as! CarDetailViewController
            des.carModelPass = carModelPass!
        }
    }
    
   
  

}








