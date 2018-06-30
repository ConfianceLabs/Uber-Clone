//
//  ViewController.swift
//  Uber
//
//  Created by apple on 29/03/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps


protocol MapUpdates {
    func mapDragged(loc:CLLocationCoordinate2D)
}


class ViewController: UIViewController,CLLocationManagerDelegate,MapUpdates,UIGestureRecognizerDelegate {

    var lastUpdatedLocation = CLLocation()
   
   
    @IBOutlet weak var destinationView: UIView!
    @IBOutlet weak var destinationLocation: UILabel!
    @IBOutlet weak var pickUpLocation: UILabel!
    @IBOutlet weak var mapView: UberMapView!
    var locationManager = CLLocationManager()
    let geoCoder = GMSGeocoder()
    var timer : Timer?
    
    var monitoringEnabled = true
    {
        didSet{
            if monitoringEnabled{
                locationManager.startUpdatingLocation()
            }else{
                locationManager.stopUpdatingLocation()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.mapDelegate =  self
        locationManager.delegate =  self
        locationManager.distanceFilter = 100
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
             monitoringEnabled =  true
             mapView.showMarker()
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.destinationClicked(sender:)))
        tap.delegate = self
        destinationView.addGestureRecognizer(tap)
        
        timer = Timer.scheduledTimer(timeInterval: 5.0,
                                     target: self,
                                     selector: #selector(self.updateMap),
                                     userInfo: nil,
                                     repeats: false)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            monitoringEnabled =  true
        }
    }
    
    @objc func updateMap(){
        mapView.moveCabs(lat: [loc1[1].0,loc2[1].0], long: [loc1[1].1,loc2[1].1], head: [loc1[1].2,loc2[1].2])
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
        let distance = lastUpdatedLocation.distance(from: locations[0])
        print("distance is ",distance)
        if distance > 20{
            lastUpdatedLocation = locations[0]
            mapView.updateCamera(location: locations[0])
            getAddressFromLatLong(loc: locations[0].coordinate)
        }
    }
    
    func mapDragged(loc:CLLocationCoordinate2D){
            monitoringEnabled = false
            getAddressFromLatLong(loc: loc)
            lastUpdatedLocation = CLLocation(latitude: loc.latitude,longitude: loc.longitude)
    }
    
    func getAddressFromLatLong(loc:CLLocationCoordinate2D){
        geoCoder.reverseGeocodeCoordinate(loc) { (response, error) in
            if let address = response?.firstResult(){
                self.pickUpLocation.text = address.lines?.joined(separator: " ")
            }
        }
    }
   

    @IBAction func recentre(_ sender: Any) {
        monitoringEnabled = true
    }
    
    @objc func destinationClicked(sender: UITapGestureRecognizer? = nil) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: false, completion: nil)
    }
    
}


extension ViewController:GMSAutocompleteViewControllerDelegate{
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        destinationLocation.text = place.formattedAddress
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

}

