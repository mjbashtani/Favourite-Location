//
//  LocationFetcher.swift
//  Favourite Location
//
//  Created by Mohammad Bashtani on 9/13/22.
//

import CoreLocation
import Foundation

class LocationFetcher: NSObject, CLLocationManagerDelegate {
    enum FetchingLocationError {
        case userDenied
        case error
    }
    
    let manager = CLLocationManager()
    var lastFetchedLocation: CLLocationCoordinate2D?
    var userdeniedLocationPermision: (() -> Void)?
    var userLocationUpdated: ((CLLocationCoordinate2D?) -> Void)?
    var errorOccuredWhenFetchingLocation: ((FetchingLocationError) -> Void)?
   

    override init() {
        super.init()
        manager.delegate = self

    }

    func start() {
        manager.requestWhenInUseAuthorization()
    }
    
    func retry() {
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        let location = locations.first?.coordinate
        self.lastFetchedLocation = locations.first?.coordinate
        userLocationUpdated?(location)
        
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied {
            errorOccuredWhenFetchingLocation?(.userDenied)
            return
        }
        manager.startUpdatingLocation()
        return
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if (manager.authorizationStatus != .denied  || manager.authorizationStatus != .notDetermined) && manager.location == nil {
            if manager.location != nil {
                errorOccuredWhenFetchingLocation?(.error)
            }
            manager.stopUpdatingLocation()
            
        }
      
    }

}
