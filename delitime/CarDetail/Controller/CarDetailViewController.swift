//
//  CarDetailViewController.swift
//  delitime
//
//  Created by Andrey Posnov on 26/05/2019.
//  Copyright © 2019 Andrey Posnov. All rights reserved.
//

import UIKit
import MapKit

class CarDetailViewController: UIViewController, UIApplicationDelegate, CLLocationManagerDelegate {

    
    @IBOutlet weak var carModel: UILabel!
    @IBOutlet weak var carImg: UIImageView!
    @IBOutlet weak var carFuel: UILabel!
    @IBOutlet weak var carAddress: UILabel!
    @IBOutlet weak var carId: UILabel!
    
    var carIdPass: Int16 = 0
    var carFuelPass: String = ""
    var carModelPass: String = ""
    var carImgPassString: String = ""
    var carLatPass: Double = 0.0
    var carLonPass: Double = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
       
       getAddressFromLatLon(pdblLatitude: carLatPass, withLongitude: carLonPass)
        
       let imgURL = URL(string: "https://api.delitime.ru"+carImgPassString)!
       
       carModel.text = carModelPass
       carFuel.text = ("Топливо: \(carFuelPass)")
      
       carId.text = String("ID Авто: \(carIdPass)")
       carImg.load(url: imgURL)
        
        let slideDown = UISwipeGestureRecognizer(target: self, action: #selector(dismissView(gesture:)))
        slideDown.direction = .down
        view.addGestureRecognizer(slideDown)
        
    }
    
    @objc func dismissView(gesture: UISwipeGestureRecognizer) {
        self.dismiss(animated: true)
    }
    
    @IBAction func bookCar(_ sender: Any) {
   
        print("lets book it!")
        
    }
    
    //узнаем адрес по координатам
    func getAddressFromLatLon(pdblLatitude: Double, withLongitude pdblLongitude: Double)  {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        
        let lon: Double = Double("\(pdblLongitude)")!
        
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        var addressString : String = ""
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.subThoroughfare!
                    }
                    
                    self.carAddress.text = addressString
                    
                }
        })
        
        
    }
    
}


