//
//  TableViewCell.swift
//  SearchMovies
//
//  Created by Medhat Mebed on 7/21/19.
//  Copyright © 2019 Medhat Mebed. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var loadMoreBtn: UIButton!
    @IBOutlet weak var titlelbl: UILabel!
    
    var loadMore : (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        loadMoreBtn.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func loadMoreBtnPressed(_ sender: Any) {
        loadMore?()
    }
    
}
