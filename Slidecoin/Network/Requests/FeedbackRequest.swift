//
//  FeedbackRequest.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 31.01.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation
import Toolkit

final class FeedbackRequest: BasePostRequest {
    
    init(body: String) {
        let endpoint = "\(RequestFactory.endpointRoot)support"
        let parameters = ["body": body]
        super.init(endpoint: endpoint, parameters: parameters)
    }
    
    override public var urlRequest: URLRequest? {
        var request = super.urlRequest
        guard let accessToken = Global.accessToken else { return request }
        request?.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        return request
    }
}

