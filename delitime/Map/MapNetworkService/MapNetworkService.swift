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
    
    static func getCars(completion: @escaping(DelitimeResponse) -> ()){
        guard let url = URL(string: "https://api.delitime.ru/api/v1/cars?with=fuel,model") else { return }
        
        NetworkService.shared.getData(url: url) { (json) in
            
            do {
                let response = try DelitimeResponse(json: json)
                completion(response)
            } catch {
                print(error)
            }
            
        }
    }
}
