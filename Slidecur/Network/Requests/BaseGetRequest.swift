//
//  BaseGetRequest.swift
//  Slidecur
//
//  Created by Oleg Samoylov on 26.11.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import Foundation

class BaseGetRequest: RequestProtocol {
    
    private let endpoint: String
    private let parameters: [String: Any]
    
    init(endpoint: String, parameters: [String: Any]) {
        self.endpoint = endpoint
        self.parameters = parameters
    }
    
    var urlRequest: URLRequest? {
        let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        guard let url = URL(string: encodedString) else { return nil }
        return URLRequest(url: url)
    }
    
    private var urlString: String {
        var formingString = String()
        
        for pair in parameters {
            formingString.append("\(pair.key)=\(pair.value)&")
        }
        
        return String("\(endpoint)?\(formingString.dropLast())")
    }
}
