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
    case GetIsPhoneExist(apiKey: String, query : String, page : Int)
    case GetMovieDetail(apiKey : String)
    case GetMovieCredits(apiKey : String)
    case GetMovieImages(apiKey : String)
    
    func httpBodyEnvelop() -> [String : Any]? {
        switch self {
        case .GetIsPhoneExist(apiKey: let apiKey, query : let query, page : let page):
            let getQuery = ["api_key" : apiKey,
                            "query" : query,
                            "page" : page] as [String : Any]
            return getQuery
            
        case.GetMovieDetail(apiKey: let apiKey):
            let getQuery = ["api_key" : apiKey]
            return getQuery
        case.GetMovieCredits(apiKey: let apiKey):
            let getQuery = ["api_key" : apiKey]
            return getQuery
        case .GetMovieImages(apiKey: let apiKey):
            let getQuery = ["api_key" : apiKey]
            return getQuery
        }
    }
}

// MARK: - API Category - Customer
struct GetMovieSearch : Requestable {
    var apiPath: String { return ApiPath.G_GET_ACTION_SEARCH_MOVIE }
    var httpType: HTTPMethod { return .get }
    var ref: ResponseParser.Type { return SearchModel.self}
    var parametersType: REQUEST_PARAM_TYPE { return .Query }
    var pathType: ServicePath
}
struct GetMovieDetail : Requestable {
    var apiPath: String { return ApiPath.G_GET_ACTION_MOVIE_DETAIL }
    var httpType: HTTPMethod { return .get }
    var ref: ResponseParser.Type { return MovieDetail.self}
    var parametersType: REQUEST_PARAM_TYPE { return .Query }
    var pathType: ServicePath
}
struct GetMovieCredits: Requestable {
    var apiPath: String { return ApiPath.G_GET_MOVIE_CREDITS }
    var httpType: HTTPMethod { return .get }
    var ref: ResponseParser.Type { return MovieCredits.self}
    var parametersType: REQUEST_PARAM_TYPE { return .Query }
    var pathType: ServicePath
}
struct GetMoviesImages: Requestable {
    var apiPath: String { return ApiPath.G_GET_MOVIE_IMAGES }
    var httpType: HTTPMethod { return .get }
    var ref: ResponseParser.Type { return MovieImages.self}
    var parametersType: REQUEST_PARAM_TYPE { return .Query }
    var pathType: ServicePath
}

