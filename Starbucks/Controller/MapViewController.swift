//
//  MapViewController.swift
//  Starbucks
//
//  Created by User on 4/27/19.
//  Copyright © 2019 Enea Dume. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

     @IBOutlet weak var map: MKMapView!
    
    var store: Store?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //add a marker with store location in map
        addLocationOnMap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = store?.name ?? ""
    }
    
    /**
     crate a marker and add it on a map with store location coordinates
     */
    func addLocationOnMap() {
        guard let storeCoordinates = store?.location.coordinates else { return }
        //get location coordinate from store coordinates
        let locationCoordinate = CLLocationCoordinate2DMake(storeCoordinates.lat, storeCoordinates.long)
        
        //smaller then 200 the map is too zoomed. 200 is ok
        let regionDistance: CLLocationDistance = 200
        let regionSpan = MKCoordinateRegion(center: locationCoordinate, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        self.map.setRegion(regionSpan, animated: true)
        //add marker
        let mapItem = MKPointAnnotation()
        mapItem.coordinate = locationCoordinate
        self.map.addAnnotation(mapItem)
    }

}
