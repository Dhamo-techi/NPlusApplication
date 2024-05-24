//
//  SearchTableViewCell.swift
//  NPlusApplication
//
//  Created by MAC PRO on 23/05/24.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var SearchbrandImg: UIImageView!
    
    @IBOutlet weak var SearchBrandNameLbl: UILabel!
    
    @IBOutlet weak var SearchPrdtTitleLbl: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
