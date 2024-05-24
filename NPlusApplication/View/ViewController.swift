//
//  ViewController.swift
//  NPlusApplication
//
//  Created by MAC PRO on 15/05/24.
//

import UIKit

class ViewController: UIViewController, AddToCartDelegate {
    
    var timer = Timer()
    var counter = 0
    
    var getAPIdata : [Products] = []
    
    var passname = String()
    var passBrand = String()
    var passdPrice = Int()
    var passRating = String()
    var passDescription = String()
    var passStock = String()
    var passImg = String()
    
    @IBOutlet weak var TotalScrollView: UIScrollView!
    
    @IBOutlet weak var AppTitleLbl: UILabel!
    
    @IBOutlet weak var cartView: UIView!
    
    @IBOutlet weak var viewCartBtn: UIButton!
    
    @IBOutlet weak var SelectedprdtImgVw: UIImageView!
    
    @IBOutlet weak var selectedBrandLbl: UILabel!
    
    @IBOutlet weak var selectedPrdtTitleLbl: UILabel!
    
    @IBOutlet weak var vendorsCollectionView: UICollectionView!
    
    @IBOutlet weak var OfferCollectionview: UICollectionView!
    
    @IBOutlet weak var bannerPageController: UIPageControl!
    
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    
    @IBOutlet weak var searchBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true

        self.OfferCollectionview.register(UINib(nibName: "OfferCollectionCell", bundle: nil), forCellWithReuseIdentifier: "OfferCollectionCell")
        self.OfferCollectionview.showsHorizontalScrollIndicator = false
        
        self.bannerCollectionView.register(UINib(nibName: "BannerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BannerCollectionViewCell")
        self.bannerCollectionView.showsHorizontalScrollIndicator = false
        
        self.vendorsCollectionView.register(UINib(nibName: "VendorsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "VendorsCollectionViewCell")
        self.vendorsCollectionView.showsHorizontalScrollIndicator = false
        
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .horizontal
        self.OfferCollectionview.collectionViewLayout = flowlayout
        
        let Bannerflowlayout = UICollectionViewFlowLayout()
        Bannerflowlayout.scrollDirection = .horizontal
        self.bannerCollectionView.collectionViewLayout = Bannerflowlayout
        
        let Vendorflowlayout = UICollectionViewFlowLayout()
        Vendorflowlayout.scrollDirection = .vertical
        self.vendorsCollectionView.collectionViewLayout = Vendorflowlayout
        
        self.cartView.isHidden = true
        self.cartView.layer.cornerRadius = 30.0
        self.cartView.bringSubviewToFront(view)
        self.cartView.layer.shadowColor = UIColor.black.cgColor
        self.cartView.layer.shadowOpacity = 0.5
        self.cartView.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.cartView.layer.shadowRadius = 10
        
        self.searchBtn.layer.cornerRadius = 12.0
        self.searchBtn.layer.borderWidth = 2.0
        self.searchBtn.layer.borderColor = UIColor.lightGray.cgColor
        
        self.SelectedprdtImgVw.layer.cornerRadius = 10.0
        self.SelectedprdtImgVw.layer.masksToBounds = true
        
        self.startAutoScroll()
        
        self.ProductAPI()
    }
    
    func saveProductsToUserDefaults(_ products: [Products]) {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(products) {
                UserDefaults.standard.set(encoded, forKey: "productData")
                print("Data saved to UserDefaults")
            } else {
                print("Failed to encode products")
            }
        }
    
    func ProductAPI()  {
        ViewModel().getdata(geturl: "https://dummyjson.com/products") { (result) in
            switch result{
            case.success(let data):
                self.getAPIdata = data?.products ?? []
                self.saveProductsToUserDefaults(self.getAPIdata)
                DispatchQueue.main.async {
                    self.vendorsCollectionView.reloadData()
                    self.bannerCollectionView.reloadData()
                }
            case.failure(let err as NSError):
                print(err.localizedDescription)
            }
        }
    }
    
    func startAutoScroll() {
        bannerPageController.numberOfPages = 30
        bannerPageController.currentPage = 0
        
        self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(changeimage), userInfo: nil, repeats: false)
        
        DispatchQueue.main.async {
            
            self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.changeimage), userInfo: nil, repeats: true)
            
        }
    }
    
    @objc func changeimage() {
        if counter < 10 {
            let index = IndexPath.init(item: counter, section: 0)
            self.bannerCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            bannerPageController.currentPage = counter
            counter += 1
        } else {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            self.bannerCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            bannerPageController.currentPage = counter
            counter += 1
        }
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.bannerCollectionView {
            let pageWidth = scrollView.frame.width
            let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
            self.bannerPageController.currentPage = currentPage
            self.counter = currentPage
        }
    }
    
    @IBAction func viewCartBtnTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "PostVc") as! PostVc
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func searchBtnTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "SearchVC") as! SearchVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func didAddToCart(name: String, brand: String, imgURL: String) {
        self.cartView.isHidden = false
        self.selectedPrdtTitleLbl.text = name
        self.selectedBrandLbl.text = brand
        if let url = URL(string: imgURL) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.SelectedprdtImgVw.image = image
                    }
                }
            }.resume()
        }
    }
    
    
}
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == OfferCollectionview{
            return 5
        }else if collectionView == bannerCollectionView{
            return getAPIdata.count
        }else{
            return getAPIdata.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == OfferCollectionview{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OfferCollectionCell", for: indexPath) as! OfferCollectionCell
            
            return cell
        }else if collectionView == bannerCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCollectionViewCell", for: indexPath) as! BannerCollectionViewCell
            let imgurl = URL(string: self.getAPIdata[indexPath.item].thumbnail ?? "")
            URLSession.shared.dataTask(with: imgurl!){ mydata, myres, myerr in
                
                if let err = myerr{
                    print(err.localizedDescription)
                }
                
                if let data = mydata{
                    let imgdata = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.bannerImgVw.image = imgdata
                    }
                }
            }.resume()
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VendorsCollectionViewCell", for: indexPath) as! VendorsCollectionViewCell
            
            cell.productTitleLbl.text = self.getAPIdata[indexPath.item].title
            cell.ProductBrand.text = self.getAPIdata[indexPath.item].brand
            cell.productCategory.text = self.getAPIdata[indexPath.item].category
            cell.productDescription.text = self.getAPIdata[indexPath.item].description
            cell.OfferLbl.text = "\(self.getAPIdata[indexPath.item].discountPercentage ?? 0)%"
            
            let imgurl = URL(string: self.getAPIdata[indexPath.item].thumbnail ?? "")
            URLSession.shared.dataTask(with: imgurl!){ mydata, myres, myerr in
                
                if let err = myerr{
                    print(err.localizedDescription)
                }
                
                if let data = mydata{
                    let imgdata = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.prosuctImgVw.image = imgdata
                    }
                }
            }.resume()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == OfferCollectionview{
            let width =  125.0 / 1.0 - 10.0
            let height = 150.0
            return CGSize(width: width, height: height)
        }else if collectionView == bannerCollectionView {
            let size = bannerCollectionView.frame.size
            return CGSize(width: size.width, height: size.height)
        }else{
            let width =  400.0 / 1.0 - 10.0
            let height = 160.0
            return CGSize(width: width, height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == OfferCollectionview{
            return 10.0
        }else if collectionView == bannerCollectionView {
            return 10.0
        }else{
            return 10.0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == OfferCollectionview{
            return 0
        }else if collectionView == bannerCollectionView {
            return 0
        }else{
            return 10.0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == OfferCollectionview{
            return UIEdgeInsets(top: 0, left: 10.0, bottom: 0, right: 10.0)
        }else if collectionView == bannerCollectionView {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }else{
            return UIEdgeInsets(top: 10.0, left: 20.0, bottom: 0, right: 20.0)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == vendorsCollectionView{
            self.passname = "\(self.getAPIdata[indexPath.item].title ?? "")"
            self.passBrand = "\(self.getAPIdata[indexPath.item].brand ?? "")"
            self.passdPrice = Int(self.getAPIdata[indexPath.item].price ?? 0)
            self.passRating = "\(self.getAPIdata[indexPath.item].rating ?? 0)"
            self.passDescription = "\(self.getAPIdata[indexPath.item].description ?? "")"
            self.passStock = "\(self.getAPIdata[indexPath.item].stock ?? 0)"
            self.passImg = self.getAPIdata[indexPath.item].thumbnail ?? ""
            
            let vc = storyboard?.instantiateViewController(identifier: "AddToCartVC") as! AddToCartVC
            vc.recieveName = self.passname
            vc.recieveBrand = self.passBrand
            vc.recievePrice = self.passdPrice
            vc.recieveRating = self.passRating
            vc.recieveDescription = self.passDescription
            vc.recieveStock = self.passStock
            vc.recieveImg = self.passImg
            vc.delegate = self
            
            vc.callBack = { [weak self] data in
                self?.AppTitleLbl.text = data
                
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if collectionView == bannerCollectionView{
            let vc = storyboard?.instantiateViewController(identifier: "PostVc") as! PostVc
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
