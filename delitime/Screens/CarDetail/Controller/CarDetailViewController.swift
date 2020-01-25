//
//  CarDetailViewController.swift
//  delitime
//
//  Created by Andrey Posnov on 26/05/2019.
//  Copyright © 2019 Andrey Posnov. All rights reserved.
//

import UIKit
import MapKit

class CarDetailViewController: UIViewController {
    
    @IBOutlet private weak var carModel: UILabel!
    @IBOutlet private weak var carImg: UIImageView!
    @IBOutlet private weak var carFuel: UILabel!
    @IBOutlet private weak var carAddress: UILabel!
    @IBOutlet private weak var carId: UILabel!
    
    var carIdPass: Int = 0
    var carFuelPass: String = ""
    var carModelPass: Model?
    var carImgPassString: String = ""
    var carLatPass: Double = 0.0
    var carLonPass: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getAddressFromCoords(pdblLatitude: carLatPass, withLongitude: carLonPass)
        self.setCarInfo()
        self.slideDownClose()
    }
    
    private func setCarInfo() {
        if let imgURL = URL(string: "https://api.delitime.ru"+carImgPassString) {
            self.carImg.load(url: imgURL)
        }
        self.carModel.text = carModelPass?.name
        self.carFuel.text = ("Топливо: \(carFuelPass)")
        self.carId.text = String("ID Авто: \(carIdPass)")
        self.slideDownClose()
    }
    
    private func slideDownClose() {
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
    
}

extension CarDetailViewController: CLLocationManagerDelegate {
    //узнаем адрес по координатам
    func getAddressFromCoords(pdblLatitude: Double, withLongitude pdblLongitude: Double)  {
        var center = CLLocationCoordinate2D()
        let lat = pdblLatitude
        let lon = pdblLongitude
        let ceo = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        let loc = CLLocation(latitude:center.latitude, longitude: center.longitude)
        var addressString = ""
        
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
                    
                    if pm.subThoroughfare != nil {
                        addressString = addressString + pm.subThoroughfare!
                    }
                    self.carAddress.text = addressString
                }
        })
    }
}
