//
//  BTVictoryTableViewCell.swift
//  BitTag
//
//  Created by Vasilii Muravev on 1/15/17.
//  Copyright © 2017 SilverLogic, LLC. All rights reserved.
//

import UIKit

class BTVictoryTableViewCell: UITableViewCell {

    @IBOutlet weak var _backgroundView: UIView!
    @IBOutlet weak var _imageView: UIImageView!
    @IBOutlet weak var _nameLabel: UILabel!
    @IBOutlet weak var _bitcoinImageView: UIImageView!
    @IBOutlet weak var _plateLabel: UILabel!
    @IBOutlet weak var _winAmountLabel: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        _backgroundView.layer.cornerRadius = 19.0
        _backgroundView.layer.borderColor = UIColor.black.cgColor
        _backgroundView.layer.borderWidth = 0.8
        _imageView.layer.cornerRadius = 30.0
        _imageView.layer.borderWidth = 0.8
        _imageView.layer.borderColor = UIColor.black.cgColor
        clearCell()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        clearCell()
    }
}

extension BTVictoryTableViewCell {
    
    fileprivate func clearCell() {
//        _imageView.image = nil
//        _plateLabel.text = ""
//        _winAmountLabel.text = ""
//        _nameLabel.text = ""
    }
}
