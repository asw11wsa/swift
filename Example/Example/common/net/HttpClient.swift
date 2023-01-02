//
//  HttpClient.swift
//  Example
//
//  Created by e4 on 2022/12/20.
//

import Foundation
import Alamofire

class HttpClient<T:Decodable>:ObservableObject {
    typealias onSuccess = (T) -> ()
    typealias onFailure = () -> ()
    
    let headers: HTTPHeaders = [
        .accept("application/json"),
        .contentType("application/json")
    ]
    
    func alamofireNetworking(url: String, onSuccess: @escaping onSuccess, onFailure : @escaping onFailure){
        print("alamofireNetworking(url: \(url)")
        guard let sessionUrl = URL(string: url) else {
            print("Invalid URL")
            return
        }
        
        print("sessionUrl: \(sessionUrl)")
        AF.request(sessionUrl,
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: headers)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: T.self){ response in
            print("response: \(response)")
            switch response.result {
            case .success(let value):
                onSuccess(value)
            case .failure(let error):
                print(error)
                onFailure()
            }
        }
    }
    
    
}
