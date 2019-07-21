//
//  SearchMoviesRepo.swift
//  SearchMovies
//
//  Created by Medhat Mebed on 7/21/19.
//  Copyright © 2019 Medhat Mebed. All rights reserved.
//

import Foundation

//MARK: - SearchDelegate to pass all received data and error to the viewcontroller
protocol SearchDelegate : class {
     func searchResultSuccess(result : SearchModel)
    func searchError(error : String)
}
//MARK: - SearchMoviesRepo implements WebserviceDataProtocol to receive data
class SearchMoviesRepo: WebserviceDataProtocol {
    
    public weak var delegate : SearchDelegate?
    //MARK: - the request for movie search
    func searchApi(apiKey : String,query : String, page : Int) {
        let envelop = GetMovieSearch(pathType: .GetIsPhoneExist(apiKey: apiKey, query: query, page: page))
        AppManager.shared().webServiceManager.requestData(envelope: envelop, delegate: self)
        
    }
    //MARK: - WebserviceDataProtocol function that receives all responses
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

