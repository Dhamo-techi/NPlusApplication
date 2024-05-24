//
//  VendorsCollectionViewCell.swift
//  NPlusApplication
//
//  Created by MAC PRO on 15/05/24.
//

import UIKit

class VendorsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var prosuctImgVw: UIImageView!
    
    @IBOutlet weak var productTitleLbl: UILabel!
    
    @IBOutlet weak var ProductBrand: UILabel!
    
    @IBOutlet weak var productCategory: UILabel!
    
    @IBOutlet weak var productDescription: UILabel!
    
    @IBOutlet weak var OfferLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        layer.cornerRadius = 20.0
        layer.masksToBounds = true
        
        self.prosuctImgVw.layer.cornerRadius = 20.0
    }

}
