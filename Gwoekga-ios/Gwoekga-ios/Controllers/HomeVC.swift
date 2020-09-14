//
//  ViewController.swift
//  Gwoekga-ios
//
//  Created by 강민채 on 2020/08/31.
//  Copyright © 2020 minchae. All rights reserved.
//

import UIKit
import Cosmos
import Toast_Swift

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    //TODO: - 현재 로드된 정보 이후로 upload된 정보들 server에 요청해 가져오기

    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var timeLineTableView: UITableView!
    @IBOutlet weak var noLoadedDataView: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
//    var test = ["test","test2","test3"]
    var showReviews = [Review]() //표시할 게시물을 담는 배열
    var loadedReviews = [Review]() //로드된 게시물

    var fromMainVeiw = 0 //mainVeiw가 아닌 곳에서 enter 햇을 때 db에 업로드된 사항이 잇다면 새로고침 권유하기
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("HomeVC -> viewDidLoad()")
        postBtn.layer.cornerRadius = postBtn.frame.height / 2
        timeLineTableView.delegate = self
        timeLineTableView.dataSource = self
        
        timeLineTableView.refreshControl  = UIRefreshControl()
        timeLineTableView.refreshControl?.addTarget(self,action: #selector(pullToRefresh),for: .valueChanged)
    }
    
    //MARK: - get data from server
    func loadNewPost(){
        print("HomeVC -> loadNewPost()")
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
    
    func loadPastPost(){
        //밑으로 내릴 경우 더 밑에 위치한 정보 불러오기
        print("HomeVC -> loadPastPost()")
        let lastTime = showReviews[showReviews.count - 1].postTime
        let firstIndex = lastTime.index(lastTime.startIndex, offsetBy: 0)
        let lastIndex = lastTime.index(lastTime.endIndex, offsetBy: -10)
        let dateString = lastTime[firstIndex..<lastIndex]
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        guard let date = formatter.date(from: String(dateString)) else {return}
        formatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
        let stringDate = formatter.string(from: date)
//        let date = "2017-04-08 08:03:30 +0000"
//        let test = formatter.date(from: date)
        
        print("original String with date: \(lastTime) , \(dateString)")
        print("change String with date: \(stringDate)")

        
        let semaphore = DispatchSemaphore(value: 0)
        let loadingQueue = DispatchQueue.global()

        loadingQueue.async {
            PostManager.shared.getPost(time: stringDate, completion: {[weak self] result in
                guard let self = self else {return}

                switch result{
                    case .success(let reviews):
                        self.loadedReviews = reviews
                        self.showReviews += self.loadedReviews
                case .failure(_):
                        self.view.makeToast("더이상 불러올 게시글이 없습니다😳",duration: 1.0,position: .bottom)
                    }
                semaphore.signal()
            })
        }
        semaphore.wait(timeout: .now() + 5)
        DispatchQueue.main.async {
            //ui와 관련된 사항은 main thread에서 진행되어야 함
            self.loadingIndicator.isHidden = true
            self.timeLineTableView.reloadData()
        }
    }
    
    //MARK: - @objc
    @objc func pullToRefresh(_ sender: Any) {
        // 새로고침 시 갱신되어야할 내용
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
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //row마다 표시될 cell
//        print("HomeVC -> make tableViewCell")
        let cell = timeLineTableView.dequeueReusableCell(withIdentifier: "InitCell", for: indexPath) as! TimeLineCell
        let review = showReviews[indexPath.row]
        cell.textLabel?.text = String(indexPath.row)
        cell.titleLabel.text = review.title
        cell.reveiwTextView.text = review.written
        cell.categoryGenreLabel.text = review.category + " | " + review.genres
        cell.starRate.rating = Double(review.star)
        
        return cell
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height

        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 {
            print("end of scroll")
            DispatchQueue.main.async {
                self.loadingIndicator.isHidden = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                self.loadPastPost()
            })
        }
    }
}

