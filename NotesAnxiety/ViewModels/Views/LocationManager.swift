//
//  LocationManager.swift
//  NotesAnxiety
//
//  Created by Sena Kristiawan on 13/07/24.
//

import CoreLocation
import CoreLocationUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate{
    let manager = CLLocationManager()
    
    @Published var location : CLLocationCoordinate2D?
    
    override init(){
        super.init()
        manager.delegate = self
    }
    
    func requestLocation(){
        manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
    }
    
    
}
