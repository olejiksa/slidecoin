//
//  BuyRequest.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 24.01.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation
import Toolkit

final class BuyRequest: BasePostRequest {
    
    init(productID: Int) {
        let endpoint = "\(RequestFactory.endpointRoot)shop/buy"
        super.init(endpoint: endpoint, parameters: ["id": productID])
    }
    
    override public var urlRequest: URLRequest? {
        var request = super.urlRequest
        guard let accessToken = Global.accessToken else { return request }
        request?.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        return request
    }
}
