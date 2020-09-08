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
    

    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var timeLineTableView: UITableView!
    
    var test = ["test"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        postBtn.layer.cornerRadius = postBtn.frame.height / 2
        timeLineTableView.delegate = self
        timeLineTableView.dataSource = self
    }

    //MARK: - UITableViewDataSource Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //row의 개수
        return test.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //row마다 표시될 cell
        let cell = timeLineTableView.dequeueReusableCell(withIdentifier: "InitCell", for: indexPath)
        cell.textLabel?.text = test[indexPath.row]
        return cell
    }

}

