//
//  ViewController.swift
//  SearchMovies
//
//  Created by Medhat Mebed on 7/21/19.
//  Copyright © 2019 Medhat Mebed. All rights reserved.
//

import UIKit

class SearchMoviesVC: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var page = 1
    var lastPage = 0
    var query = ""
    var ids = [Int]()
    var id = 0
    
    //MARK: - computed variables
    var tableViewResult: [String?] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: - instances
    let searchMoviesRepo = SearchMoviesRepo()
    let searchController = UISearchController(searchResultsController: nil)
    
    //MARK: - viewController lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        searchMoviesRepo.delegate = self
        navigationController?.navigationBar.prefersLargeTitles = true
        setupSearchBar()
    }
    
    //MARK: - private functions
    private func setupSearchBar() {
        definesPresentationContext = true
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.keyboardAppearance = .dark
        searchController.searchBar.barStyle = .black
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSelectedMovieDetailVC" {
            let destination = segue.destination as! SelectedMovieDetailVC
            destination.movieId = id
        }
    }
}

//MARK: - data received
extension SearchMoviesVC : SearchDelegate {
    func searchResultSuccess(result: SearchModel) {
        self.lastPage = result.totalPages ?? 0
        if let resultArray = result.results {
            for result in resultArray {
                tableViewResult.append(result.title ?? "")
                ids.append(result.id ?? 0)
            }
        }
        #if DEBUG
        print(result)
        #endif
        tableView.reloadData()
    }
    func searchError(error: String) {
        AppManager.displayOkayAlert(title: AppManager.G_APP_NAME, message: error, forController: self)
    }
}

//MARK: - tableview delegate
extension SearchMoviesVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searResultSearch") as? SearchTableViewCell
        
        cell?.titlelbl?.text = tableViewResult[indexPath.row]
        if indexPath.row == tableViewResult.count - 1 && self.lastPage > self.page {
            cell?.loadMoreBtn.isHidden = false
            cell?.loadMore = { [weak self] in
                self?.page += 1
                DispatchQueue.main.async {
                    self?.searchMoviesRepo.searchApi(apiKey: G_CLIENT_ID, query: self?.query ?? "", page: self?.page ?? 0)
                }
            }
        } else {
            cell?.loadMoreBtn.isHidden = true
        }
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        id = ids[indexPath.row]
        performSegue(withIdentifier: "goToSelectedMovieDetailVC", sender: nil)
    }
    
}

//MARK: - searchbar delegate
extension SearchMoviesVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchTextModify = searchText.replacingOccurrences(of: " ", with: "+")
        self.query = searchTextModify
        tableViewResult.removeAll()
        ids.removeAll()
        DispatchQueue.main.async {
            self.searchMoviesRepo.searchApi(apiKey: G_CLIENT_ID, query: self.query, page: self.page)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = " "
        tableViewResult.removeAll()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
