//
//  mapView.swift
//  Tribe
//
//  Created by Daniel Dodson on 11/4/18.
//  Copyright © 2018 Daniel Dodson. All rights reserved.
//
import UIKit
import MapKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import SwiftKeychainWrapper
import GeoFire

class mapView: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var locationManager = CLLocationManager()
    var geoFire: GeoFire!
    var mapHasCenterdOnce = false
    var geoFireRef: DatabaseReference!
    var eventPosts = [eventPostInfo]()
    var eventPost: eventPostInfo!

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        geoFireRef = Database.database().reference()
        geoFire = GeoFire(firebaseRef: geoFireRef.child("posts"))
    
      mapView.showsUserLocation = true
        
        mapView.delegate = self
        mapView.userTrackingMode = MKUserTrackingMode.follow
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        
        Database.database().reference().child("posts").observe(.value, with:
            {(snapshot) in
                if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                    self.eventPosts.removeAll()
                    for data in snapshot {
                        print(data)
                        if let postDict = data.value as? Dictionary<String, AnyObject> {
                            let key = data.key
                            let eventPost = eventPostInfo(eventPostKey: String(key), eventPostData: postDict)
                            self.eventPosts.append(eventPost)
                        }
                    }
                }
                let loc = CLLocation(latitude: self.mapView.centerCoordinate.latitude, longitude: self.mapView.centerCoordinate.longitude)
                self.showSightingsOnMap(location: loc)
        })
    }
    
   
    
    
    func showSightingsOnMap(location: CLLocation) {
        print("hello")
        let circleQuery = geoFire.query(at: location, withRadius: 2.5)
        _ = circleQuery.observe(GFEventType.keyEntered, with: {(key: String!, location: CLLocation!) in
            print("Key '\(key)' entered the search area and is at location '\(location)'")
            if let key = key, let location = location {
               // let anno = locationAnnotation(coordinate: location.coordinate, eventPostKey: String(key), title: eventPostInfo["eventname"] , date: "date")
                //let anno = locationAnnotation(coordinate: location.coordinate, eventPostKey: String(key), title: self.title!, date: "date")
               let anno = MKPointAnnotation()
                let lat = Double(self.eventPost.eventLatitude)
                let long = Double(self.eventPost.eventLongitude)
                anno.coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
                anno.title = self.eventPost.eventname
              
                print(location)
              
                self.mapView.addAnnotation(anno)
              //eventPostInfo(coordinate: location.coordinate, eventPostKey: String(key),
            }
            else {
                print("NOWORK")
            }
        })
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        let loc = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        showSightingsOnMap(location: loc)
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationIdentifier = "AnnotationIdentifier"
        
        //var annotationView: MKAnnotationView?
        var anoot = MKPointAnnotation()
        var annotationView: MKAnnotationView?
     
   mapView.showsUserLocation = true
    
        
            let av = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            av.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView = av
        
        
        if let annotationView = annotationView, let anno = annotation as? locationAnnotation {
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "locationIcon")
            let btn = UIButton()
            btn.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            btn.setImage(UIImage(named: "Sports"), for: .normal)
            annotationView.rightCalloutAccessoryView = btn
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let anno = view.annotation as? locationAnnotation {
            
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        }
        else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 2000, 2000)
    }
    
    func feedMap(_ feedMap: MKMapView, didUpdate userLocation: MKUserLocation){
        if let loc = userLocation.location {
            if !mapHasCenterdOnce {
                centerMapOnLocation(location: loc)
                mapHasCenterdOnce = true
            }
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        mapView.showsUserLocation = true
        locationAuthStatus()
        
       
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let localValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("location = \(localValue.latitude) \(localValue.longitude)")
        let userLocation = locations.last
        let viewRegion = MKCoordinateRegionMakeWithDistance((userLocation?.coordinate)!, 600, 600)
        self.mapView.setRegion(viewRegion, animated: true)
    }
    

   
}
