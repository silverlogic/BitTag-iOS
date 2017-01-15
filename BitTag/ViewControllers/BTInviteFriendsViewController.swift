//
//  BTInviteFriendsViewController.swift
//  BitTag
//
//  Created by Vasilii Muravev on 1/14/17.
//  Copyright © 2017 SilverLogic, LLC. All rights reserved.
//

import UIKit

class BTInviteFriendsViewController: UIViewController {

    @IBOutlet fileprivate weak var _tableView: UITableView!
    @IBOutlet fileprivate weak var _createButton: UIButton!
    @IBOutlet fileprivate weak var _durationSlider: UISlider!
    @IBOutlet fileprivate weak var _durationLabel: UILabel!
    @IBOutlet fileprivate weak var _buyInTextField: UITextField!
    
    fileprivate var _currentBuyIn: Int? = 10
    
    fileprivate var _selectedIndexPaths: [IndexPath]?
    
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
    }
    
    @IBAction func durationSliderValueChanged(_ sender: UISlider) {
        _durationSlider.value = round(_durationSlider.value)
        updateDurationLabel()
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
            _currentBuyIn = Int(_buyInTextField.text!)
        }
        updateBuyInTextField()
    }
    
    @objc fileprivate func cancelBuyInTextFieldTapped() {
        _buyInTextField.endEditing(true)
        updateBuyInTextField()
    }
    
    fileprivate func updateBuyInTextField() {
        _buyInTextField.text = String(describing: _currentBuyIn!)
    }
}

extension BTInviteFriendsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BTInviteFriendsCell! = _tableView.dequeueReusableCell(withIdentifier: "BTInviteFriendsCell") as! BTInviteFriendsCell
        if let _ = _selectedIndexPaths?.index(of: indexPath) {
            cell.accessoryType = .checkmark
        }
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
