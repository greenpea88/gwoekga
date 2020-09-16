//
//  SimpleInfoCell.swift
//  Gwoekga-ios
//
//  Created by 강민채 on 2020/09/11.
//  Copyright © 2020 minchae. All rights reserved.
//

import UIKit
import Cosmos

class SimpleInfoCell: UITableViewCell {
    
    @IBOutlet weak var userProfileImg: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var reviewTitleLabel: UILabel!
    @IBOutlet weak var categoryGenreLabel: UILabel!
    @IBOutlet weak var starRating: CosmosView!
}
