//
//  DeleteAllUsersRequest.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 19.12.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import Toolkit

final class DeleteAllUsersRequest: BaseDeleteRequest {
    
    init() {
        let endpoint = "\(RequestFactory.endpointRoot)users"
        super.init(endpoint: endpoint)
    }
}
