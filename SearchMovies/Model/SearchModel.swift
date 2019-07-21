//
//  SearchModel.swift
//  SearchMovies
//
//  Created by Medhat Mebed on 7/21/19.
//  Copyright © 2019 Medhat Mebed. All rights reserved.
//

import Foundation


struct SearchModel: Codable, ResponseParser {

    
    let page: Int?
    let results: [Result]?
    let totalResults, totalPages: Int?
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalResults = "total_results"
        case totalPages = "total_pages"
    }
    
    static func parseJson(json: Any) -> [ResponseParser]? {
        if let jsonDict = json as? ([String : AnyObject]) {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: jsonDict)
                let decodedResponseInfo = try JSONDecoder().decode(SearchModel.self, from: jsonData)
                
                return [decodedResponseInfo]
            } catch {
                #if DEBUG
                print(error)
                #endif
                return []
            }
        }
        return []
    }

}
struct Result: Codable {
    let posterPath: String?
    let id: Int?
    let originalTitle: String?
    let title: String?
  
    
    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case id
        case originalTitle = "original_title"
        case title
   
    }
}
