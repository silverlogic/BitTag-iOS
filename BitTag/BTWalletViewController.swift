//
//  BTWalletViewController.swift
//  BitTag
//
//  Created by Vasilii Muravev on 1/15/17.
//  Copyright © 2017 SilverLogic, LLC. All rights reserved.
//

import UIKit

class BTWalletViewController: UIViewController {

    @IBOutlet weak var _copyAddressButton: UIButton!
    @IBOutlet weak var _doneButton: UIButton!
    @IBOutlet weak var _imageView: UIImageView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        _copyAddressButton.layer.cornerRadius = 18.0
        _doneButton.layer.cornerRadius = 18.0
        _doneButton.layer.borderColor = _copyAddressButton.backgroundColor?.cgColor
        _doneButton.layer.borderWidth = 0.8
//        _imageView.image = nil
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
