//
//  MovieCredits.swift
//  SearchMovies
//
//  Created by Medhat Mebed on 7/21/19.
//  Copyright © 2019 Medhat Mebed. All rights reserved.
//

import Foundation

// MARK: - MovieCredits
struct MovieCredits: Codable, ResponseParser {
   
    let id: Int?
    let cast: [Cast]?
    let crew: [Crew]?
    
    static func parseJson(json: Any) -> [ResponseParser]? {
        if let jsonDict = json as? ([String : AnyObject]) {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: jsonDict)
                let decodedResponseInfo = try JSONDecoder().decode(MovieCredits.self, from: jsonData)
                
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

// MARK: - Cast
struct Cast: Codable {
    let castID: Int?
    let character, creditID: String?
    let gender, id: Int?
    let name: String?
    let order: Int?
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case castID = "cast_id"
        case character
        case creditID = "credit_id"
        case gender, id, name, order
        case profilePath = "profile_path"
    }
}

// MARK: - Crew
struct Crew: Codable {
    let creditID, department: String?
    let gender, id: Int?
    let job, name: String?
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case creditID = "credit_id"
        case department, gender, id, job, name
        case profilePath = "profile_path"
    }
}

