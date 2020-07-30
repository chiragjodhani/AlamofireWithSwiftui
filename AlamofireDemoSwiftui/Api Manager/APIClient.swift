//
//  APIClient.swift
//  AlamofireDemoSwiftui
//
//  Created by Chirag's on 17/04/20.
//  Copyright © 2020 Chirag's. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

final class APIClient {
    private let manager : Session
    private let baseURL = URL(string: "https://reqres.in")!
    public class var sharedInstance: APIClient {
        struct Singleton {
            static let instance : APIClient = APIClient()
        }
        return Singleton.instance
    }
    init() {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 15
        configuration.httpMaximumConnectionsPerHost = 20
        let interceptor = Interceptor(
            retriers: [RetryPolicy(retryLimit: 3)]
        )
        self.manager = Session(configuration: configuration,interceptor: interceptor)
    }
    func request<T: ResponseModel> (
        method: HTTPMethod,
        parameters: Parameters?,
        path: String,
        responseModel: T.Type,
        completion: @escaping (T?, String?) -> Void) {
        let url = self.url(path: path)
        self.manager.request(url, method: method, parameters: parameters ?? nil, headers: nil ).responseObject { ( response : DataResponse<T,AFError>) in
            guard let requestResponseValue = response.value else {
                completion(nil, response.error?.localizedDescription ?? "")
                return
            }
            completion(requestResponseValue, nil)
        }
    }
    private func url(path: String) -> URL {
        return URL(string: baseURL.appendingPathComponent(path).absoluteString.removingPercentEncoding!)!
    }
}

class API {
    static let apiClient = APIClient.sharedInstance
    static func fetchUserData(completion: @escaping (UsersResponseModal?, String?) -> Void) {
        apiClient.request(method: .get, parameters: nil, path: "/api/users?page=1", responseModel: UsersResponseModal.self) { (response, error) in
            completion(response,error)
        }
    }
}
