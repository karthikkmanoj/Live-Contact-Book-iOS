//
//  LocationViewController.swift
//  Contact Book (Stage 1)
//
//  Created by doTZ on 24/11/17.
//  Copyright © 2017 doTZ. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol LocationViewControllerDelegate {
    
    func myLocationAddress(address : String)
    
}

class LocationViewController: UIViewController, CLLocationManagerDelegate {

    var delegate : LocationViewControllerDelegate?
    
    let locationManger = CLLocationManager()
    
    var timer = Timer()
    
    var count = 5
    
    var computedAddress = ""
    
    var userLocationStored : CLLocation?
    
    @IBOutlet weak var mapKitView: MKMapView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationItem.title = "Location Finder"
        
        setupLocationManger()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.counter), userInfo: nil, repeats: true)
        
    }
    
    func counter () {
        
        count = count - 1
        
        if count == 0 {
            
            timer.invalidate()
            
            locationManger.stopUpdatingLocation()
            
            pinLocationOnMap(userLocationRecieved : userLocationStored)
            
            self.delegate?.myLocationAddress(address: computedAddress)
    
        }
        
    }
    
    func setupLocationManger() {
        
        locationManger.delegate = self
        
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManger.requestWhenInUseAuthorization()
        
        locationManger.startUpdatingLocation()
        
    }
    
    func pinLocationOnMap(userLocationRecieved : CLLocation?) {
        
        let latitude = userLocationRecieved!.coordinate.latitude
        
        let longitude = userLocationRecieved!.coordinate.longitude
        
        let latDelta : CLLocationDegrees = 0.5
        
        let lonDelta : CLLocationDegrees = 0.5
        
        let span : MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        
        let coordinates : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let region : MKCoordinateRegion = MKCoordinateRegion(center: coordinates, span: span)
        
        mapKitView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        
        annotation.title = "I am here"
        
        annotation.coordinate = coordinates
        
        mapKitView.addAnnotation(annotation)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.count > 0 {
            
            let userLocation = locations[0]
            
            userLocationStored = locations[0]
            
            CLGeocoder().reverseGeocodeLocation(userLocation) { [weak self] (placemark, error) in
                
                if error != nil {
                    
                    let alertControllerForCamera = UIAlertController(title: "Error", message: "Cannot Locate", preferredStyle: .alert)
                    
                    alertControllerForCamera.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
                    
                } else {
                    
                    if let placeMark = placemark?[0] {
                        
                        var subThoroughfare = ""
                        
                        if placeMark.subThoroughfare != nil {
                            
                            subThoroughfare = placeMark.subThoroughfare!
                            
                        }
                        
                        var thoroughfare = ""
                        
                        if placeMark.thoroughfare != nil {
                            
                            thoroughfare = placeMark.thoroughfare!
                            
                        }
                        
                        var subLocality = ""
                        
                        if placeMark.subLocality != nil {
                            
                            subLocality = placeMark.subLocality!
                            
                        }
                        
                        var subAdministrativeArea = ""
                        
                        if placeMark.subAdministrativeArea != nil {
                            
                            subAdministrativeArea = placeMark.subAdministrativeArea!
                            
                        }
                        
                        var postalCode = ""
                        
                        if placeMark.postalCode != nil {
                            
                            postalCode = placeMark.postalCode!
                            
                        }
                        
                        var country = ""
                        
                        if placeMark.country != nil {
                            
                            country = placeMark.country!
                            
                        }
                        
                        self?.computedAddress = subThoroughfare + "\n" + thoroughfare + "\n" + subLocality + "\n" + subAdministrativeArea
                            + "\n" + postalCode + "\n" + country
                        
                        self?.computedAddress = (self?.computedAddress)!.trimmingCharacters(in: .whitespaces)
                        
                    }
                    
                }
                
            }
            
        }
        
    }

}
