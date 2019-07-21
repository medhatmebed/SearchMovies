//
//  MovieImages.swift
//  SearchMovies
//
//  Created by Medhat Mebed on 7/21/19.
//  Copyright © 2019 Medhat Mebed. All rights reserved.
//

import Foundation

// MARK: - MovieImages
struct MovieImages: Codable, ResponseParser {
    
    let id: Int?
    let backdrops, posters: [Backdrop]?
    
    static func parseJson(json: Any) -> [ResponseParser]? {
        if let jsonDict = json as? ([String : AnyObject]) {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: jsonDict)
                let decodedResponseInfo = try JSONDecoder().decode(MovieImages.self, from: jsonData)
                
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

// MARK: - Backdrop
struct Backdrop: Codable {
    let aspectRatio: Double?
    let filePath: String?
    let height: Int?
    let iso639_1: String?
    let voteCount, width: Int?
    
    enum CodingKeys: String, CodingKey {
        case aspectRatio = "aspect_ratio"
        case filePath = "file_path"
        case height
        case iso639_1 = "iso_639_1"
        case voteCount = "vote_count"
        case width
    }
    
}
