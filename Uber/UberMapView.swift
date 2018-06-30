//
//  UberMapView.swift
//  Uber
//
//  Created by apple on 31/03/18.
//  Copyright © 2018 apple. All rights reserved.
//

import Foundation
import GoogleMaps

let zoomValue : Float = 15.0
var markers : [CLLocationCoordinate2D] = [CLLocationCoordinate2D(latitude: 28.627561,longitude: 77.278408),CLLocationCoordinate2D(latitude: 28.623456,longitude: 77.276408)]

var loc1 : [(Double,Double,Double)] = [
    (28.631766 ,77.279315 ,55.0),
    (28.633575 ,77.282024 ,55.0),
    (28.627861 ,77.278608 ,240.0)]

var loc2 : [(Double,Double,Double)] = [
   (28.629429, 77.277182, 140.0),
    (28.627173, 77.279344, 140.0),
    (28.623599, 77.276508, 132.0)]

class UberMapView:GMSMapView,GMSMapViewDelegate{
    
    var mapDelegate : MapUpdates?
    var gmsMarkers = [GMSMarker]()
    
    
    override func awakeFromNib() {
        self.delegate = self
    }
    
    var cameraPosition = GMSCameraPosition.camera(withLatitude: 37.36, longitude: -122.0, zoom: zoomValue)
    {
        didSet{
            //self.camera = cameraPosition
          //  self.updateCamera(location: cameraPosition.target)
           //  self.moveCamera(GMSCameraUpdate.setCamera(self.cameraPosition))
            self.animate(to: cameraPosition)
        }
    }
    
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        mapDelegate?.mapDragged(loc: position.target)
        
    }
    
    func showMarker(){
        
        for i in 0..<2{
            var loc = (Double(),Double(),Double())
            
            if i == 0{
                loc = loc1[0]
            }else{
                loc = loc2[0]
            }
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: loc.0,longitude: loc.1)
        marker.icon = UIImage(named:"car")
        marker.rotation = loc.2
        gmsMarkers.append(marker)
        marker.map = self
        }
        
        
    }

    func moveCabs(lat:[CLLocationDegrees],long:[CLLocationDegrees],head:[CLLocationDegrees]){
        
        for i in 0..<2{
        CATransaction.begin()
        CATransaction.setAnimationDuration(1.0)
        gmsMarkers[i].rotation = head[i]
            gmsMarkers[i].position = CLLocationCoordinate2D(latitude:  lat[i], longitude: long[i])
        CATransaction.commit()
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
//            let camera = GMSCameraPosition.camera(withLatitude: lat[i], longitude: long[i], zoom: zoomValue)
//            self.animate(to: camera)
//        })
        }
        
        
    }
    
    func updateCamera(location:CLLocation){
      
        cameraPosition = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: zoomValue)
        
    }
    
    
}
