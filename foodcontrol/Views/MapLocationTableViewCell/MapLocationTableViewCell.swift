//
//  MapLocationTableViewCell.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 05.04.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import UIKit
import MapKit

protocol MapLocationTableViewCellDelegate: class {
  func didTapOnMap(for coordinates: CLLocationCoordinate2D)
}

class MapLocationTableViewCell: UITableViewCell {
  
  @IBOutlet private weak var mapView: MKMapView!
  
  private var viewModel: MapLocationTableViewCellModel!
  private weak var delegate: MapLocationTableViewCellDelegate?
  private weak var tapRecognizer: UITapGestureRecognizer?
  
  func setup(viewModel: MapLocationTableViewCellModel, delegate: MapLocationTableViewCellDelegate?) {
    self.viewModel = viewModel
    self.delegate = delegate
    
    selectionStyle = .none
    
    setupMapView()
  }
  
  private func setupMapView() {
    mapView.layer.cornerRadius = 10.0
    mapView.layer.masksToBounds = true
    mapView.isScrollEnabled = false
    mapView.isZoomEnabled = false
    setupMapMarker()
    
    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(mapViewTapped))
    mapView.addGestureRecognizer(tapRecognizer)
    self.tapRecognizer = tapRecognizer
  }
  
  private func setupMapMarker() {
    mapView.setCenter(viewModel.coordinate, animated: false)
    mapView.setCameraZoomRange(MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 5000.0), animated: false)
    mapView.removeAnnotations(mapView.annotations)
    
    let annotation = MKPointAnnotation()
    annotation.coordinate = viewModel.coordinate
    mapView.addAnnotation(annotation)
  }
  
  @objc private func mapViewTapped() {
    delegate?.didTapOnMap(for: viewModel.coordinate)
  }
  
}
