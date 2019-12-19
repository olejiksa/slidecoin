//
//  BasePostRequest.swift
//  Slidecur
//
//  Created by Oleg Samoylov on 26.11.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import Foundation

class BasePostRequest: RequestProtocol {
    
    private let endpoint: String
    private let parameters: [String: Any]
    
    init(endpoint: String, parameters: [String: Any]) {
        self.endpoint = endpoint
        self.parameters = parameters
    }
    
    var urlRequest: URLRequest? {
        let encodedString = endpoint.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        guard let url = URL(string: encodedString) else { return nil }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        request.httpBody = jsonData
        
        return request
    }
}
