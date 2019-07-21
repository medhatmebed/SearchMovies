//
//  SelectedMovieDetailVC.swift
//  SearchMovies
//
//  Created by Medhat Mebed on 7/21/19.
//  Copyright © 2019 Medhat Mebed. All rights reserved.
//

import UIKit
import Kingfisher

class SelectedMovieDetailVC: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieNameLbl: UILabel!
    @IBOutlet weak var movieYearLbl: UILabel!
    @IBOutlet weak var GenresStackView: UIStackView!
    @IBOutlet weak var castStackView: UIStackView!
    @IBOutlet weak var imagesTableView: UITableView!
    @IBOutlet weak var tableviewContainterHeight: NSLayoutConstraint!
    @IBOutlet weak var castViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var favoriteBtn: UIButton!
    
    
    var movieId = 0
    var imagesUrls = [URL]()
    
    //MARK: - Computed Preperties
    var movieYear : String = "" {
        didSet {
            DispatchQueue.main.async {
                self.movieYearLbl.text = self.movieYear
            }
        }
    }
    var movieTitle : String = "" {
        didSet {
            DispatchQueue.main.async {
                self.movieNameLbl.text = self.movieTitle
            }
        }
    }
    var posterUrl : URL? {
        didSet {
            let _posterUrl = self.posterUrl
            DispatchQueue.main.async {
                self.posterImageView.kf.indicatorType = .activity
                self.posterImageView.kf.setImage(with: _posterUrl)
            }
        }
    }
    var genres : [String] = []{
        didSet {
            DispatchQueue.main.async {
                self.setUpAddOns()
            }
        }
    }
    
    var castArray : [String] = [] {
        didSet {
            DispatchQueue.main.async {
                self.setUpCast()
            }
        }
    }
    //MARK: - instance variables
    let selectedMovieDetailRepo = SelectedMovieDetailRepo()
    
    //MARK: - ViewControllers lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedMovieDetailRepo.delegate = self
        
        selectedMovieDetailRepo.getMovieDetail(apiKey: G_CLIENT_ID, movieId: movieId)
    }
    override func viewDidLayoutSubviews() {
        castViewBottomConstraint.constant = imagesTableView.contentSize.height
        tableviewContainterHeight.constant = imagesTableView.contentSize.height
        
    }
    
    //MARK: - Private functions
    private func setUpAddOns() {
        self.GenresStackView.removeAllArrangedSubviews()
        for genre in self.genres.reversed() {
            self.addItemsToStackView(itemInfo: genre, stackView: self.GenresStackView)
        }
    }
    
    private func setUpCast() {
        self.castStackView.removeAllArrangedSubviews()
        for cast in self.castArray.reversed() {
            self.addItemsToStackView(itemInfo: cast, stackView: self.castStackView)
        }
    }
    
    private func addItemsToStackView(itemInfo: String?,stackView : UIStackView) {
        let itemStack = UIStackView(frame: CGRect(x: 0, y: 0, width: stackView.frame.width, height: 20))
        itemStack.axis = .horizontal
        itemStack.alignment = .fill
        itemStack.distribution = .fill
        itemStack.spacing = 10
        
        let itemInfo = itemInfo
        
        let chargeName = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width * 0.7, height: 20))
        chargeName.text = itemInfo ?? "N/A"
        chargeName.textColor = .black
        chargeName.font = .boldSystemFont(ofSize: 20)
        chargeName.setContentHuggingPriority(UILayoutPriority(250), for: .horizontal)
        chargeName.textAlignment = .center
        
        itemStack.addArrangedSubview(chargeName)
        stackView.insertArrangedSubview(itemStack, at: 0)
    }
    
    //MARK: - trigger actions
    @IBAction func actionClickOnFavoriteBtn(_ sender: Any) {
       
    }
}

//MARK: - data received
extension SelectedMovieDetailVC : MovieDetailDelegate {
    func getMovieImagesSuccess(movieImages: MovieImages) {
        #if DEBUG
        print(movieImages)
        #endif
        
        if let posters = movieImages.posters {
            for poster in posters {
                if let url = AppManager.posterUrlFor(size: .width185, poster: poster.filePath ?? "") {
                    imagesUrls.append(url)
                }
            }
        }
        if let backdrops = movieImages.backdrops {
            for backdrop in backdrops {
                if let url = AppManager.posterUrlFor(size: .width185, poster: backdrop.filePath ?? "") {
                    imagesUrls.append(url)
                }
            }
        }
        imagesTableView.reloadData()
    }
    
    func getMovieImagesFail(error: String) {
        AppManager.displayOkayAlert(title: AppManager.G_APP_NAME, message: error, forController: self)
    }
    
    func getMovieCreditsSuccess(movieCredits: MovieCredits) {
        #if DEBUG
        print(movieCredits)
        #endif
        
        selectedMovieDetailRepo.getMovieImages(apiKey: G_CLIENT_ID, movieId: movieId)
        if let castArr = movieCredits.cast {
            for cast in castArr {
                self.castArray.append(cast.name ?? "")
            }
        }
    }
    
    func getMovieCreditsFail(error: String) {
        AppManager.displayOkayAlert(title: AppManager.G_APP_NAME, message: error, forController: self)
    }
    
    func getMovieDetailSuccess(movieDetail: MovieDetail) {
        #if DEBUG
        print(movieDetail)
        #endif
        selectedMovieDetailRepo.getMovieCredits(apiKey: G_CLIENT_ID, movieId: movieId)
        
        movieYear = AppManager.formatDate(movieDetail.releaseDate ?? "") ?? ""
        movieTitle = movieDetail.title ?? ""
        let _posterUrl = movieDetail.posterPath
        posterUrl = AppManager.posterUrlFor(size: .width500, poster: _posterUrl ?? "")
        if let genres = movieDetail.genres {
            for genre in genres {
                self.genres.append(genre.name ?? "")
            }
        }
    }
    func getMovieDetailFailed(error: String) {
        print(error)
    }
}

//MARK: - tableview delegate
extension SelectedMovieDetailVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(imagesUrls.count / 2)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "imagesCell") as? ImagesTableViewCell
        
        cell?.imageOne.kf.indicatorType = .activity
        cell?.imageOne.kf.setImage(with: imagesUrls[indexPath.row * 2])
        cell?.imageTwo.kf.indicatorType = .activity
        cell?.imageTwo.kf.setImage(with: imagesUrls[indexPath.row * 2 + 1])
        
        return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 298
    }
    
    
}

extension UIStackView {
    
    func removeAllArrangedSubviews() {
        
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        
        // Deactivate all constraints
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        
        // Remove the views from self
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}


