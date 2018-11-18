
import UIKit
import SwiftyJSON

protocol APIServiceSharier {
    var sharedAPIService: APIService {get}
}

class APIService: NSObject {
    
    public static let baseURLServer = "https://api.vk.com/method/"
    
    private let environmentMain: NetworkingEnvironment
    private let dispatcherMain: NetworkingDispatcher

    static func shared() -> APIService {
        return (UIApplication.shared.delegate as! APIServiceSharier).sharedAPIService
    }
    
    override init() {
        environmentMain = NetworkingEnvironment("main", host: APIService.baseURLServer)
        dispatcherMain = ConcreateNetworkingDispatcher(environment: environmentMain)
    }
    
    public func getCities(q: String, offset: Int, completionHandler: @escaping(JSON?, Error?) -> Void) -> URLSessionDataTask {
        let operation = GetCitiesOperation(q: q, offset: String(offset))
        
        return operation.execute(in: dispatcherMain, completionHandler: completionHandler)
    }
}
