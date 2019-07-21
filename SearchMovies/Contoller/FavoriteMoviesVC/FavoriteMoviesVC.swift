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
    
    //MARK: - Internal Preperties
    var refreshControl = UIRefreshControl()
    
    //MARK: - Computed Preperties
    var movie : [Movie] = [] {
        didSet {
            DispatchQueue.main.async {
                if self.movie.count < 1 {
                    self.noFavoriteMoviesView.isHidden = false
                } else {
                    self.tableView.reloadData()
                    self.noFavoriteMoviesView.isHidden = true
                }
            }
        }
    }
    
    //MARK: - ViewControllers lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        noFavoriteMoviesView.isHidden = true
        addRefreshController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchDaata()
    }
    
    //MARK: - Private functions
    private func addRefreshController() {
        tableView.addSubview(refreshControl)
        self.refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
    }
    
    @objc func refresh(sender:AnyObject) {
        fetchDaata()
        refreshControl.endRefreshing()
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

//MARK: - tableview delegate
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            PersistenceService.delete(self.movie[indexPath.row])
            fetchDaata()
        }
    }
    
    
}
