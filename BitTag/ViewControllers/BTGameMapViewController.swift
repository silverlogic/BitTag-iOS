//
//  BTGameMapViewController.swift
//  BitTag
//
//  Created by Vasilii Muravev on 1/14/17.
//  Copyright © 2017 SilverLogic, LLC. All rights reserved.
//

import UIKit
import MapKit
import SVProgressHUD
//import CoreLocation

class BTGameMapViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet fileprivate weak var _gameMapKitView: MKMapView!
    @IBOutlet fileprivate weak var _distanseSlider: UISlider!
    @IBOutlet fileprivate weak var _distanseLabel: UILabel!
    @IBOutlet fileprivate weak var _startButton: UIButton!
    @IBOutlet fileprivate weak var _gameRadiusTitleLabel: UILabel!
    @IBOutlet fileprivate weak var _transparentView: UIView!
    @IBOutlet fileprivate weak var _declineInviteButton: UIButton!
    @IBOutlet fileprivate weak var _acceptInviteButton: UIButton!
    @IBOutlet fileprivate weak var _acceptInviteTopView: UIView!
    @IBOutlet fileprivate weak var _acceptInviteBuyInTitleLabel: UILabel!
    @IBOutlet weak var _acceptInviteBuyInLabel: UILabel!
    @IBOutlet weak var _acceptInviteDurationLabel: UILabel!
    @IBOutlet fileprivate weak var _acceptInviteDurationTitleLabel: UILabel!
    @IBOutlet weak var _collectionView: UICollectionView!
   
    
    // MARK: - Private properties
    fileprivate var _locationManager: CLLocationManager?
    var _gameStartAnnotation: MKPointAnnotation?
    fileprivate var _circleOverlay: MKCircle?
    fileprivate var _currentDistanse: Float = 3.0
    var _acceptingInvitationView: Bool! = false
    var _gameView: Bool! = false
    var _currentGame: BTGame!
    var _participant: BTParticipant?
    var bluetooth: BluetoothDiscover!
    var participants = [BTParticipant]()

    
    // MARK: - IBActions
    @IBAction fileprivate func distanseSliderValueChanged(_ sender: UISlider) {
        _distanseSlider.value = round(_distanseSlider.value / 0.1) * 0.1
        updateDistanseLabel()
        if _currentDistanse != _distanseSlider.value {
            _currentDistanse = _distanseSlider.value
            drawGameArea()
        }
    }
    
    @IBAction fileprivate func startButtonTapped(_ sender: UIButton) {
    }
    @IBAction fileprivate func declineInviteTapped(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    @IBAction fileprivate func acceptInviteTapped(_ sender: UIButton) {
        guard let participant = _participant else { return; }
        ParticipantsManager.shared.participantBuysIn(participant: participant, success: {
            ParticipantsManager.shared.loadAvaliableParticipates(gameId: nil, userId: AuthenticationManager.shared.userId, status: "joined", success: { (participants: [BTParticipant]) in
                APIClient.shared.getGames(success: { (games: [BTGame]) in
                    let game = games.first
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    guard let controller = storyboard.instantiateViewController(withIdentifier: "BTGameMapViewController") as? BTGameMapViewController else { return }
                    controller._gameView = true
                    controller.participants = participants
                    controller._currentGame = game
                    self.navigationController?.setViewControllers([controller], animated: true)
                }, failure: { (error: Error?) in
                    //
                })
            }, failure: { (error: Error?) in
                //
            })

        }) { (error: Error?) in
            DispatchQueue.main.async {
                SVProgressHUD.showError(withStatus: error?.localizedDescription ?? NSLocalizedString("Miscellaneous.UnKnownError", comment: "unknown error"))
                SVProgressHUD.dismiss(withDelay: 2.0)
            }
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateCollectionView), name: .ParticipantTagged, object: nil)
        _collectionView.dataSource = self
        _collectionView.delegate = self
        setupSubviews()
        setupMap()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let inviteFriendsViewController = segue.destination as? BTInviteFriendsViewController else { return }
        inviteFriendsViewController.radius = _currentDistanse
        inviteFriendsViewController.centerPoint = _gameStartAnnotation?.coordinate
    }
    
    func updateCollectionView() {
        ParticipantsManager.shared.loadAvaliableParticipates(gameId: _currentGame.gameId, userId: nil, status: "joined", success: { (participants: [BTParticipant]) in
            self.participants = participants
            self._collectionView.reloadData()
        }) { (error: Error?) in
        }
    }
}


// MARK: - Custom Annotations
class MerchantPointAnnotation: MKPointAnnotation {
}
class GameCenterPointAnnotation: MKPointAnnotation {
}
class BitstopPointAnnotation: MKPointAnnotation {
}
class PlayerPointAnnotation: MKPointAnnotation {
}


// MARK: - Private Instanse Methods
extension BTGameMapViewController {
    
    fileprivate func setupSubviews() {
        _startButton.isEnabled = false
        _distanseSlider.minimumValue = 1.0
        _distanseSlider.maximumValue = 5.0
        _distanseSlider.value = _currentDistanse
        _startButton.layer.cornerRadius = 20.0
        _declineInviteButton.layer.borderColor = _acceptInviteButton.backgroundColor?.cgColor
        _declineInviteButton.layer.borderWidth = 1.0
        _declineInviteButton.layer.cornerRadius = 20.0
        _acceptInviteButton.layer.cornerRadius = 20.0
        
        if _acceptingInvitationView == true {
            navigationItem.title = "Invitation"
            _startButton.isHidden = true
            _distanseLabel.isHidden = true
            _distanseSlider.isHidden = true
            _gameRadiusTitleLabel.isHidden = true
            _transparentView.isHidden = true
            _collectionView.isHidden = true
        } else if _gameView == true {
            navigationItem.title = "New Game"
            _startButton.isHidden = true
            _distanseLabel.isHidden = true
            _distanseSlider.isHidden = true
            _gameRadiusTitleLabel.isHidden = true
            _transparentView.isHidden = true
            _acceptInviteButton.isHidden = true
            _declineInviteButton.isHidden = true
            _acceptInviteTopView.isHidden = true
            _acceptInviteBuyInLabel.isHidden = true
            _acceptInviteDurationLabel.isHidden = true
            _acceptInviteBuyInTitleLabel.isHidden = true
            _acceptInviteDurationTitleLabel.isHidden = true
            let participant = participants.filter({ $0.userId == AuthenticationManager.shared.userId }).first
            bluetooth = BluetoothDiscover(identifier: (participant?.participantId.stringValue)!)
            bluetooth.bluetoothUsersInAppUpdated = {
                self._collectionView.reloadData()
            }
        } else {
            let bittagLogo = UIImageView(image: #imageLiteral(resourceName: "BitTag_Logo_40px_Boxed"))
            navigationItem.titleView = bittagLogo
           
            let qrcodeButton = UIButton(type: .custom)
            qrcodeButton.setImage(#imageLiteral(resourceName: "icon-qrcode"), for: .normal)
            qrcodeButton.frame = CGRect(x: 0.0, y: 0.0, width: 44.0, height: 44.0)
            qrcodeButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: qrcodeButton)
            
            let inviteAcceptButton = UIButton(type: .custom)
            inviteAcceptButton.setImage(#imageLiteral(resourceName: "icon-invitation"), for: .normal)
            inviteAcceptButton.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 32.0)
            inviteAcceptButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)
            inviteAcceptButton.addTarget(self, action: #selector(acceptInvitation), for: .touchUpInside)
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: inviteAcceptButton)
            
            _acceptInviteButton.isHidden = true
            _declineInviteButton.isHidden = true
            _acceptInviteTopView.isHidden = true
            _acceptInviteBuyInLabel.isHidden = true
            _acceptInviteDurationLabel.isHidden = true
            _acceptInviteBuyInTitleLabel.isHidden = true
            _acceptInviteDurationTitleLabel.isHidden = true
            _collectionView.isHidden = true
        }
        updateDistanseLabel()
        drawGameArea()
    }
    
    @objc fileprivate func acceptInvitation() {
        ParticipantsManager.shared.loadAvaliableParticipates(gameId: nil, userId: AuthenticationManager.shared.userId, status: "invited", success: { (participants: [BTParticipant]) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let controller = storyboard.instantiateViewController(withIdentifier: "BTGameMapViewController") as? BTGameMapViewController else { return }
            controller._acceptingInvitationView = true
            controller._gameStartAnnotation = self._gameStartAnnotation
            controller._participant = participants.first
            self.navigationController?.pushViewController(controller, animated: true)
        }) { (error: Error?) in
            //
        }
    }
    
    fileprivate func setupMap() {
        // @TODO: possible add spinner to map before finding current location
        _gameMapKitView.delegate = self
        _gameMapKitView.showsUserLocation = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(gameCenterSelected(gestureReconizer:)))
        _gameMapKitView.addGestureRecognizer(gestureRecognizer)
        _locationManager = CLLocationManager()
        _locationManager!.delegate = self
        _locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined,
             .restricted,
             .denied:
            _locationManager!.requestWhenInUseAuthorization()
        case .authorizedAlways,
             .authorizedWhenInUse:
            _locationManager!.startUpdatingLocation()
        }
        addMerchantAnnotationFor(CLLocationCoordinate2D(latitude: 25.826325437799071, longitude: -80.220489815406211))
        addMerchantAnnotationFor(CLLocationCoordinate2D(latitude: 25.799740823988586, longitude: -80.222521063622523))
        addBitstopAnnotationFor(CLLocationCoordinate2D(latitude: 25.780466778700458, longitude: -80.215333565119835))
    }
    
    fileprivate func updateDistanseLabel() {
        _distanseLabel.text = String(format: "%.2fmi", _distanseSlider.value)
    }
    
    @objc fileprivate func gameCenterSelected(gestureReconizer: UITapGestureRecognizer) {
        if _acceptingInvitationView == true {
            return
        }
        if _gameView == true {
            // @TODO: Here we should tap on user icon to tag him
            return
        }
        let point = gestureReconizer.location(in: _gameMapKitView)
        let location = _gameMapKitView.convert(point, toCoordinateFrom: _gameMapKitView)
        guard let _ = _gameStartAnnotation else {
            _gameStartAnnotation = GameCenterPointAnnotation()
            _gameStartAnnotation!.coordinate = location
            _gameMapKitView.addAnnotation(_gameStartAnnotation!)
            drawGameArea()
            return
        }
        _gameStartAnnotation!.coordinate = location
        drawGameArea()
    }
    
    fileprivate func drawGameArea() {
        guard let _ = _gameStartAnnotation as MKAnnotation! else { return }
        if let overlay = _circleOverlay {
            _gameMapKitView.remove(overlay)
            _circleOverlay = nil
        }
        let radius = CLLocationDistance(_distanseSlider.value * 1609.344) // 1 Mile == 1609.344 Meters
        let circle = MKCircle(center: _gameStartAnnotation!.coordinate, radius: radius)
        _gameMapKitView.add(circle)
        _circleOverlay = circle
        _startButton.isEnabled = true
    }
    
    fileprivate func addMerchantAnnotationFor(_ location:CLLocationCoordinate2D) {
        let annotation = MerchantPointAnnotation()
        annotation.coordinate = location
        _gameMapKitView.addAnnotation(annotation)
    }
    
    fileprivate func addBitstopAnnotationFor(_ location:CLLocationCoordinate2D) {
        let annotation = BitstopPointAnnotation()
        annotation.coordinate = location
        _gameMapKitView.addAnnotation(annotation)
    }
    
    fileprivate func addPlayerAnnotation(_ location:CLLocationCoordinate2D) {
        let annotation = PlayerPointAnnotation()
        annotation.coordinate = location
        _gameMapKitView.addAnnotation(annotation)
    }
    
    fileprivate func resizedPinIcon(_ image: UIImage) -> UIImage? {
        let size = CGSize(width: 100.0, height: 100.0)
        UIGraphicsBeginImageContext(size)
        image.draw(in: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
}


// MARK: - MKMapViewDelegate
extension BTGameMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let rendererView = MKCircleRenderer(overlay: overlay)
        rendererView.fillColor = _startButton.backgroundColor
        rendererView.strokeColor = _startButton.backgroundColor
        rendererView.alpha = 0.2
        return rendererView
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MerchantPointAnnotation {
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "merchantAnnotation")
            annotationView.image = resizedPinIcon(#imageLiteral(resourceName: "pin-merchant"))
            return annotationView
        } else if annotation is GameCenterPointAnnotation {
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "gameCenterAnnotation")
            annotationView.image = resizedPinIcon(#imageLiteral(resourceName: "pin-gamecenter"))
            return annotationView
        } else if annotation is BitstopPointAnnotation {
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "bitstopAnnotation")
            annotationView.image = resizedPinIcon(#imageLiteral(resourceName: "pin-bitstop"))
            return annotationView
        } else if annotation is PlayerPointAnnotation {
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "playerAnnotation")
            annotationView.image = resizedPinIcon(#imageLiteral(resourceName: "pin-gamecenter"))
            return annotationView
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }
        if annotation is PlayerPointAnnotation {
            performSegue(withIdentifier: "gotoTagViewController", sender: self)
        }
    }
}


// MARK: - CLLocationManagerDelegate
extension BTGameMapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last as CLLocation! else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        _gameMapKitView.setRegion(region, animated: true)
        _locationManager?.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined,
             .restricted,
             .denied:
            break // access denied
        case .authorizedAlways,
             .authorizedWhenInUse:
            _locationManager!.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to initialize GPS: ", error.localizedDescription)
    }
}


// MARK: - UICollectionViewDelegate
extension BTGameMapViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let participant = participants[indexPath.item]
        APIClient.shared.postParticipantGettingTagged(participant: participant, success: { 
            
        }) { (error: Error?) in
            
        }
    }
}


// MARK: - UICollectionViewDataSource
extension BTGameMapViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return participants.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = _collectionView.dequeueReusableCell(withReuseIdentifier: "BTFriendsInRangeCollectionViewCell", for: indexPath) as? BTFriendsInRangeCollectionViewCell else {
            return UICollectionViewCell()
        }
        let username = bluetooth.inAppBluetoothUserWithIndex(indexPath.item)
        cell.bluetoothImage.isHidden = participants.contains(where: { $0.participantId.stringValue != username })
        return cell
    }
}

