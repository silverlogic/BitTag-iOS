//
//  BTFriendsInRangeCollectionViewCell.swift
//  BitTag
//
//  Created by Vasilii Muravev on 1/15/17.
//  Copyright © 2017 SilverLogic, LLC. All rights reserved.
//

import UIKit

class BTFriendsInRangeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var _imageView: UIImageView!
    @IBOutlet weak var bluetoothImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        _imageView.layer.cornerRadius = 45.0
    }
}
