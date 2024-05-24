//
//  AddToCartVC.swift
//  NPlusApplication
//
//  Created by MAC PRO on 22/05/24.
//

import UIKit

protocol AddToCartDelegate: AnyObject {
    func didAddToCart(name: String, brand: String, imgURL: String)
}

class AddToCartVC: UIViewController, UICollectionViewDelegateFlowLayout {
    
    var timer = Timer()
    var counter = 0
    
    weak var delegate: AddToCartDelegate?
    
    var callBack: ((_ name: String)-> Void)?
    
    var recieveName = String()
    var recieveBrand = String()
    var recievePrice = Int()
    var recieveRating = String()
    var recieveDescription = String()
    var recieveStock = String()
    var recieveImg = String()
    
    @IBOutlet weak var imageClcVw: UICollectionView!
    
    @IBOutlet weak var ImgPageContrtoller: UIPageControl!
    
    @IBOutlet weak var BackBtn: UIButton!
    
    @IBOutlet weak var ratingView: UIView!
    
    @IBOutlet weak var DescView: UIView!
    
    @IBOutlet weak var prdtRatingLbl: UILabel!
    
    @IBOutlet weak var PdtcNameLbl: UILabel!
    
    @IBOutlet weak var PrdtcBrandLbl: UILabel!
    
    @IBOutlet weak var PriceView: UIView!
    
    @IBOutlet weak var prdtcPriceLbl: UILabel!
    
    @IBOutlet weak var prdtcCountLbl: UILabel!
    
    @IBOutlet weak var prdtAddBtn: UIButton!
    
    @IBOutlet weak var prdtMinusBtn: UIButton!
    
    @IBOutlet weak var PrdtDescrptionTextVw: UITextView!
    
    @IBOutlet weak var PrdtStockLbl: UILabel!
    
    @IBOutlet weak var AddToCartBtn: UIButton!
    
    var count: Int = 1 {
        didSet {
            prdtcCountLbl.text = "\(count)"
            updatePrice()
        }
    }
    
    var price : Int = 0 {
        didSet {
            prdtcPriceLbl.text = "\(20)"
            updatePrice()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.navigationController?.isNavigationBarHidden = true
        self.ImgPageContrtoller.bringSubviewToFront(view)
        
        self.imageClcVw.delegate = self
        self.imageClcVw.dataSource = self
        
        self.imageClcVw.register(UINib(nibName: "ImagesCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ImagesCollectionCell")
        
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .vertical
        self.imageClcVw.collectionViewLayout = flowlayout
        
        self.BackBtn.layer.cornerRadius = 10.0
        self.BackBtn.bringSubviewToFront(view)
        
        self.AddToCartBtn.layer.cornerRadius = 30.0
        self.AddToCartBtn.layer.shadowColor = UIColor.black.cgColor
        self.AddToCartBtn.layer.shadowOpacity = 0.5
        self.AddToCartBtn.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.AddToCartBtn.layer.shadowRadius = 10
        
        self.ratingView.layer.cornerRadius = 30.0
        self.ratingView.backgroundColor = .white
        self.ratingView.layer.shadowColor = UIColor.black.cgColor
        self.ratingView.layer.shadowOpacity = 0.5
        self.ratingView.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.ratingView.layer.shadowRadius = 10
        
        self.DescView.layer.cornerRadius = 40.0
        self.DescView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        self.PdtcNameLbl.text = self.recieveName
        self.PrdtcBrandLbl.text = "Brand: \(self.recieveBrand)"
        self.prdtRatingLbl.text = self.recieveRating
        self.PrdtDescrptionTextVw.text = self.recieveDescription
        self.PrdtStockLbl.text = "Only \(self.recieveStock) Left"
        
        self.prdtcCountLbl.text = "\(count)"
        
        let initialPrice = self.recievePrice
        prdtcPriceLbl.text = "\(initialPrice)"
        price = initialPrice
        updatePrice()
        
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func AddToCartBtnTapped(_ sender: Any) {
        callBack?(recieveName)
        delegate?.didAddToCart(name: recieveName, brand: recieveBrand, imgURL: recieveImg)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func prdtAddBtnTapped(_ sender: Any) {
        count += 1
    }
    
    @IBAction func prdtMinusBtnTapped(_ sender: Any) {
        if count > 1 {
            count -= 1
        }
    }
    
    func updatePrice() {
        let totalPrice = count * price
        self.prdtcPriceLbl.text = "\(totalPrice)"
    }
    
    
    
}

extension AddToCartVC : UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.recieveImg.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCollectionCell", for: indexPath) as! ImagesCollectionCell
        let imgurl = URL(string: self.recieveImg)
        URLSession.shared.dataTask(with: imgurl!){ mydata, myres, myerr in
            
            if let err = myerr{
                print(err.localizedDescription)
            }
            
            if let data = mydata{
                let imgdata = UIImage(data: data)
                DispatchQueue.main.async {
                    cell.imageCollectionImgVw.image = imgdata
                }
            }
        }.resume()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = imageClcVw.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
