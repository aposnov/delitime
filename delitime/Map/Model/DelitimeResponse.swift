//
//  Delitime.swift
//  delitime
//
//  Created by Andrey Posnov on 25/05/2019.
//  Copyright © 2019 Andrey Posnov. All rights reserved.
//

import Foundation

class DelitimeResponse {
    let carsFromSrv: [CarServerModel]
    let carsBrandFromSrv: [CarBrandServerModel]
    
    init(json: Any) throws {
        
        typealias JSON = [String: Any]
        typealias JSONcars = [[String: AnyObject]]
        
        guard let array = json as? JSON else { throw NetworkError.failInternerError }
        guard let arrayOfCars = array["cars"] as? JSONcars else { throw NetworkError.failInternerError }
      
        
        var carsFromSrv = [CarServerModel]()
        for dictioanary in arrayOfCars {
        guard let car = CarServerModel(dict: dictioanary) else { continue }
           carsFromSrv.append(car)
         }
        
      var carsBrandFromSrv = [CarBrandServerModel]()
        for dictioanary in arrayOfCars {
            guard let car = CarBrandServerModel(dict: dictioanary) else { continue }
            carsBrandFromSrv.append(car)
        }
        
       self.carsFromSrv = carsFromSrv
       self.carsBrandFromSrv = carsBrandFromSrv
    }
}
