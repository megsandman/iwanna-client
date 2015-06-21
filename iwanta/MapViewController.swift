//
//  MapViewController.swift
//  iwanta
//
//  Created by Meg Sandman on 6/21/15.
//  Copyright (c) 2015 Meg Sandman. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var match: Match!
    var completeAddress:String!
    var geocoder = CLGeocoder()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var didFindMyLocation = false
        completeAddress = "\(match.address), \(match.city), \(match.state)"
        
        geocoder.geocodeAddressString(completeAddress, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) -> Void in
            if let placemark = placemarks?[0] as? CLPlacemark {
                let location = placemark.location.coordinate
                let span = MKCoordinateSpanMake(0.01, 0.01)
                let region = MKCoordinateRegion(center: location, span: span)
                self.mapView.setRegion(region, animated:true)
                let annotation = MKPointAnnotation()
                annotation.coordinate = location
                
                annotation.title = self.match.name
                annotation.subtitle = self.match.address
                self.mapView.addAnnotation(annotation)
                
            }
        })
        
//        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
    }
    
//    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
//        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
//            mapView.showsUserLocation = true
//            locationManager.startUpdatingLocation()
//        }
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
