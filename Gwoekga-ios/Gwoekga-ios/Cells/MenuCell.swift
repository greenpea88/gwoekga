//
//  MenuCell.swift
//  Gwoekga-ios
//
//  Created by 강민채 on 2020/09/11.
//  Copyright © 2020 minchae. All rights reserved.
//

import UIKit

class MenuCell: UICollectionViewCell{
    
    @IBOutlet weak var menuTitleLabel: UILabel!
    
    override var isSelected: Bool {
        didSet{
            menuTitleLabel.alpha = isSelected ? 1.0: 0.6
        }
    }
}
