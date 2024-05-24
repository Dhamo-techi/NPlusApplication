//
//  CartVc.swift
//  NPlusApplication
//
//  Created by MAC PRO on 22/05/24.
//

import UIKit

class PostVc: UIViewController {
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var postCollectionVw: UICollectionView!
    
    var posts: [Posts] = []
    var currentPage = 10
    let limit = 5
    var isFetching = false
    
    private let apiService = APIService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.backBtn.layer.cornerRadius = 10.0
        
        self.postCollectionVw.register(UINib(nibName: "PostsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PostsCollectionViewCell")
        
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .vertical
        self.postCollectionVw.collectionViewLayout = flowlayout
                
        self.fetchPostsdata(page: currentPage)
        
    }
    
    func fetchPostsdata(page: Int) {
        guard !isFetching else { return }
        isFetching = true
        
        apiService.fetchPosts(page: page, limit: limit) { [weak self] result in
            guard let self = self else { return }
            self.isFetching = false
            
            switch result {
            case .success(let postModel):
                if let newPosts = postModel.posts {
                    self.posts.append(contentsOf: newPosts)
                    print(self.posts)
                    DispatchQueue.main.async {
                        self.postCollectionVw.reloadData()
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func backbtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension PostVc: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostsCollectionViewCell", for: indexPath) as! PostsCollectionViewCell
        let getdata = posts[indexPath.item]
        cell.TitleLbl.text = getdata.title
        cell.StoryLbl.text = getdata.body
        cell.userIdLbl.text = "UserID: \(getdata.userId ?? 0)"
        
        if let tags = getdata.tags {
            for (index, tag) in tags.prefix(3).enumerated() {
                switch index {
                case 0:
                    cell.tag1Lbl.text = tag
                case 1:
                    cell.tag2Lbl.text = tag
                case 2:
                    cell.tag3Lbl.text = tag
                default:
                    break
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width =  (collectionView.bounds.width - 1.0 * 10.0) / 1.0
        let height = CGFloat(360.0)
        return  CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == posts.count - 1 {
            currentPage += 1
            fetchPostsdata(page: currentPage)
        }
    }
}
