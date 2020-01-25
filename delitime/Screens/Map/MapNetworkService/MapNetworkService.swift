//
//  MapNetworkService.swift
//  delitime
//
//  Created by Andrey Posnov on 25/05/2019.
//  Copyright © 2019 Andrey Posnov. All rights reserved.
//

import Foundation

class MapNetworkService{
    private init() {}
    
    static func getCars(completion: @escaping(CarServerModel?) -> ()){
        if let path = Bundle.main.path(forResource: "delitime_json", ofType: "json") {
            let url = URL(fileURLWithPath: path)
            NetworkService.shared.getData(url: url) { (json) in
                do {
                    let response = try CarServerModel.decode(from: json as! Data)
                    completion(response)
                } catch {
                    print(error)
                }
            }
        }
    }
}
