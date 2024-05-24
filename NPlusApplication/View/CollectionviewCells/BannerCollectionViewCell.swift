//
//  BannerCollectionViewCell.swift
//  NPlusApplication
//
//  Created by MAC PRO on 15/05/24.
//

import UIKit

class BannerCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var bannerImgVw: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layer.cornerRadius = 20.0
        layer.masksToBounds = true
    }

}
