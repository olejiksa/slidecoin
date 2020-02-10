//
//  RequestSender.swift
//  Toolkit
//
//  Created by Oleg Samoylov on 26.11.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import Foundation
import Toolkit
import UIKit

public protocol RequestSenderProtocol {
    
    func send<Parser>(config: RequestConfig<Parser>,
                     completion: @escaping (Result<Parser.Model, Error>) -> ())
}

@available(iOS 13.0, *)
public final class RequestSender: RequestSenderProtocol {
    
    private let session = URLSession(configuration: .default)
    
    public init() {}
    
    public func send<Parser>(config: RequestConfig<Parser>,
                             completion: @escaping (Result<Parser.Model, Error>) -> ()) where Parser: ParserProtocol {
        guard let urlRequest = config.request.urlRequest else {
            DispatchQueue.main.async {
                completion(.failure(ParserError.urlParserError))
            }
            
            return
        }
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            guard
                let httpResponse = response as? HTTPURLResponse,
                let statusCode = HttpStatusCode(rawValue: httpResponse.statusCode)
            else { return }
            
            switch statusCode {
            case .ok, .badRequest:
                break
                
            case .unauthorized:
                DispatchQueue.main.async {
                    let scene = UIApplication.shared.connectedScenes.first
                    if let mySceneDelegate = scene?.delegate as? SceneDelegate {
                        let vc = AuthViewController()
                        let nvc = UINavigationController(rootViewController: vc)
                        mySceneDelegate.window?.rootViewController = nvc
                    }
                }
                
                return
                
            default:
                DispatchQueue.main.async {
                    completion(.failure(ResponseError(statusCode)))
                }
                
                return
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                
                return
            }
            
            if let data = data {
                print(String(data: data, encoding: .utf8) ?? "")
            }
            
            guard
                let data = data,
                let parsedModel: Parser.Model = config.parser.parse(data: data)
            else {
                DispatchQueue.main.async {
                    completion(.failure(ParserError.dataParserError))
                }
                
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(parsedModel))
            }
        }
        
        task.resume()
    }
}
