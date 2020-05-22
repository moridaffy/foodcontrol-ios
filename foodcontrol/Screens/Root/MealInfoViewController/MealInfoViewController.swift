//
//  MealInfoViewController.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 22.05.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import UIKit
import CoreLocation

class MealInfoViewController: UIViewController {
  
  @IBOutlet private weak var tableView: UITableView!
  
  private var viewModel: MealInfoViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupNavigationBar()
    setupTableView()
  }
  
  func setup(viewModel: MealInfoViewModel) {
    self.viewModel = viewModel
  }
  
  private func setupNavigationBar() {
    title = NSLocalizedString("Прием пищи", comment: "")
    
    let backButton = UIBarButtonItem(image: nil, style: .done, target: nil, action: nil)
    backButton.tintColor = UIColor.additionalYellow
    navigationItem.backBarButtonItem = backButton
  }
  
  private func setupTableView() {
    tableView.contentInset = UIEdgeInsets(top: -32.0, left: 0.0, bottom: 0.0, right: 0.0)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorStyle = .none
    tableView.tableFooterView = UIView()
    tableView.register(UINib(nibName: "MealHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: String(describing: MealHeaderTableViewCell.self))
    tableView.register(UINib(nibName: "DishTableViewCell", bundle: nil), forCellReuseIdentifier: String(describing: DishTableViewCell.self))
    tableView.register(UINib(nibName: "MapLocationTableViewCell", bundle: nil), forCellReuseIdentifier: String(describing: MapLocationTableViewCell.self))
  }
  
  private func openDishViewController(for dish: Dish) {
    guard let dishInfoViewController = UIStoryboard(name: "Root", bundle: nil).instantiateViewController(withIdentifier: "DishInfoViewController") as? DishInfoViewController else { return }
    dishInfoViewController.setup(viewModel: DishInfoViewModel(dish: dish), delegate: nil)
    navigationController?.pushViewController(dishInfoViewController, animated: true)
  }
}

extension MealInfoViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    guard indexPath.section == 1 else { return }
    let dish = viewModel.meal.dishes[indexPath.row]
    openDishViewController(for: dish)
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.section {
    case 0:
      return 76.0
    case 1:
      return 58.0
    case 2:
      return 199.0
    default:
      return UITableView.automaticDimension
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.section {
    case 0:
      return 76.0
    case 1:
      return UITableView.automaticDimension
    case 2:
      return 199.0
    default:
      return UITableView.automaticDimension
    }
  }
}

extension MealInfoViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 1
    case 1:
      return viewModel.meal.dishes.count
    case 2:
      return viewModel.meal.coordinates == nil ? 0 : 1
    default:
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MealHeaderTableViewCell.self)) as? MealHeaderTableViewCell else { fatalError() }
      cell.setup(viewModel: MealHeaderTableViewCellModel(meal: viewModel.meal))
      return cell
    case 1:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DishTableViewCell.self)) as? DishTableViewCell else { fatalError() }
      cell.setup(viewModel: DishTableViewCellModel(dish: viewModel.meal.dishes[indexPath.row]))
      return cell
    case 2:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MapLocationTableViewCell.self)) as? MapLocationTableViewCell else { fatalError() }
      cell.setup(viewModel: MapLocationTableViewCellModel(coordinate: viewModel.meal.coordinates!), delegate: self)
      return cell
    default:
      fatalError()
    }
  }
}

extension MealInfoViewController: MapLocationTableViewCellDelegate {
  func didTapOnMap(for coordinates: CLLocationCoordinate2D) {
    showAlert(title: NSLocalizedString("Открыть место?", comment: ""),
              body: NSLocalizedString("Выберите приложение, чтобы открыть это место", comment: ""),
              button: nil,
              actions: coordinates.getOpenInActions())
  }
}
