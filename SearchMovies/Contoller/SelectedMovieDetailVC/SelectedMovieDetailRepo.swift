//
//  SelectedMovieDetailRepo.swift
//  SearchMovies
//
//  Created by Medhat Mebed on 7/21/19.
//  Copyright © 2019 Medhat Mebed. All rights reserved.
//

import Foundation

//MARK: - MovieDetailDelegate to pass all received data and error to the viewcontroller
protocol MovieDetailDelegate : class {
    func getMovieDetailSuccess(movieDetail : MovieDetail)
    func getMovieDetailFailed(error : String)
    func getMovieCreditsSuccess(movieCredits: MovieCredits)
    func getMovieCreditsFail(error : String)
    func getMovieImagesSuccess(movieImages: MovieImages)
    func getMovieImagesFail(error : String)
}
//MARK: - SelectedMovieDetailRepo implements WebserviceDataProtocol to receive data
class SelectedMovieDetailRepo: WebserviceDataProtocol {
    
    public weak var delegate : MovieDetailDelegate?
    //MARK: - the request to get movieImages
    func getMovieImages(apiKey: String,movieId: Int){
        ApiPath.G_GET_MOVIE_IMAGES = "movie/" + "\(movieId)/" + "images"
        let envelop = GetMoviesImages(pathType: .GetMovieImages(apiKey: apiKey))
        AppManager.shared().webServiceManager.requestData(envelope: envelop, delegate: self)
    }
    //MARK: - the request to get movieCast
    func getMovieCredits(apiKey: String,movieId: Int){
        ApiPath.G_GET_MOVIE_CREDITS = "movie/" + "\(movieId)/" + "credits"
        let envelop = GetMovieCredits(pathType: .GetMovieCredits(apiKey: apiKey))
        AppManager.shared().webServiceManager.requestData(envelope: envelop, delegate: self)
    }
    //MARK: - the request to get movieDetail
    func getMovieDetail(apiKey : String,movieId : Int) {
        ApiPath.G_GET_ACTION_MOVIE_DETAIL = "movie/" + "\(movieId)"
        let envelop = GetMovieDetail(pathType: .GetMovieDetail(apiKey: apiKey))
        AppManager.shared().webServiceManager.requestData(envelope: envelop, delegate: self)
    }
    //MARK: - WebserviceDataProtocol function that receives all responses
    func dataRecieved(data: [ResponseParser]?, errorMessage: String?, envelope: Requestable) {
        //MARK: - response for get images
        if envelope.apiPath.contains("images") {
            if let error = errorMessage {
                #if DEBUG
                print(error)
                #endif
                self.delegate?.getMovieImagesFail(error: error)
            }
            if let response : MovieImages = (data as? [MovieImages])?.first {
                self.delegate?.getMovieImagesSuccess(movieImages: response)
            } else {
                self.delegate?.getMovieImagesFail(error: "Error Parse MovieImages")
            }
        }
        //MARK: - response for get credits or the movie cast
        else if envelope.apiPath.contains("credits") {
            if let error = errorMessage {
                #if DEBUG
                print(error)
                #endif
                self.delegate?.getMovieCreditsFail(error: error)
            }
            if let response : MovieCredits = (data as? [MovieCredits])?.first {
                self.delegate?.getMovieCreditsSuccess(movieCredits: response)
            } else {
                self.delegate?.getMovieCreditsFail(error: "Error Parse MovieCredits")
            }
        }
        //MARK: - response for get Movie Detail
        else if envelope.apiPath.contains(ApiPath.G_GET_ACTION_MOVIE_DETAIL) {
            if let error = errorMessage {
                #if DEBUG
                print(error)
                #endif
                self.delegate?.getMovieDetailFailed(error: error)
            }
            if let response : MovieDetail = (data as? [MovieDetail])?.first {
                self.delegate?.getMovieDetailSuccess(movieDetail: response)
            } else {
                self.delegate?.getMovieDetailFailed(error: "Error Parse MovieDetail")
            }
        }
    }
    
}
