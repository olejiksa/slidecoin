//
//  ResetRequest.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 17.01.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation
import Toolkit

final class ResetRequest: BasePostRequest {
    
    init(currentPassword: String,
         newPassword: String) {
        let endpoint = "\(RequestFactory.endpointRoot)password/change"
        let parameters = ["current_password": currentPassword,
                          "new_password": newPassword]
                          
        super.init(endpoint: endpoint, parameters: parameters)
    }
    
    override public var urlRequest: URLRequest? {
        var request = super.urlRequest
        guard let accessToken = Global.accessToken else { return request }
        request?.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        return request
    }
}
