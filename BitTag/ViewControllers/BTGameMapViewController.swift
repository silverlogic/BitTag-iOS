//
//  BTGameMapViewController.swift
//  BitTag
//
//  Created by Vasilii Muravev on 1/14/17.
//  Copyright © 2017 SilverLogic, LLC. All rights reserved.
//

import UIKit
import MapKit
//import CoreLocation

class BTGameMapViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet fileprivate weak var _gameMapKitView: MKMapView!
    @IBOutlet fileprivate weak var _distanseSlider: UISlider!
    @IBOutlet fileprivate weak var _distanseLabel: UILabel!
    @IBOutlet fileprivate weak var _startButton: UIButton!
   
    
    // MARK: - Private properties
    fileprivate var _locationManager: CLLocationManager?
    fileprivate var _gameStartAnnotation: MKPointAnnotation?
    fileprivate var _circleOverlay: MKCircle?
    fileprivate var _currentDistanse: Float = 3.0

    
    // MARK: - IBActions
    @IBAction fileprivate func distanseSliderValueChanged(_ sender: UISlider) {
        // @TODO: keep it smooth for now, later we can set 'step = 1' for distanse
        _distanseSlider.value = round(_distanseSlider.value / 0.25) * 0.25
        updateDistanseLabel()
        if _currentDistanse != _distanseSlider.value {
            _currentDistanse = _distanseSlider.value
            drawGameArea()
        }
    }
    
    @IBAction fileprivate func startButtonTapped(_ sender: UIButton) {
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupMap()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


// MARK: - Custom Annotations
class MerchantPointAnnotation: MKPointAnnotation {
}
class GameCenterPointAnnotation: MKPointAnnotation {
}
class BitstopPointAnnotation: MKPointAnnotation {
}


// MARK: - Private Instanse Methods
extension BTGameMapViewController {
    
    fileprivate func setupSubviews() {
        _startButton.isEnabled = false
        _distanseSlider.minimumValue = 1.0
        _distanseSlider.maximumValue = 5.0
        _distanseSlider.value = _currentDistanse
        _startButton.layer.cornerRadius = 20.0
        
//        let bittagLogo = UIImageView(image: #imageLiteral(resourceName: "BitTag_Logo"))
//        bittagLogo.frame(forAlignmentRect: CGRect(x: 0, y: 0, width: 1, height: 1))
//        let titleview = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
//        titleview.addSubview(bittagLogo)
//        navigationItem.titleView = titleview
        let qrcodeButton = UIButton(type: .custom)
        qrcodeButton.setImage(#imageLiteral(resourceName: "icon-qrcode"), for: .normal)
        qrcodeButton.frame = CGRect(x: 0.0, y: 0.0, width: 44.0, height: 44.0)
        qrcodeButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: qrcodeButton)
        
        updateDistanseLabel()
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
        rendererView.fillColor = UIColor.red
        rendererView.strokeColor = UIColor.red
        rendererView.alpha = 0.1
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
        }
        return nil
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
