//
//  BTInvitedUsersCell.swift
//  BitTag
//
//  Created by Vasilii Muravev on 1/15/17.
//  Copyright © 2017 SilverLogic, LLC. All rights reserved.
//

import UIKit

class BTInvitedUsersCell: UITableViewCell {

    @IBOutlet weak var _backgroundView: UIView!
    @IBOutlet weak var _nameLabel: UILabel!
    @IBOutlet weak var _paidImageView: UIImageView!
    @IBOutlet weak var _imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        _backgroundView.layer.cornerRadius = 19.0
        _backgroundView.layer.borderWidth = 0.8
        _backgroundView.layer.borderColor = UIColor.black.cgColor
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

extension BTInvitedUsersCell {
    
    fileprivate func clearCell() {
//        _imageView.image = nil
//        _nameLabel.text = ""
//        _paidImageView.image = nil
    }
}
