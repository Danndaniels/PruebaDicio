//
//  APIManager.swift
//  PruebaDicio
//
//  Created by Daniel Acosta on 07/03/23.
//

import Foundation

protocol APIServiceRequest {
   /// The target's base `URL`.
   var baseURL: URL { get }
   /// The path to be appended to `baseURL` to form the full `URL`.
   var path: String { get }
   /// The type of HTTP task to be performed.
   var request: URLRequest { get }
}

public enum DicioAPI {
    case get
    case post(user: UserItem)
    case update(user: UserItem)
}


extension DicioAPI : APIServiceRequest {
  

   var baseURL: URL {
       return URL(string: "https://api.devdicio.net:8444")!
   }
   
   var path: String {
       switch self {
       case  .get:
           return "/v1/sec_dev_interview"
       case .post:
           return "/v1/sec_dev_interview"
       case .update:
           return "/v1/sec_dev_interview"
       }
   }
   
   var request: URLRequest {
       switch self {
       case .get:
           return createURLRequestGet()
       case let .post(user):
           return createURLRequestPOST(user: user)
       case let .update(user):
           return createURLRequestUPDATE(user: user)
       }
   }
   
   
   // Format URL URLRequest Get
    func createURLRequestGet() -> URLRequest {
        let url = self.baseURL.absoluteString + self.path
        
        var request = URLRequest(url: URL(string: url)!,
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
            request.httpMethod = "GET"
            request.setValue("application/json",
                        forHTTPHeaderField: "Content-Type")
            request.setValue("api.devdicio.net",
                        forHTTPHeaderField: "Host")
            request.setValue("J38b4XQNLErVatKIh4oP1jw9e_wYWkS86Y04TMNP", forHTTPHeaderField: "xc-token")

       
       return request
   }
    
    // Format URL URLRequest POST
    func createURLRequestPOST(user: UserItem) -> URLRequest {
         let url = self.baseURL.absoluteString + self.path
        
        guard let jsonData = try? JSONEncoder().encode(user) else {
                    print("Error: Trying to convert model to JSON data")
            return URLRequest(url: URL(string: url)!)
        }
        
         var request = URLRequest(url: URL(string: url)!,
                                  cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                  timeoutInterval: 10.0)
             request.httpMethod = "POST"
             request.setValue("application/json",
                         forHTTPHeaderField: "Content-Type")
             request.setValue("api.devdicio.net",
                         forHTTPHeaderField: "Host")
             request.setValue("J38b4XQNLErVatKIh4oP1jw9e_wYWkS86Y04TMNP", forHTTPHeaderField: "xc-token")
             request.httpBody = jsonData
        
        return request
    }
    
    // Format URL URLRequest Update
    func createURLRequestUPDATE(user: UserItem) -> URLRequest {
         let url = self.baseURL.absoluteString + self.path
        
        guard let jsonData = try? JSONEncoder().encode(user) else {
                    print("Error: Trying to convert model to JSON data")
            return URLRequest(url: URL(string: url)!)
        }
        
         var request = URLRequest(url: URL(string: url)!,
                                  cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                  timeoutInterval: 10.0)
             request.httpMethod = "PUT"
             request.setValue("application/json",
                         forHTTPHeaderField: "Content-Type")
             request.setValue("api.devdicio.net",
                         forHTTPHeaderField: "Host")
             request.setValue("J38b4XQNLErVatKIh4oP1jw9e_wYWkS86Y04TMNP", forHTTPHeaderField: "xc-token")
             request.httpBody = jsonData
        
        return request
    }
   
   
}
class APIManager {

  
   static let shared = APIManager()
  
   

   func request(_ target:DicioAPI, succes successCallback:@escaping (Data)->Void,
                failure failureCallback: ((Any?,Error?) -> Void)?) {
           
       let session = URLSession.shared
       let dataTask = session.dataTask(with: target.request
                                       , completionHandler: { (data, response, error) -> Void in
           if (error != nil) {
               
               if let  failure = failureCallback {
                   failure(nil,error)
               }
           } else {
               if let data = data {
                   successCallback(data)
               }else{
                   if let  failure = failureCallback {
                       failure(nil,error)
                   }
               }
           }
       })
       
       dataTask.resume()

   }

}
