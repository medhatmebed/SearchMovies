//
//  FavoriteMoviesVC.swift
//  SearchMovies
//
//  Created by Medhat Mebed on 7/21/19.
//  Copyright © 2019 Medhat Mebed. All rights reserved.
//

import UIKit

class FavoriteMoviesVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

extension FavoriteMoviesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteMovieCell") as? FavoriteTableViewCell
        cell?.movieNameLbl.text = "Medhat"
        cell?.movieYearlbl.text = "1993"
        return cell ?? UITableViewCell()
    }
    
    
}
