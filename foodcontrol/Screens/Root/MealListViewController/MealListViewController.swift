//
//  MealListViewController.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 05.04.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import UIKit

class MealListViewController: UIViewController {
  
  @IBOutlet private weak var tableView: UITableView!
  @IBOutlet private weak var fadeImageView: UIImageView!
  @IBOutlet private weak var addMealButtonContainerView: UIView!
  @IBOutlet private weak var addMealButtonTitleLabel: UILabel!
  @IBOutlet private weak var addMealButtonIconImageView: UIImageView!
  
  private let viewModel = MealListViewModel()
  private weak var addMealButtonTapRecognizer: UITapGestureRecognizer?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupNavigationBar()
    setupTableView()
    setupBottomButton()
  }
  
  private func setupNavigationBar() {
    title = NSLocalizedString("Прием пищи", comment: "")
    
    let profileButton = UIBarButtonItem(image: UIImage(systemName: "person.circle.fill")?.withRenderingMode(.alwaysTemplate), style: .done, target: self, action: #selector(profileButtonTapped))
    profileButton.tintColor = UIColor.additionalYellow
    navigationItem.rightBarButtonItem = profileButton
    
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
    tableView.delegate = self
    tableView.dataSource = self
    
    fadeImageView.image = UIImage(named: "fade_bottomToTop")
    fadeImageView.contentMode = .scaleToFill
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
    
    let addMealButtonTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(addMealButtonTapped))
    addMealButtonContainerView.addGestureRecognizer(addMealButtonTapRecognizer)
    self.addMealButtonTapRecognizer = addMealButtonTapRecognizer
  }
  
  @objc private func profileButtonTapped() {
    
  }
  
  @objc private func addMealButtonTapped() {
    guard let createMealViewController = UIStoryboard(name: "Root", bundle: nil).instantiateViewController(withIdentifier: "CreateMealViewController") as? CreateMealViewController else { return }
    navigationController?.pushViewController(createMealViewController, animated: true)
  }
  
  private func openMealViewController() {
    
  }
  
  private func openDishViewController() {
    guard let dishInfoViewController = UIStoryboard(name: "Root", bundle: nil).instantiateViewController(withIdentifier: "DishInfoViewController") as? DishInfoViewController else { return }
    dishInfoViewController.setup(viewModel: DishInfoViewModel(), delegate: nil)
    navigationController?.pushViewController(dishInfoViewController, animated: true)
  }
}

extension MealListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let cellModel = viewModel.cellModels[indexPath.row]
    if let cellModel = cellModel as? MealHeaderTableViewCellModel {
      openMealViewController()
    } else if let cellModel = cellModel as? DishTableViewCellModel {
      openDishViewController()
    }
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    let cellModel = viewModel.cellModels[indexPath.row]
    if cellModel is MealHeaderTableViewCellModel {
      return 76.0
    } else if cellModel is DishTableViewCellModel {
      return 58.0
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
    } else {
      return UITableView.automaticDimension
    }
  }
}

extension MealListViewController: UITableViewDataSource {
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
    } else {
      fatalError()
    }
  }
}
