//
//  APIEndPoints.swift
//  AvisBudgetGroup
//
//  Created by Medhat on 2019-02-26.
//  Copyright © 2019 Rent Centric. All rights reserved.
//

import Foundation
import Alamofire

protocol ParameterBodyMaker {
    func httpBodyEnvelop() -> [String: Any]?
    func encodeBodyEnvelop() throws -> Data?
}

internal enum ServicePath: ParameterBodyMaker {
  
    
    
    func encodeBodyEnvelop() throws -> Data? {
        do {
            if let body = self.httpBodyEnvelop() {
                let data = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
                return data
            }
        } catch {
            throw error
        }
        return nil
    }
    
    //MARK: - API Request Parameters
    func httpBodyEnvelop() -> [String : Any]? {
        return [:]
    }
}

// MARK: - API Category - Customer



