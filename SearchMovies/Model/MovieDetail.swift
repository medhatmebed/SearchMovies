//
//  MovieDetail.swift
//  SearchMovies
//
//  Created by Medhat Mebed on 7/21/19.
//  Copyright © 2019 Medhat Mebed. All rights reserved.
//

import Foundation

// MARK: - MovieDetail
struct MovieDetail: Codable , ResponseParser {
    let genres: [Genre]?
    let homepage: String?
    let id: Int?
    let posterPath: String?
    let originalTitle: String?
    let releaseDate: String?
    let status,title: String?
    
    enum CodingKeys: String, CodingKey {
        case genres, homepage, id
        case originalTitle = "original_title"
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case status,title
    }
    static func parseJson(json: Any) -> [ResponseParser]? {
        if let jsonDict = json as? ([String : AnyObject]) {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: jsonDict)
                let decodedResponseInfo = try JSONDecoder().decode(MovieDetail.self, from: jsonData)
                
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

// MARK: - Genre
struct Genre: Codable {
    let id: Int?
    let name: String?
}

