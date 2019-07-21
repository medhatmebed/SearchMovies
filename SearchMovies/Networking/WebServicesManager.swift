//
//  WebServicesManager.swift
//  AvisBudgetGroup
//
//  Created by Medhat on 2019-02-26.
//  Copyright © 2019 Rent Centric. All rights reserved.
//

enum REQUEST_PARAM_TYPE {
    case Query
    case Body
    case Upload
}

protocol WebserviceDataProtocol {
    func dataRecieved(data: [ResponseParser]?, errorMessage: String?, envelope: Requestable )
}

protocol ResponseParser {
    static func parseJson(json: Any) -> [ResponseParser]?
}

import Foundation
import Alamofire

let REQUEST_TIME_OUT = 500

let KEY_MEDIA_TYPE_NAME = "MediaTypeName"
let KEY_MEDIA_FILE_NAME = "MediaFileName"
let KEY_MEDIA_MIME_TYPE = "MediaMimeType"
let KEY_MEDIA_DATA = "MediaData"
let KEY_MEDIA_PARAMETERS = "MediaParameters"

class WebServicesManager: NSObject {
    private var sessionManager = Alamofire.SessionManager()
    var delegate: WebserviceDataProtocol?
    
    func requestData(envelope: Requestable, delegate: WebserviceDataProtocol, isUploadMedia: Bool = false) {
        self.delegate = delegate
        
        if isUploadMedia == false {
            if AppManager.shared().isNetworkConnection {
                let headers: HTTPHeaders = [
                    "Content-Type": "application/json"
                ]
                
                if let requestUrl = envelope.requestURL() {
                    let configuration = URLSessionConfiguration.default
                    configuration.timeoutIntervalForResource = TimeInterval(REQUEST_TIME_OUT)
                    configuration.timeoutIntervalForRequest = TimeInterval(REQUEST_TIME_OUT)
                    self.sessionManager = Alamofire.SessionManager(configuration: configuration)
                    
                    var requestParameters = envelope.pathType.httpBodyEnvelop()
                    
                    #if DEBUG
                    print("API: \(requestUrl)\n\n-------------\n")
                    print("Request Parameters: \n\(requestParameters ?? [String : Any]())\n\n-------------\n")
                    #endif
                    
                    if envelope.parametersType == .Query {
                        requestParameters = nil
                    }
                    
                    Alamofire.request(requestUrl,
                                      method: envelope.httpType,
                                      parameters: requestParameters,
                                      encoding: JSONEncoding.default,
                                      headers: headers).responseJSON { (response) in
                                        
                                        self.responseHandler(response: response, envelope: envelope)
                    }
                } else {
                    self.delegate?.dataRecieved(data: nil, errorMessage: "Error Request", envelope: envelope)
                    
                }
            }
        } else {
            if AppManager.shared().isNetworkConnection {
                
                let headers: HTTPHeaders = [
                    "Content-type": "multipart/form-data"
                ]
                
                if let requestUrl = envelope.requestURL() {
                    let configuration = URLSessionConfiguration.default
                    configuration.timeoutIntervalForResource = TimeInterval(REQUEST_TIME_OUT)
                    configuration.timeoutIntervalForRequest = TimeInterval(REQUEST_TIME_OUT)
                    self.sessionManager = Alamofire.SessionManager(configuration: configuration)
                    
                    var requestParameters = envelope.pathType.httpBodyEnvelop()
                    
                    let mediaTypeName = requestParameters?[KEY_MEDIA_TYPE_NAME] as? String
                    let mediaFileName = requestParameters?[KEY_MEDIA_FILE_NAME] as? String
                    let mediaMimeType = requestParameters?[KEY_MEDIA_MIME_TYPE] as? String
                    let mediaData = requestParameters?[KEY_MEDIA_DATA] as? Data
                    
                    #if DEBUG
                    print("API: \(requestUrl)\n\n-------------\n")
                    print("Request Parameters: \n\(requestParameters ?? [String : Any]())\n\n-------------\n")
                    #endif
                    
                    Alamofire.upload(multipartFormData: { (multipartFormData) in
                        
                        if let data = mediaData,
                            let typeName = mediaTypeName, typeName == "image",
                            let fileName = mediaFileName,
                            let mimeType = mediaMimeType
                        {
                            multipartFormData.append(data, withName: typeName,
                                                     fileName: fileName, mimeType: mimeType)
                        }
                        
                    }, usingThreshold: UInt64.init(), to: requestUrl, method: .post, headers: headers) { (result) in
                        switch result{
                        case .success(let upload, _, _):
                            upload.responseJSON { response in
                                self.responseHandler(response: response, envelope: envelope)
                            }
                        case .failure(let error):
                            #if DEBUG
                            print("Error in upload: \(error.localizedDescription)")
                            #endif
                            self.delegate?.dataRecieved(data: nil, errorMessage: "Error Request", envelope: envelope)
                        }
                    }
                } else {
                    self.delegate?.dataRecieved(data: nil, errorMessage: "Error Request", envelope: envelope)
                    
                }
            }
        }
    }
    
    func responseHandler(response: DataResponse<Any>, envelope: Requestable) {
        if(response.result.isSuccess) {
            #if DEBUG
            print("=== \(envelope.apiPath) === Response:\n\(response.value ?? [String: Any]())\n\n")
            #endif
            
            if let responseDict = response.value as? [String: Any] {
                let data = envelope.ref.parseJson(json: responseDict)
                self.delegate?.dataRecieved(data: data, errorMessage: nil, envelope: envelope)
            } else {
                if let responseString = response.value {
                    let data = envelope.ref.parseJson(json: responseString)
                    self.delegate?.dataRecieved(data: data, errorMessage: nil, envelope: envelope)
                }
            }
        } else {
            self.delegate?.dataRecieved(data: nil, errorMessage: response.result.error?.localizedDescription, envelope: envelope)
        }
    }
    
}
