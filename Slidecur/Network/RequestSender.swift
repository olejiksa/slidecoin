//
//  RequestSender.swift
//  Slidecur
//
//  Created by Oleg Samoylov on 26.11.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import Foundation

protocol RequestSenderProtocol {
    
    func send<Parser>(config: RequestConfig<Parser>,
                     completion: @escaping (Result<Parser.Model, Error>) -> ())
}

final class RequestSender: RequestSenderProtocol {
    
    private let session = URLSession(configuration: .default)
    
    func send<Parser>(config: RequestConfig<Parser>,
                      completion: @escaping (Result<Parser.Model, Error>) -> ()) where Parser: ParserProtocol {
        guard let urlRequest = config.request.urlRequest else {
            completion(.failure(ParserError.urlParserError))
            return
        }
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard
                let data = data,
                let parsedModel: Parser.Model = config.parser.parse(data: data)
            else {
                completion(.failure(ParserError.dataParserError))
                return
            }
            
            completion(.success(parsedModel))
        }
        
        task.resume()
    }
}
