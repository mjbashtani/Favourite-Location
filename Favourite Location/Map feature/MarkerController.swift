//
//  MarkerController.swift
//  Favourite Location
//
//  Created by Mohammad Bashtani on 9/13/22.
//

import Foundation

class MarkerController {
    weak var mapView: MapView?
    
    func addMarker(with location: Location, id: String, title: String) {
        let vm = MarkerViewModel(id: id, latidude: location.latitude, longitude: location.longitude, title: title)
        mapView?.showMarker(vm)
    }
    
    func deleteMarker(with id: String) {
        let vm = DeleteMarkerViewModel(id: id)
        mapView?.deleteMarker(vm)
    }
}
