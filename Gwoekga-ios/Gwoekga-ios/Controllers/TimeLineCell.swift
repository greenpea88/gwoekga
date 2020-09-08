//
//  TimeLineCell.swift
//  Gwoekga-ios
//
//  Created by 강민채 on 2020/09/08.
//  Copyright © 2020 minchae. All rights reserved.
//

import UIKit
import Cosmos

class TimeLineCell: UITableViewCell{
    
    
    @IBOutlet weak var posterImgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryGenreLabel: UILabel!
    @IBOutlet weak var starRate: CosmosView!
    @IBOutlet weak var reveiwTextView: UILabel!
    
    var review: Review?{
        didSet{
            if let review = review{
//                posterImgView = review.
                titleLabel.text = review.title
                categoryGenreLabel.text = review.category
                reveiwTextView.text = review.written
            }
        }
    }
}
