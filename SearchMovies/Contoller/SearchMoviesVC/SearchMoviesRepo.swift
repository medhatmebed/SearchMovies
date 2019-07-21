//
//  SearchMoviesRepo.swift
//  SearchMovies
//
//  Created by Medhat Mebed on 7/21/19.
//  Copyright © 2019 Medhat Mebed. All rights reserved.
//

import Foundation
protocol SearchDelegate : class {
     func searchResultSuccess(result : SearchModel)
    func searchError(error : String)
}

class SearchMoviesRepo: WebserviceDataProtocol {
    
    public weak var delegate : SearchDelegate?
    
    func searchApi(apiKey : String,query : String, page : Int) {
        let envelop = GetMovieSearch(pathType: .GetIsPhoneExist(apiKey: apiKey, query: query, page: page))
        AppManager.shared().webServiceManager.requestData(envelope: envelop, delegate: self)
        
    }
    
    func dataRecieved(data: [ResponseParser]?, errorMessage: String?, envelope: Requestable) {
        if let error = errorMessage {
            #if DEBUG
            print(error)
            #endif
            self.delegate?.searchError(error: error)
        }
        
        if envelope.apiPath.contains(ApiPath.G_GET_ACTION_SEARCH_MOVIE) {
            if let response : SearchModel = (data as? [SearchModel])?.first {
                self.delegate?.searchResultSuccess(result: response)
            } else {
                self.delegate?.searchError(error: "error parse SearchMovies")
            }
        }
    }
    
}

