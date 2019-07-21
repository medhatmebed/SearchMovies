//
//  FavoriteMoviesVC.swift
//  SearchMovies
//
//  Created by Medhat Mebed on 7/21/19.
//  Copyright © 2019 Medhat Mebed. All rights reserved.
//

import UIKit
import CoreData

class FavoriteMoviesVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noFavoriteMoviesView: UIView!
    
    var movie : [Movie] = [] {
        didSet {
            DispatchQueue.main.async {
                if self.movie.count < 1 {
                    self.noFavoriteMoviesView.isHidden = false
                } else {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        noFavoriteMoviesView.isHidden = true
        fetchDaata()
    }
    
    private func fetchDaata() {
        let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        do {
            let movie = try PersistenceService.context.fetch(fetchRequest)
            self.movie = movie
        } catch {
            noFavoriteMoviesView.isHidden = false
        }
    }

}

extension FavoriteMoviesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movie.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteMovieCell") as? FavoriteTableViewCell
        cell?.movieNameLbl.text = movie[indexPath.row].title ?? ""
        cell?.movieYearlbl.text = movie[indexPath.row].year ?? ""
        return cell ?? UITableViewCell()
    }
    
    
}
