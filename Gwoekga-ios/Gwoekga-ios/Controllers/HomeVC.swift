//
//  ViewController.swift
//  Gwoekga-ios
//
//  Created by 강민채 on 2020/08/31.
//  Copyright © 2020 minchae. All rights reserved.
//

import UIKit
import Cosmos

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    //TODO: - 현재 로드된 정보 이후로 upload된 정보들 server에 요청해 가져오기

    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var timeLineTableView: UITableView!
    @IBOutlet weak var noLoadedDataView: UIView!
    
//    var test = ["test","test2","test3"]
    var showReviews = [Review]() //표시할 게시물을 담는 배열
    var loadedReviews = [Review]() //로드된 게시물

    var fromMainVeiw = 0 //mainVeiw가 아닌 곳에서 enter 햇을 때 db에 업로드된 사항이 잇다면 새로고침 권유하기
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("HomeVC -> viewDidLoad()")
        print("test value \(showReviews)")
        postBtn.layer.cornerRadius = postBtn.frame.height / 2
        timeLineTableView.delegate = self
        timeLineTableView.dataSource = self
        
        timeLineTableView.refreshControl  = UIRefreshControl()
        timeLineTableView.refreshControl?.addTarget(self,action: #selector(pullToRefresh),for: .valueChanged)
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        print("HomeVC -> veiwDidAppear()")
////        loadPost()
////        loadingView.isHidden = true
//    }
//    
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        print("HomeVC -> viewWillDisappear()")
//        self.loadingView.isHidden = false
//        self.showReviews = []
//    }
    
    //MARK: - get data from server
    func loadNewPost(){
        print("HomeVC -> loadNewData")
//        현재 로드된 것 이후에 업로드 된 정보 불러오기
//        PostManager.shared.getPost(completion: {[weak self] result in
//            guard let self = self else {return}
//
//            switch result{
//            case .success(let reviews):
//                //배열은 시간순으로 되어있으므로 뒤집기
//                self.loadedReviews = reviews.reversed()
//            case .failure(let error):
//                print(error)
//            }
//        })
        
    }
    
    func loadPost(){
        //처음 화면이 로드될 때 불러와있을 정보들 -> 올라가있는 정보들 중 한 10개 정도만,,,?(최근 것부터~)
             PostManager.shared.getPost(completion: {[weak self] result in
                       guard let self = self else {return}
                       
                       switch result{
                       case .success(let reviews):
                           //배열은 시간순으로 되어있으므로 뒤집기
                           self.loadedReviews = reviews.reversed()
                           self.showReviews = Array(self.loadedReviews.prefix(10))
                       case .failure(let error):
                        print(error)
                        self.noLoadedDataView.isHidden = false
                       }
        })
        
    }
    
    func loadPastPost(){
        //밑으로 내릴 경우 더 밑에 위치한 정보 불러오기
    }
    
    //MARK: - @objc
    @objc func pullToRefresh(_ sender: Any) {
        // 새로고침 시 갱신 되어야할 내용
        print("HomeVC -> pullToRefresh()")
        loadNewPost()
        showReviews += self.loadedReviews
        timeLineTableView.reloadData()
        
        // 당겨서 새로고침 종료
        timeLineTableView.refreshControl?.endRefreshing()
    }
    
    //MARK: - UITableViewDataSource Method
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //row의 개수
        return showReviews.count
//    return test.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //row마다 표시될 cell
        print("HomeVC -> make tableViewCell")
        let cell = timeLineTableView.dequeueReusableCell(withIdentifier: "InitCell", for: indexPath) as! TimeLineCell
        let review = showReviews[indexPath.row]
        cell.textLabel?.text = String(indexPath.row)
        cell.titleLabel.text = review.title
        cell.reveiwTextView.text = review.written
        cell.categoryGenreLabel.text = review.category + " | " + review.genres
        cell.starRate.rating = Double(review.star)
        
        return cell
    }

}

