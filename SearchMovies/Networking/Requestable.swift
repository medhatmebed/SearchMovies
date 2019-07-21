//
//  Requestable.swift
//  AvisBudgetGroup
//
//  Created by Medhat on 2019-02-26.
//  Copyright © 2019 Rent Centric. All rights reserved.
//

import Foundation
import Alamofire

protocol Requestable {
    var basePath: String? { get }
    var apiPath: String { get } //Defined in struct - ApiPath
    var httpType: HTTPMethod { get } //POST or GET
    var ref: ResponseParser.Type { get } //For receiving API responses
    var parametersType: REQUEST_PARAM_TYPE { get } //BODY or Query
    var pathType: ServicePath { get set } //View Model's methods. Ex: CustomerLogin(email:String, password:String)
}
extension Requestable {
    var basePath: String? {
        return G_BASE_URL
    }
    
    func requestURL() -> URL? {
        if let path = self.basePath {
            if self.parametersType == .Body {
                
                let fullPath = path + self.apiPath
                return URL(string: fullPath)
                
            } else if self.parametersType == .Query {
                /***** Example of Making 'Query' parameters
                 
                 parameters:
                 ["parameter_1" : 123,
                 "parameter_2" : "abc"]
                 
                 Request_URL = G_BASE_
                 var parametersType: REQUEST_PARAM_TYPE
                 
                 var parametersType: REQUEST_PARAM_TYPE
                 URL + API_NAME
                 
                 => Request_URL + "?" + "parameter_1=123&parameter_2=abc"
                 
                 Ex:
                 G_BASE_URL = "http://www5.rentcentric.com"
                 API_NAME = "/api/Customer/IsEmailExist"
                 parameter = ["email" : "owen%40rentcentric.com"]
                 "http://www5.rentcentric.com/api/Customer/IsEmailExist?email=owen%40rentcentric.com"
                 
                 *****/
                if let queryParameters = self.pathType.httpBodyEnvelop() {
                    var queryRequestValues = "?"
                    for (key, value) in queryParameters {
                        let strValue = "\(value)"
                        let rfc3986Unreserved = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~")
                        let encodedValue = strValue.addingPercentEncoding(withAllowedCharacters: rfc3986Unreserved)
                        queryRequestValues += "\(key)=\(encodedValue ?? "")&"
                    }
                    queryRequestValues = String(queryRequestValues.dropLast()) //To remove the end character '&'
                    
                    let fullPath = path + self.apiPath + queryRequestValues
                    
                    return URL(string: fullPath)
                } else {
                    return nil
                }
            } else if self.parametersType == .Upload {
                if let queryParameters = self.pathType.httpBodyEnvelop() {
                    var queryRequestValues = "?"
                    for (key, value) in queryParameters {
                        if key != KEY_MEDIA_TYPE_NAME
                            && key != KEY_MEDIA_FILE_NAME
                            && key != KEY_MEDIA_MIME_TYPE
                            && key != KEY_MEDIA_DATA {
                            
                            let strValue = "\(value)"
                            let rfc3986Unreserved = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~")
                            let encodedValue = strValue.addingPercentEncoding(withAllowedCharacters: rfc3986Unreserved)
                            queryRequestValues += "\(key)=\(encodedValue ?? "")&"
                        }
                    }
                    queryRequestValues = String(queryRequestValues.dropLast()) //To remove the end character '&'
                    
                    let fullPath = path + self.apiPath + queryRequestValues
                    
                    return URL(string: fullPath)
                } else {
                    return nil
                }
            }
            
        }
        return nil
    }
}
