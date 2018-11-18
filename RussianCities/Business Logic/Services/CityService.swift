//
//  CityService.swift
//  ecity
//
//  Created by Михаил Андреичев on 16.05.2018.
//  Copyright © 2018 md. All rights reserved.
//

import Foundation
import SwiftyJSON

class CityService {
    
    typealias LoadCitiesResult = (сount: Int, cities: [City]?, error: Error?)
    
    static func loadCities(q: String, offset: Int, completionHandler: @escaping (LoadCitiesResult) -> Void) {
        let _ = APIService.shared().getCities(q: q,
                                              offset: offset,
                                              completionHandler:
            {
                json, error in
                
                if error != nil {
                    completionHandler(LoadCitiesResult(сount: 0, cities: nil, error: error))
                    return
                }
                
                var cities = [City]()
                
                let citiesJson = json!["response"]["items"].arrayValue
                let count = json!["response"]["count"].intValue
                
                for cityJson in citiesJson {
                    let city = City()
                    
                    city.id = cityJson["id"].int
                    city.title = cityJson["title"].string
                    city.area = cityJson["area"].string
                    city.region = cityJson["region"].string
                    
                    cities.append(city)
                }
                
                completionHandler(LoadCitiesResult(сount: count, cities: cities, error: nil))
        })
    }
}
