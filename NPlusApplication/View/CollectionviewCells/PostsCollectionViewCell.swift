//
//  PostsCollectionViewCell.swift
//  NPlusApplication
//
//  Created by MAC PRO on 23/05/24.
//

import UIKit

class PostsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var userIdLbl: UILabel!
    
    @IBOutlet weak var TitleLbl: UILabel!
    
    @IBOutlet weak var StoryLbl: UITextView!
    
    @IBOutlet weak var tag1Lbl: UILabel!
    
    @IBOutlet weak var tag2Lbl: UILabel!
    
    @IBOutlet weak var tag3Lbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 20.0
        
        self.tag1Lbl.layer.cornerRadius = 15.0
        self.tag1Lbl.layer.masksToBounds = true
        
        self.tag2Lbl.layer.cornerRadius = 15.0
        self.tag2Lbl.layer.masksToBounds = true
        
        self.tag3Lbl.layer.cornerRadius = 15.0
        self.tag3Lbl.layer.masksToBounds = true
    }

}
