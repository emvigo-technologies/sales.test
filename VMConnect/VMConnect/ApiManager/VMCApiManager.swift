import Foundation
import Alamofire

class VMCApiManager: NSObject {

    //MARK: GET CONTACTS LIST
    static func getContactsData(completion: @escaping (_ message: String?, _ success : Bool, _ data: VMCContactModel?) -> Void){
        let url = VMCURLs.baseURL + VMCURLs.contacts
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseDecodable(of: VMCContactModel.self) { response in
            switch response.result{
            case .success( _):
                if let model = try? VMCContactModel.init(data: response.data ?? Data()) {
                    if response.response?.statusCode == 200 || response.response?.statusCode == 201{
                        completion("Success",true, model)
                    } else if response.response?.statusCode == 401 || response.response?.statusCode == 403 {
                        completion("Data fetching failed",false, nil)
                    } else{
                        completion("Data fetching failed",false, nil)
                    }
                } else {
                    //Failed To Parse Data
                    completion("Failed to parse data",false, nil)
                }
            case .failure( _):
                completion("Server error occured", false, nil)
            }
        }
    }
    
    //MARK: GET ROOMS LIST
    static func getRoomsData(completion: @escaping (_ message: String?, _ success : Bool, _ data: VMCRoomsModel?) -> Void){
        let url = VMCURLs.baseURL + VMCURLs.rooms
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseDecodable(of: VMCRoomsModel.self) { response in
            switch response.result{
            case .success( _):
                if let model = try? VMCRoomsModel.init(data: response.data ?? Data()) {
                    if response.response?.statusCode == 200 || response.response?.statusCode == 201{
                        completion("Success",true, model)
                    } else if response.response?.statusCode == 401 || response.response?.statusCode == 403 {
                        completion("Data fetching failed",false, nil)
                    } else{
                        completion("Data fetching failed",false, nil)
                    }
                } else {
                    //Failed To Parse Data
                    completion("Failed to parse data",false, nil)
                }
            case .failure( _):
                completion("Server error occured", false, nil)
            }
        }
    }
}

