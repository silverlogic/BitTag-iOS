//
//  BTCreateGameViewController.swift
//  BitTag
//
//  Created by Vasilii Muravev on 1/15/17.
//  Copyright © 2017 SilverLogic, LLC. All rights reserved.
//

import UIKit

class BTCreateGameViewController: UIViewController {

    @IBOutlet weak var _tableView: UITableView!
    @IBOutlet weak var _startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _startButton.layer.cornerRadius = 20.0
        _tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 57, right: 0.0)
    }
    
    @IBAction func _startButtonTapped(_ sender: Any) {
    }
}


extension BTCreateGameViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BTInvitedUsersCell! = _tableView.dequeueReusableCell(withIdentifier: "BTInvitedUsersCell") as! BTInvitedUsersCell
        return cell
    }
}


extension BTCreateGameViewController: UITableViewDelegate {
    
}
