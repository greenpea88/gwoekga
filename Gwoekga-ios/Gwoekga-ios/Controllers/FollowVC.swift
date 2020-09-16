//
//  FollowVC.swift
//  Gwoekga-ios
//
//  Created by 강민채 on 2020/09/11.
//  Copyright © 2020 minchae. All rights reserved.
//

import UIKit

class FollowVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var topMenuBar: UICollectionView!
    @IBOutlet weak var userListTableView: UITableView!
    
    
//    var followingOrFollower = [[String]()]
    var followingOrFollower = [["following 목록","1","2","3"], ["follower 목록","1","2","3"]]
    
    var menuTitles = ["Following","Follower"]
    var selectedIndex = 0
    var selectedIdxPath = IndexPath(item: 0, section: 0)
    var selectedArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topMenuBar.delegate = self
        topMenuBar.dataSource = self
        
        userListTableView.delegate = self
        userListTableView.dataSource = self
        
        selectedArray = followingOrFollower[selectedIndex]
        topMenuBar.selectItem(at: selectedIdxPath, animated: false, scrollPosition: .centeredVertically)
        
        let swipeLeft: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
        let swipeRight: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
        
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    func refreshView(){
        selectedArray = followingOrFollower[selectedIndex]
        userListTableView.reloadData()
    }
    
    //MARK: - objc
    @objc func swipeAction(_ sender:UISwipeGestureRecognizer){
        print("FollowVC -> swipeAction()")
        if (sender.direction == .left){
            if (selectedIndex < menuTitles.count - 1){
                selectedIndex += 1
            }
        }
        else{
            if (selectedIndex > 0){
                selectedIndex -= 1
            }
        }
        
        selectedIdxPath = IndexPath(item: selectedIndex, section: 0)
        topMenuBar.selectItem(at: selectedIdxPath, animated: true, scrollPosition: .centeredVertically)
        refreshView()
    }
    
    //MARK: - IBAction Method
    @IBAction func onBackBtnClicked(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - UICollectionViewDataSource Method
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        print("FollowVC -> make cells")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath) as! MenuCell
        cell.menuTitleLabel.text = menuTitles[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print(collectionView.bounds.width)
        return CGSize(width: collectionView.bounds.width / CGFloat(menuTitles.count), height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        refreshView()
    }
    
    //MARK: - UITableViewDataSource Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userListTableView.dequeueReusableCell(withIdentifier: "FollowCell", for: indexPath) as! FollowUserCell
        cell.userNameLabel.text = selectedArray[indexPath.row]
        return cell
    }
}
