//
//  CreateMealViewController.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 05.04.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import UIKit
import CoreLocation

class CreateMealViewController: UIViewController {
  
  @IBOutlet private weak var tableView: UITableView!
  @IBOutlet private weak var fadeImageView: UIImageView!
  @IBOutlet private weak var addMealButtonContainerView: UIView!
  @IBOutlet private weak var addMealButtonTitleLabel: UILabel!
  @IBOutlet private weak var addMealButtonIconImageView: UIImageView!
  
  private let viewModel = CreateMealViewControllerModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupNavigationBar()
    setupTableView()
    setupBottomButton()
  }
  
  private func setupNavigationBar() {
    title = NSLocalizedString("Добавить прием", comment: "")
    
    let backButton = UIBarButtonItem(image: nil, style: .done, target: nil, action: nil)
    backButton.tintColor = UIColor.additionalYellow
    navigationItem.backBarButtonItem = backButton
  }
  
  private func setupTableView() {
    tableView.contentInset = UIEdgeInsets(top: -32.0, left: 0.0, bottom: 0.0, right: 0.0)
    tableView.tableFooterView = UIView()
    tableView.separatorStyle = .none
    tableView.register(UINib(nibName: "MealHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: String(describing: MealHeaderTableViewCell.self))
    tableView.register(UINib(nibName: "DishTableViewCell", bundle: nil), forCellReuseIdentifier: String(describing: DishTableViewCell.self))
    tableView.register(UINib(nibName: "BigButtonTableViewCell", bundle: nil), forCellReuseIdentifier: String(describing: BigButtonTableViewCell.self))
    tableView.register(UINib(nibName: "MapLocationTableViewCell", bundle: nil), forCellReuseIdentifier: String(describing: MapLocationTableViewCell.self))
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  private func setupBottomButton() {
    addMealButtonContainerView.backgroundColor = UIColor.additionalYellow
    addMealButtonContainerView.layer.cornerRadius = 10.0
    addMealButtonContainerView.layer.masksToBounds = true
    addMealButtonTitleLabel.text = NSLocalizedString("Добавить прием пищи", comment: "")
    addMealButtonTitleLabel.textColor = UIColor.white
    addMealButtonTitleLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
    addMealButtonIconImageView.image = UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate)
    addMealButtonIconImageView.tintColor = UIColor.white
  }
  
  @objc private func addMealButtonTapped() {
    navigationController?.popViewController(animated: true)
  }
  
  private func openAddDishViewController() {
    guard let addDishViewController = UIStoryboard(name: "Root", bundle: nil).instantiateViewController(withIdentifier: "AddDishViewController") as? AddDishViewController else { return }
    navigationController?.pushViewController(addDishViewController, animated: true)
  }
}

extension CreateMealViewController: MapLocationTableViewCellDelegate {
  func didTapOnMap(for coordinates: CLLocationCoordinate2D) {
    showAlert(title: NSLocalizedString("Открыть место?", comment: ""),
              body: NSLocalizedString("Выберите приложение, чтобы открыть это место", comment: ""),
              button: nil,
              actions: coordinates.getOpenInActions())
  }
}

extension CreateMealViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let cellModel = viewModel.cellModels[indexPath.row]
    if let cellModel = cellModel as? BigButtonTableViewCellModel {
      guard cellModel.type == .addDish else { return }
      openAddDishViewController()
    }
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    let cellModel = viewModel.cellModels[indexPath.row]
    if cellModel is MealHeaderTableViewCellModel {
      return 76.0
    } else if cellModel is DishTableViewCellModel {
      return 58.0
    } else if let cellModel = cellModel as? BigButtonTableViewCellModel {
      return CGFloat(cellModel.type.height)
    } else if cellModel is MapLocationTableViewCellModel {
      return 199.0
    } else {
      return UITableView.automaticDimension
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let cellModel = viewModel.cellModels[indexPath.row]
    if cellModel is MealHeaderTableViewCellModel {
      return 76.0
    } else if cellModel is DishTableViewCellModel {
      return UITableView.automaticDimension
    } else if let cellModel = cellModel as? BigButtonTableViewCellModel {
      return CGFloat(cellModel.type.height)
    } else if cellModel is MapLocationTableViewCellModel {
      return 199.0
    } else {
      return UITableView.automaticDimension
    }
  }
}

extension CreateMealViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.cellModels.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellModel = viewModel.cellModels[indexPath.row]
    if let cellModel = cellModel as? MealHeaderTableViewCellModel {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MealHeaderTableViewCell.self)) as? MealHeaderTableViewCell else { fatalError() }
      cell.setup(viewModel: cellModel)
      return cell
    } else if let cellModel = cellModel as? DishTableViewCellModel {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DishTableViewCell.self)) as? DishTableViewCell else { fatalError() }
      cell.setup(viewModel: cellModel)
      return cell
    } else if let cellModel = cellModel as? BigButtonTableViewCellModel {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BigButtonTableViewCell.self)) as? BigButtonTableViewCell else { fatalError() }
      cell.setup(viewModel: cellModel)
      return cell
    } else if let cellModel = cellModel as? MapLocationTableViewCellModel {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MapLocationTableViewCell.self)) as? MapLocationTableViewCell else { fatalError() }
      cell.setup(viewModel: cellModel, delegate: self)
      return cell
    } else {
      fatalError()
    }
  }
}
