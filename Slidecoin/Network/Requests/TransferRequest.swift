//
//  TransferRequest.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 17.01.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation
import Toolkit

final class TransferRequest: BasePostRequest {

    init(senderID: Int, receiverID: Int, amount: Int) {
        let endpoint = "\(RequestFactory.endpointRoot)transaction"
        let parameters = ["sender_id": senderID,
                          "receiver_id": receiverID,
                          "amount": amount]
        
        super.init(endpoint: endpoint, parameters: parameters)
    }
}
