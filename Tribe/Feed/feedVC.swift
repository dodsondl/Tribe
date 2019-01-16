//
//  feedVC.swift
//  Tribe
//
//  Created by Daniel Dodson on 10/1/18.
//  Copyright © 2018 Daniel Dodson. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import SwiftKeychainWrapper
import GeoFire




class feedVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, CLLocationManagerDelegate, UIImagePickerControllerDelegate, MKMapViewDelegate {

    var locationManager = CLLocationManager()
    var eventPosts = [eventPostInfo]()
    var tribePosts = [tribePostInfo]()
    var eventPost: eventPostInfo!
    var tribePost: tribePostInfo!
    var imagePicker: UIImagePickerController!
    var geoFire: GeoFire!
    var mapHasCenterdOnce = false
    var geoFireRef: DatabaseReference!
    var eventsKey = ""
    
    @IBOutlet weak var feedDarkView: UIView!
    @IBOutlet var createTribeorEvent: UIView!
    
    var createTribeorEventTopConstraint: NSLayoutConstraint!
    

    
    @IBOutlet var feedMap: MKMapView!
    
    
    
   
    @IBOutlet weak var eventCollectionView: UICollectionView!
    
    
    @IBOutlet weak var tribeCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customization()
        
        geoFireRef = Database.database().reference()
        geoFire = GeoFire(firebaseRef: geoFireRef)
        
        eventCollectionView.delegate = self
        eventCollectionView.dataSource = self
        tribeCollectionView.delegate = self
        tribeCollectionView.dataSource = self
        
        feedMap.delegate = self
        feedMap.userTrackingMode = MKUserTrackingMode.follow
        
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
                    self.eventCollectionView.reloadData()
            })
        
        Database.database().reference().child("tribes").observe(.value, with:
            {(snapshot) in
                if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                    self.tribePosts.removeAll()
                    for data in snapshot {
                        print(data)
                        if let postDict = data.value as? Dictionary<String, AnyObject> {
                            let key = data.key
                            let tribePost = tribePostInfo(tribePostKey: key, tribePostData: postDict)
                            self.tribePosts.append(tribePost)
                            
                            
                            
                        }
                    }
                }
                self.tribeCollectionView.reloadData()
        })
    }
    
    
    
    func customization() {
         self.feedDarkView.alpha = 0
        
        self.view.insertSubview(self.createTribeorEvent, belowSubview: self.feedMap)
        self.createTribeorEvent.translatesAutoresizingMaskIntoConstraints = false
        self.createTribeorEvent.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.createTribeorEventTopConstraint = NSLayoutConstraint.init(item: self.createTribeorEvent, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 1000)
        self.createTribeorEventTopConstraint.isActive = true
        self.createTribeorEvent.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.45).isActive = true
        self.createTribeorEvent.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true
        self.createTribeorEvent.layer.cornerRadius = 8

    }
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            feedMap.showsUserLocation = true
        }
        else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            feedMap.showsUserLocation = true
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
    
    
    
    @IBAction func toTribeorEventButton(_ sender: Any) {
        
        self.feedDarkView.alpha = 0.5
        
         self.createTribeorEventTopConstraint.constant = 180
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.eventCollectionView.reloadData()
        self.tribeCollectionView.reloadData()
        locationAuthStatus()
    }
  
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let localValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("location = \(localValue.latitude) \(localValue.longitude)")
        let userLocation = locations.last
        let viewRegion = MKCoordinateRegionMakeWithDistance((userLocation?.coordinate)!, 600, 600)
        self.feedMap.setRegion(viewRegion, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.tribeCollectionView {
            print(tribePosts.count)
            return tribePosts.count
        }
        
        else {
            return eventPosts.count}
        
      
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == eventCollectionView {
          
        let eventPost = eventPosts.reversed()[indexPath.row]
        print(eventPosts.count)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "localEventsCell", for: indexPath) as? localEventsCell
        cell?.configCell(eventPost: eventPost)
            return cell!}
        
        else{
            let tribePost = tribePosts.reversed()[indexPath.row]
            print(tribePosts.count)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "localTribescell", for: indexPath) as? localTribescell
            cell?.configCell(tribePost: tribePost)
            return cell!
            
        }
        }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    

   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "localEventToDetail" {
            
            if let indexPaths = self.eventCollectionView!.indexPathsForSelectedItems{
                  let destination = segue.destination as? IndividualEventVCViewController
                let cell = sender as! UICollectionViewCell
                let indexPathh = self.eventCollectionView.indexPath(for: cell)
                let post = self.eventPosts.reversed()[(indexPathh?.row)!]
                destination?.eventKey = post.eventPostKey
                
                
            }
            
        
        }
        if segue.identifier == "localTribeToDetail" {
            
            if let indexPaths = self.tribeCollectionView!.indexPathsForSelectedItems{
                let destination = segue.destination as? IndividualTribeViewController
                let cell = sender as! UICollectionViewCell
                let indexPathh = self.tribeCollectionView.indexPath(for: cell)
                let tribee = self.tribePosts.reversed()[(indexPathh?.row)!]
                destination?.tribeKey = tribee.tribePostKey
                
                
            }
            
          
            
            
        }
    }
 
    
    
      }





