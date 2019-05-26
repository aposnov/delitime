//
//  CarDetailViewController.swift
//  delitime
//
//  Created by Andrey Posnov on 26/05/2019.
//  Copyright © 2019 Andrey Posnov. All rights reserved.
//

import UIKit

class CarDetailViewController: UIViewController, UIApplicationDelegate {

    
    @IBOutlet weak var carModel: UILabel!
    @IBOutlet weak var carImg: UIImageView!
    @IBOutlet weak var carFuel: UILabel!
    @IBOutlet weak var carAddress: UILabel!
    @IBOutlet weak var carId: UILabel!
    
    var carIdPass: Int16 = 0
    var carFuelPass: String = ""
    var carModelPass: String = ""
    var carAddressPass: String = ""
    var carImgPassString: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
       let imgURL = URL(string: "https://api.delitime.ru"+carImgPassString)!
       
        carModel.text = carModelPass
       carFuel.text = ("Топливо: \(carFuelPass)")
       carAddress.text = carAddressPass
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
    
}


