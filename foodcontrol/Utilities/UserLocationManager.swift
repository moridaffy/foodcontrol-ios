//
//  UserLocationManager.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 20.05.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import CoreLocation

final class UserLocationManager {
    
    // MARK: - Properties
    
    static let shared = UserLocationManager()
    
    private let locationManager = LocationManagerWithDelegate()
    
    var currentLocation: CLLocationCoordinate2D?
    
    // MARK: Computed properties
    
    var isLocationPermissionEnabled: Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .authorizedAlways, .authorizedWhenInUse:
                return true
                
            default:
                break
            }
        }
        
        return false
    }
    
    // MARK: - Methods
    
    init() {
        self.locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.setDelegate()
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.pausesLocationUpdatesAutomatically = false
            locationManager.startUpdatingLocation()
            
            locationManager.userUpdateLocationHandler = { coordinates in
                self.currentLocation = coordinates
            }
        }
    }
  
  func configure() { }
}

fileprivate class LocationManagerWithDelegate: CLLocationManager, CLLocationManagerDelegate {
    
    var userUpdateLocationHandler: ((CLLocationCoordinate2D) -> Void)?
    
    func setDelegate() {
        delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last, let handler = userUpdateLocationHandler {
            handler(location.coordinate)
        }
    }
    
}
