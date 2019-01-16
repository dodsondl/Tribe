//
//  pickTribeLocation.swift
//  Tribe
//
//  Created by Daniel Dodson on 11/19/18.
//  Copyright © 2018 Daniel Dodson. All rights reserved.
//

import UIKit
import MapKit

class pickTribeLocation: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate {
    
    
    var locationManager = CLLocationManager()
    var lat = ""
    var long = ""
    var tribeLocation = CLLocationCoordinate2D()
    
   
    
    @IBOutlet weak var pickTribeLocationMap: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let localValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("location = \(localValue.latitude) \(localValue.longitude)")
        let userLocation = locations.last
        let viewRegion = MKCoordinateRegionMakeWithDistance((userLocation?.coordinate)!, 600, 600)
        self.pickTribeLocationMap.setRegion(viewRegion, animated: true)
    }
    
    
    
    @IBAction func pickLocatinGesture(_ sender: UILongPressGestureRecognizer) {
        if sender.state != UIGestureRecognizerState.began { return }
        let touchLocation = sender.location(in: pickTribeLocationMap)
        let locationCoordinate = pickTribeLocationMap.convert(touchLocation, toCoordinateFrom: pickTribeLocationMap)
        print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
        
        let annotation = MKPointAnnotation()
        annotation.coordinate.latitude = locationCoordinate.latitude
        annotation.coordinate.longitude = locationCoordinate.longitude
        pickTribeLocationMap.addAnnotation(annotation)
        
        lat = String(locationCoordinate.latitude)
        long = String(locationCoordinate.longitude)
        tribeLocation = locationCoordinate
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "setTribeLocationSegue" {
            if let destination = segue.destination as? createTribeVC {
                if lat != nil {
                    destination.lat = lat
                }
                
                if long != nil {
                    destination.long = long
                }
                if tribeLocation != nil {
                    destination.tribeLocation = tribeLocation
                }
                
            }
        }
    }
    
    
    @IBAction func setLocationButton(_ sender: Any) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
}
