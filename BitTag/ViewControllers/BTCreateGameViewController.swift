//
//  BTCreateGameViewController.swift
//  BitTag
//
//  Created by Vasilii Muravev on 1/15/17.
//  Copyright © 2017 SilverLogic, LLC. All rights reserved.
//

import UIKit
import SVProgressHUD

class BTCreateGameViewController: UIViewController {

    @IBOutlet weak var _tableView: UITableView!
    @IBOutlet weak var _startButton: UIButton!
    
    var createdGame: BTGame!
    var participants = [BTParticipant]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadParticipants), name: .ParticipantJoined, object: nil)
        _tableView.dataSource = self
        _tableView.delegate = self
        navigationItem.setHidesBackButton(true, animated: true)
        _startButton.layer.cornerRadius = 20.0
        _tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 57, right: 0.0)
        reloadParticipants()
    }
    
    func reloadParticipants() {
        SVProgressHUD.show()
        ParticipantsManager.shared.loadAvaliableParticipates(gameId: createdGame.gameId, userId: nil, status: nil, success: { (participants: [BTParticipant]) in
            SVProgressHUD.dismiss()
            self.participants = participants.filter({ $0.user.userId != AuthenticationManager.shared.userId })
            self._tableView.reloadData()
        }) { (error: Error?) in
        }
    }
    
    @IBAction func _startButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "BTGameMapViewController") as? BTGameMapViewController else { return }
        controller._gameView = true
        navigationController?.setViewControllers([controller], animated: true)
    }
}


extension BTCreateGameViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return participants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BTInvitedUsersCell! = _tableView.dequeueReusableCell(withIdentifier: "BTInvitedUsersCell") as! BTInvitedUsersCell
        let user = participants[indexPath.row].user
        cell.configureCell(name: "\(user.firstName) \(user.lastName)", imageUrl: user.avatarUrl!)
        cell._paidImageView?.isHidden = participants[indexPath.row].status != "joined"
        return cell
    }
}


extension BTCreateGameViewController: UITableViewDelegate {
    
}
