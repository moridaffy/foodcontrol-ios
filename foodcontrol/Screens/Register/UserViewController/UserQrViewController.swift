//
//  UserQrViewController.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 20.05.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import UIKit

class UserQrViewController: UIViewController {
  
  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private let qrValue: String
  
  init(qrValue: String) {
    self.qrValue = qrValue
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupLayout()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    imageView.image = generateQrCode(from: qrValue)
  }
  
  private func setupLayout() {
    view.addSubview(imageView)
    
    view.addConstraints([
      imageView.topAnchor.constraint(equalTo: view.topAnchor),
      imageView.leftAnchor.constraint(equalTo: view.leftAnchor),
      imageView.rightAnchor.constraint(equalTo: view.rightAnchor),
      imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
  
  private func generateQrCode(from string: String) -> UIImage? {
    let data = string.data(using: String.Encoding.ascii)
    guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
    filter.setValue(data, forKey: "inputMessage")
    let transform = CGAffineTransform(scaleX: 10.0, y: 10.0)
    
    guard let output = filter.outputImage?.transformed(by: transform) else { return nil }
    return UIImage(ciImage: output)
  }
  
}
