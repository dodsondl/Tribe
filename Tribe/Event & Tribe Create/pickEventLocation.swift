//
//  pickEventLocation.swift
//  Tribe
//
//  Created by Daniel Dodson on 10/24/18.
//  Copyright © 2018 Daniel Dodson. All rights reserved.
//

import UIKit
import MapKit

class pickEventLocation: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate {
    
    
      var locationManager = CLLocationManager()
    var lat = ""
    var long = ""
    var eventLocation = CLLocationCoordinate2D()

    @IBOutlet weak var pickEventLocationMap: MKMapView!
    
    
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
        self.pickEventLocationMap.setRegion(viewRegion, animated: true)
    }
  


    @IBAction func pickLocatinGesture(_ sender: UILongPressGestureRecognizer) {
        if sender.state != UIGestureRecognizerState.began { return }
        let touchLocation = sender.location(in: pickEventLocationMap)
        let locationCoordinate = pickEventLocationMap.convert(touchLocation, toCoordinateFrom: pickEventLocationMap)
        print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
        
        let annotation = MKPointAnnotation()
        annotation.coordinate.latitude = locationCoordinate.latitude
        annotation.coordinate.longitude = locationCoordinate.longitude
        pickEventLocationMap.addAnnotation(annotation)
        
        lat = String(locationCoordinate.latitude)
        long = String(locationCoordinate.longitude)
        eventLocation = locationCoordinate
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "setLocationSegue" {
            if let destination = segue.destination as? createEventVC {
                if lat != nil {
                    destination.lat = lat
                }
                
                if long != nil {
                    destination.long = long
                }
                if eventLocation != nil {
                    destination.eventLocation = eventLocation
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
