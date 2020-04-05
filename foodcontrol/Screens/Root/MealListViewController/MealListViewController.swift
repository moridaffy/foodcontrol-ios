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
  private weak var profileButtonTapRecognizer: UITapGestureRecognizer?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupNavigationBar()
    setupTableView()
    setupButton()
  }
  
  private func setupNavigationBar() {
    title = NSLocalizedString("Прием пищи", comment: "")
    
    let profileButton = UIBarButtonItem(image: UIImage(systemName: "person.circle.fill")?.withRenderingMode(.alwaysTemplate), style: .done, target: self, action: #selector(profileButtonTapped))
    profileButton.tintColor = UIColor.additionalYellow
    navigationItem.rightBarButtonItem = profileButton
  }
  
  private func setupTableView() {
    tableView.contentInset = UIEdgeInsets(top: -32.0, left: 0.0, bottom: 0.0, right: 0.0)
    tableView.tableFooterView = UIView()
    tableView.separatorStyle = .none
    tableView.register(UINib(nibName: "MealListHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: String(describing: MealListHeaderTableViewCell.self))
    tableView.register(UINib(nibName: "MealListDishTableViewCell", bundle: nil), forCellReuseIdentifier: String(describing: MealListDishTableViewCell.self))
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  private func setupButton() {
    addMealButtonContainerView.backgroundColor = UIColor.additionalYellow
    addMealButtonContainerView.layer.cornerRadius = 10.0
    addMealButtonContainerView.layer.masksToBounds = true
    addMealButtonTitleLabel.text = NSLocalizedString("Добавить прием пищи", comment: "")
    addMealButtonTitleLabel.textColor = UIColor.white
    addMealButtonTitleLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
    addMealButtonIconImageView.image = UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate)
    addMealButtonIconImageView.tintColor = UIColor.white
    
    let profileButtonTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(addMealButtonTapped))
    addMealButtonContainerView.addGestureRecognizer(profileButtonTapRecognizer)
    self.profileButtonTapRecognizer = profileButtonTapRecognizer
  }
  
  @objc private func profileButtonTapped() {
    
  }
  
  @objc private func addMealButtonTapped() {
    
  }
}

extension MealListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    let cellModel = viewModel.cellModels[indexPath.row]
    if cellModel is MealListHeaderTableViewCellModel {
      return 76.0
    } else if cellModel is MealListDishTableViewCellModel {
      return 58.0
    } else {
      return UITableView.automaticDimension
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let cellModel = viewModel.cellModels[indexPath.row]
    if cellModel is MealListHeaderTableViewCellModel {
      return 76.0
    } else if cellModel is MealListDishTableViewCellModel {
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
    if let cellModel = cellModel as? MealListHeaderTableViewCellModel {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MealListHeaderTableViewCell.self)) as? MealListHeaderTableViewCell else { fatalError() }
      cell.setup(viewModel: cellModel)
      return cell
    } else if let cellModel = cellModel as? MealListDishTableViewCellModel {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MealListDishTableViewCell.self)) as? MealListDishTableViewCell else { fatalError() }
      cell.setup(viewModel: cellModel)
      return cell
    } else {
      fatalError()
    }
  }
}
