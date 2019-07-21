//
//  FavoriteTableViewCell.swift
//  SearchMovies
//
//  Created by Medhat Mebed on 7/21/19.
//  Copyright © 2019 Medhat Mebed. All rights reserved.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {

    @IBOutlet weak var movieNameLbl: UILabel!
    @IBOutlet weak var movieYearlbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
