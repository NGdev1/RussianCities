
import Foundation
import SwiftyJSON

public enum Requests: Request {
    
    case getCities(
        q: String,
        offset: String
    )
    
    public var path: String {
        switch self {
        case .getCities:
            return "database.getCities"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .getCities:
            return .get
        }
    }
    
    public var parameters: RequestParams {
        switch self {
        case .getCities(let q, let offset):
            return .url([
                "q": q,
                "offset": offset,
                "need_all": "1",
                "count": String(CitiesViewController.NewOffsetValue),
                "country_id": "1",
                "access_token":
                "195eace0195eace0195eace0531939bde81195e195eace042aea0200bc1361b7c300fa9",
                "v":"5.87"
                ])
        }
    }
    
    public var headers: [String : Any]? {
        return [:]
    }
    
    public var dataType: DataType {
        return .JSON
    }
}
