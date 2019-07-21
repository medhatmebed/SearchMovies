//
//  ApiConstants.swift
//  AvisBudgetGroup
//
//  Created by Medhat on 2019-02-26.
//  Copyright © 2019 Rent Centric. All rights reserved.
//

import Foundation
import Alamofire

//Client Info
let G_CLIENT_ID = "fd2b04342048fa2d5f728561866ad52a"
let G_BASE_URL = "https://api.themoviedb.org/3/"
let imagesBaseUrl = "https://image.tmdb.org/t/p/"


struct ApiPath {
    //POST Methods
    
    //UPLOAD POST Methods
    
    //GET Methods
    static let G_GET_ACTION_SEARCH_MOVIE = "search/movie"
    static var G_GET_ACTION_MOVIE_DETAIL = "movie"
    static var G_GET_MOVIE_CREDITS = "/movie/{movie_id}/credits"
    static var G_GET_MOVIE_IMAGES = "/movie/{movie_id}/images"
    
}
