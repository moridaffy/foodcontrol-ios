//
//  CLLocationCoordinate2D+AlertActions.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 05.04.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import MapKit
import UIKit

extension CLLocationCoordinate2D {
  
  func getOpenInActions() -> [UIAlertAction] {
    var actions: [UIAlertAction] = []
    
    let appleMapsAction = UIAlertAction(title: NSLocalizedString("Apple Maps", comment: ""), style: .default) { (_) in
      let placemark = MKPlacemark(coordinate: self)
      let mapItem = MKMapItem(placemark: placemark)
      mapItem.openInMaps(launchOptions: nil)
    }
    actions.append(appleMapsAction)
    
    if let baseUrl = URL(string: "comgooglemaps://"), UIApplication.shared.canOpenURL(baseUrl) {
      let urlString = baseUrl.absoluteString + "?q=&center=\(self.latitude),\(self.longitude)&zoom=20"
      if let url = URL(string: urlString) {
        let googleMapsAction = UIAlertAction(title: NSLocalizedString("Google Maps", comment: ""), style: .default) { (_) in
          UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        actions.append(googleMapsAction)
      }
    }
    
    if let baseUrl = URL(string: "yandexmaps://"), UIApplication.shared.canOpenURL(baseUrl) {
      let urlString = baseUrl.absoluteString + "maps.yandex.ru/?pt=\(self.longitude),\(self.latitude)&z=18&l=map"
      if let url = URL(string: urlString) {
        let yandexMapsAction = UIAlertAction(title: NSLocalizedString("Яндекс.Карты", comment: ""), style: .default) { (_) in
          UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        actions.append(yandexMapsAction)
      }
    }
    
    if let baseUrl = URL(string: "yandexnavi://"), UIApplication.shared.canOpenURL(baseUrl) {
      let urlString = baseUrl.absoluteString + "show_point_on_map?lat=\(self.latitude)&lon=\(self.longitude)"
      if let url = URL(string: urlString) {
        let yandexNavigationAction = UIAlertAction(title: NSLocalizedString("Яндекс.Навигатор", comment: ""), style: .default) { (_) in
          UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        actions.append(yandexNavigationAction)
      }
    }
    
    if let baseUrl = URL(string: "mapswithme://"), UIApplication.shared.canOpenURL(baseUrl) {
      let urlString = baseUrl.absoluteString + "map?v=1&ll=\(self.latitude),\(self.longitude)&appname=foodcontrol"
      if let url = URL(string: urlString) {
        let mapsMeAction = UIAlertAction(title: NSLocalizedString("Maps.Me", comment: ""), style: .default) { (_) in
          UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        actions.append(mapsMeAction)
      }
    }
    
    let cancelAction = UIAlertAction(title: NSLocalizedString("Отмена", comment: ""), style: .cancel) { (_) in }
    actions.append(cancelAction)
    
    return actions
  }
  
}
