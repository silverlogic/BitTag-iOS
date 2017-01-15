//
//  BTInviteFriendsViewController.swift
//  BitTag
//
//  Created by Vasilii Muravev on 1/14/17.
//  Copyright © 2017 SilverLogic, LLC. All rights reserved.
//

import UIKit
import SVProgressHUD

class BTInviteFriendsViewController: UIViewController {

    @IBOutlet fileprivate weak var _tableView: UITableView!
    @IBOutlet fileprivate weak var _createButton: UIButton!
    @IBOutlet fileprivate weak var _durationSlider: UISlider!
    @IBOutlet fileprivate weak var _durationLabel: UILabel!
    @IBOutlet fileprivate weak var _buyInTextField: UITextField!
    
    fileprivate var _currentBuyIn: Float = 1000.0 / 1000000.0
    
    fileprivate var _selectedIndexPaths: [IndexPath]?
    var centerPoint: CLLocationCoordinate2D!
    var radius: Float!
    var duration: Float = 3.0
    var users = [BTUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _selectedIndexPaths = [IndexPath]()
        _createButton.layer.cornerRadius = 20.0
        _tableView.contentInset = UIEdgeInsets(top: 46.0, left: 0.0, bottom: 117.0, right: 0.0)
        _durationSlider.value = 3.0
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = _createButton.backgroundColor
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneBuyInTextFieldTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelBuyInTextFieldTapped))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        _buyInTextField.inputAccessoryView = toolBar
        
        updateBuyInTextField()
        updateDurationLabel()
        updateCreateButton()
        _tableView.dataSource = self
        _tableView.delegate = self
        SVProgressHUD.show()
        DispatchQueue.global(qos: .default).async {
            APIClient.shared.getUsers(success: { (users: [BTUser]) in
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    self.users = users.filter({ $0.userId != AuthenticationManager.shared.userId })
                    self._tableView.reloadData()
                }
            }, failure: { (error: Error?) in
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    _ = self.navigationController?.popViewController(animated: true)
                }
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let newgamecontroller = segue.destination as? BTCreateGameViewController,
            let createdGame = sender as? BTGame else { return }
        newgamecontroller.createdGame = createdGame
        
    }
    
    @IBAction func durationSliderValueChanged(_ sender: UISlider) {
        _durationSlider.value = round(_durationSlider.value)
        duration = _durationSlider.value
        updateDurationLabel()
    }
    
    @IBAction func invitebuttontapped() {
        let newGame = BTGame()
        newGame.coordinates = [NSNumber(value:centerPoint.latitude), NSNumber(value: centerPoint.longitude)]
        newGame.centerPointType = "Point"
        newGame.radius = radius as NSNumber
        newGame.buyin = "\(_currentBuyIn)" as NSString
        SVProgressHUD.show()
        APIClient.shared.postGame(newGame, success: { (createdGame: BTGame) in
            let dispatchQueue = DispatchQueue(label: "create participants", qos: .default, attributes: .concurrent)
            let dispatchGroup = DispatchGroup()
            self._selectedIndexPaths?.forEach({ (indexPath) in
                dispatchGroup.enter()
                dispatchQueue.async(group: dispatchGroup, execute: {
                    ParticipantsManager.shared.participantJoinGame(gameId: createdGame.gameId, userId: self.users[indexPath.row].userId, success: { (participate: BTParticipant) in
                        dispatchGroup.leave()
                    }, failure: { (error: Error?) in
                        dispatchGroup.leave()
                    })
                })
            })
            dispatchGroup.notify(queue: DispatchQueue.main, execute: {
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToNewGame", sender: createdGame)
            })
        }) { (error: Error?) in
            SVProgressHUD.dismiss()
        }
    }
}

extension BTInviteFriendsViewController {
    
    fileprivate func updateDurationLabel() {
        _durationLabel.text = String(format: "%dhr", Int(_durationSlider.value))
    }
    
    fileprivate func updateCreateButton() {
        if _selectedIndexPaths?.count == 0 {
            _createButton.isEnabled = false
            return
        }
        _createButton.isEnabled = true
    }
    
    @objc fileprivate func doneBuyInTextFieldTapped() {
        _buyInTextField.endEditing(true)
        if _buyInTextField.text?.isEmpty != true {
            _currentBuyIn = Float(_buyInTextField.text!)! / Float(1000000.0)
        }
    }
    
    @objc fileprivate func cancelBuyInTextFieldTapped() {
        _buyInTextField.endEditing(true)
    }
    
    fileprivate func updateBuyInTextField() {
        _buyInTextField.text = "1000"
    }
}

extension BTInviteFriendsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BTInviteFriendsCell! = _tableView.dequeueReusableCell(withIdentifier: "BTInviteFriendsCell") as! BTInviteFriendsCell
        if let _ = _selectedIndexPaths?.index(of: indexPath) {
            cell.accessoryType = .checkmark
        }
        let user = users[indexPath.row]
        cell.configureCell(name: "\(user.firstName) \(user.lastName)", imageUrl: user.avatarUrl!)
        return cell
    }
}


extension BTInviteFriendsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let cell = _tableView.cellForRow(at: indexPath) else { return nil }
        if let index = _selectedIndexPaths?.index(of: indexPath) {
            _selectedIndexPaths?.remove(at: index)
            cell.accessoryType = .none
            updateCreateButton()
            return nil
        }
        _selectedIndexPaths?.append(indexPath)
        cell.accessoryType = .checkmark
        updateCreateButton()
        return nil
    }
}
