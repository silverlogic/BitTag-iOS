//
//  BTVictoryViewController.swift
//  BitTag
//
//  Created by Vasilii Muravev on 1/15/17.
//  Copyright © 2017 SilverLogic, LLC. All rights reserved.
//

import UIKit

class BTVictoryViewController: UIViewController {

    @IBOutlet weak var _tableView: UITableView!
}

extension BTVictoryViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BTVictoryTableViewCell! = _tableView.dequeueReusableCell(withIdentifier: "BTVictoryTableViewCell") as! BTVictoryTableViewCell
        return cell
    }
}
