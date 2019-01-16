//
//  IndividualEventVCViewController.swift
//  Tribe
//
//  Created by Daniel Dodson on 11/6/18.
//  Copyright © 2018 Daniel Dodson. All rights reserved.
//


import UIKit
import MapKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import SwiftKeychainWrapper
import GeoFire

class IndividualEventVCViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate  {
    
    var locationManager = CLLocationManager()
    var eventPosts = [eventPostInfo]()
    var tribePosts = [tribePostInfo]()
    var eventPost: eventPostInfo!
    var tribePost: tribePostInfo!
    var imagePicker: UIImagePickerController!
    var geoFire: GeoFire!
    var mapHasCenterdOnce = false
    var geoFireRef: DatabaseReference!
    var eventKey = ""
    
    var eventdate = ""
    var eventname = ""
    var username = ""
    var eventLatitude = ""
    var eventLongitude = ""
    
    let annotation = MKPointAnnotation()
    
    @IBOutlet weak var eventName: UILabel!
    
    @IBOutlet weak var eventDate: UILabel!
    
    @IBOutlet weak var individualEventMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //eventName.text = eventPosts[eventIndex].eventname
        //eventDate.text = eventPosts[eventIndex].eventdate
        print(eventKey)
        
        
        Database.database().reference().child("posts").child(eventKey).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.eventname = (value?["eventname"] as? String)!
            self.eventdate = (value?["eventdate"] as? String)!
            self.eventLatitude = (value?["eventLatitude"] as? String)!
            self.eventLongitude = (value?["eventLongitude"] as? String)!
            print(self.eventname)
            self.eventName.text = self.eventname
            self.eventDate.text = self.eventdate
            self.centerMapOnLocation()
        })
      
        
        
        
    }
    
  
    func viewDidAppear(eventPost: eventPostInfo) {
        //eventName.text = eventPosts[eventIndex].eventname
       // eventDate.text = eventPosts[eventIndex].eventdate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func centerMapOnLocation() {
        var eventLat = Double(eventLatitude)!
        var eventLon = Double(eventLongitude)!
        var eventLoc = CLLocationCoordinate2D(latitude: eventLat, longitude: eventLon)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(eventLoc, 2000, 2000)
        self.individualEventMap.setRegion(coordinateRegion, animated: true)
        annotation.coordinate = CLLocationCoordinate2D(latitude: eventLat, longitude: eventLon)
        self.individualEventMap.addAnnotation(annotation)
    }
    


}
