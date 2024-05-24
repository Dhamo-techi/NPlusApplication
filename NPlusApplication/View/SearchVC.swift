//
//  SearchVC.swift
//  NPlusApplication
//
//  Created by MAC PRO on 23/05/24.
//

import UIKit

class SearchVC: UIViewController {
    
    var passname = String()
    var passBrand = String()
    var passdPrice = Int()
    var passRating = String()
    var passDescription = String()
    var passStock = String()
    var passImg = String()
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var searchTxtFld: UITextField!
    
    @IBOutlet weak var searchResultView: UIView!
    
    @IBOutlet weak var searchTableview: UITableView!
    
    var filteredProducts: [Products] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backBtn.layer.cornerRadius = 10.0
        
        let searchPaddingview = UIView(frame: CGRect(x: 0, y: 20, width: 25, height: 63))
        self.searchTxtFld.leftView = searchPaddingview
        self.searchTxtFld.leftViewMode = .always
        self.searchTxtFld.layer.cornerRadius = 20.0
        self.searchTxtFld.layer.borderWidth = 2.0
        self.searchTxtFld.layer.borderColor = UIColor.lightGray.cgColor
        
        self.searchTableview.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
        
        self.searchTableview.delegate = self
        self.searchTableview.dataSource = self
        
        self.searchTxtFld.delegate = self
        
        self.searchResultView.isHidden = true
        
        if let initialData = getuserDefaults() {
                    print("Loaded initial data: \(initialData.count) products")
                } else {
                    print("No data found in UserDefaults")
                }
        
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getuserDefaults()-> [Products]?{
        if let savedata = UserDefaults.standard.data(forKey: "productData"){
            let decoder = JSONDecoder()
            if let loadedProducts = try? decoder.decode([Products].self, from: savedata){
                return loadedProducts
            }
        }
        return nil
    }
    
    func filterProducts(for searchText: String) {
            filteredProducts = getuserDefaults()?.filter { product in
                return product.title!.lowercased().contains(searchText.lowercased())
            } ?? []
            self.searchTableview.reloadData()
        }
    
}

extension SearchVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        
        let  product = filteredProducts[indexPath.row]
                
                cell.SearchPrdtTitleLbl.text = product.title
                cell.SearchBrandNameLbl.text = product.brand
                
                if let thumbnailURL = URL(string: product.thumbnail ?? "") {
                    URLSession.shared.dataTask(with: thumbnailURL) { data, response, error in
                        if let data = data, let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                cell.SearchbrandImg.image = image
                            }
                        }
                    }.resume()
                }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        self.passname = "\(self.filteredProducts[indexPath.item].title ?? "")"
        self.passBrand = "\(self.filteredProducts[indexPath.item].brand ?? "")"
        self.passdPrice = Int(self.filteredProducts[indexPath.item].price ?? 0)
        self.passRating = "\(self.filteredProducts[indexPath.item].rating ?? 0)"
        self.passDescription = "\(self.filteredProducts[indexPath.item].description ?? "")"
        self.passStock = "\(self.filteredProducts[indexPath.item].stock ?? 0)"
        self.passImg = self.filteredProducts[indexPath.item].thumbnail ?? ""
        
        let vc = storyboard?.instantiateViewController(identifier: "AddToCartVC") as! AddToCartVC
        vc.recieveName = self.passname
        vc.recieveBrand = self.passBrand
        vc.recievePrice = self.passdPrice
        vc.recieveRating = self.passRating
        vc.recieveDescription = self.passDescription
        vc.recieveStock = self.passStock
        vc.recieveImg = self.passImg
    
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            self.searchResultView.isHidden = updatedText.isEmpty
            filterProducts(for: updatedText)
            
            return true
        }
}
