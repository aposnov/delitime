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
    
    var carIdPass: Int = 0
    var carFuelPass: String = ""
    var carModelPass: String = ""
    var carAddressPass: String = ""


    override func viewDidLoad() {
        super.viewDidLoad()
        
       carModel.text = carModelPass
        
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
