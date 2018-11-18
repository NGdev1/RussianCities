//
//  GetPassesOperation.swift
//  epass
//
//  Created by Михаил Андреичев on 20.02.2018.
//  Copyright © 2018 md. All rights reserved.
//

import UIKit
import SwiftyJSON

class GetCitiesOperation: NetworkingOperation {
    
    var request: Request
    
    init(q: String,
         offset: String) {
        request = Requests.getCities(q: q, offset: offset)
    }
    
    func execute(in dispatcher: NetworkingDispatcher, completionHandler: @escaping (JSON?, Error?) -> Void) -> URLSessionDataTask {
        
        return dispatcher.execute(request: request,
                                  completionHandler: { (data, response, error) in
            if let err = error {
                completionHandler(nil, err)
                return
            } else {
                if response?.statusCode != 200 || data == nil {
                    completionHandler(nil, APIErrors.unknounError)
                } else {
                    let json = try! JSON(data: data!)
                    completionHandler(json, nil)
                }
            }
        })
    }
    
}
