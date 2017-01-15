//
//  BTInviteFriendsCell.swift
//  BitTag
//
//  Created by Vasilii Muravev on 1/14/17.
//  Copyright © 2017 SilverLogic, LLC. All rights reserved.
//

import UIKit
import YYWebImage

class BTInviteFriendsCell: UITableViewCell {

    @IBOutlet fileprivate weak var _imageView: UIImageView!
    @IBOutlet fileprivate weak var _nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        _imageView.layer.cornerRadius = 28.0
        _imageView.layer.borderColor = UIColor.black.cgColor
        _imageView.layer.borderWidth = 0.8
        _nameLabel.layer.cornerRadius = 20.0
        _nameLabel.layer.borderColor = UIColor.black.cgColor
        _nameLabel.layer.borderWidth = 0.8
        clearCell()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        clearCell()
    }

}

// MARK: - Private
extension BTInviteFriendsCell {
    
    fileprivate func clearCell() {
        accessoryType = .none
        _nameLabel.text = ""
        _imageView.image = #imageLiteral(resourceName: "BitTag_Logo")
    }
}

// MARK: - Public
extension BTInviteFriendsCell {
    func configureCell(name: String, imageUrl: NSURL) {
        _nameLabel.text = name
        _imageView.yy_setImage(with: imageUrl as URL, placeholder: #imageLiteral(resourceName: "BitTag_Logo"), options: [.progressiveBlur, .setImageWithFadeAnimation], completion: nil)
    }
}
