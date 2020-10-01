//
//  NetworkingClient.swift
//  Movietastic
//
//  Created by Cielo on 01/10/2020.
//

import Foundation
import Alamofire

class NetworkingClient {
    
    typealias webServiceResponse = ([[String: Any]]?, Error?) -> Void
    
    func execute(with url: URL, andRequestMethod requestMethod: HTTPMethod = .get, completion: @escaping webServiceResponse) {
        
        var urlRequest = URLRequest(url: url)
        urlRequest.method = requestMethod
        
        AF.request(urlRequest).validate().responseJSON { (response) in
            if let error = response.error {
                completion(nil, error)
            }
            else if let jsonArray = response.value as? [[String : Any]] {
                completion(jsonArray, nil)
            }
            else if let jsonDict = response.value as? [String : Any] {
                completion([jsonDict], nil)
            }
        }
    }
    
}
