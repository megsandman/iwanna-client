//
//  MapViewController.swift
//  iwanta
//
//  Created by Meg Sandman on 6/21/15.
//  Copyright (c) 2015 Meg Sandman. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var match: Match!
    var completeAddress:String!
    var geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        completeAddress = "\(match.address), \(match.city), \(match.state)"
        println(completeAddress)
        geocoder.geocodeAddressString(completeAddress, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) -> Void in
            if let placemark = placemarks?[0] as? CLPlacemark {
                let location = placemark.location.coordinate
//                self.coords = location.coordinate
                
                let span = MKCoordinateSpanMake(0.01, 0.01)
                let region = MKCoordinateRegion(center: location, span: span)
                self.mapView.setRegion(region, animated:true)
                let annotation = MKPointAnnotation()
                annotation.coordinate = location
                
//                let annotation = MKPlacemark(placemark: placemark)
                annotation.title = self.match.name
                annotation.subtitle = self.match.address
//                self.mapView.addAnnotation(MKPlacemark(placemark: placemark))
                self.mapView.addAnnotation(annotation)
            }
        })
        
//        let annotation = MKPointAnnotation()
//        annotation.setCoordinate(location)
//        annotation.title = "TITLE"
//        annotation.subtitle = "subtitle"
//        mapView.addAnnotation(annotation)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
