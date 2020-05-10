//
//  DishInfoViewController.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 27.04.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import UIKit

protocol DishInfoViewControllerDelegate: class {
  func didAddToMeal(dish: Dish)
}

class DishInfoViewController: UIViewController {
  
  @IBOutlet private weak var tableView: UITableView!
  @IBOutlet private weak var tableViewBottomConstraint: NSLayoutConstraint!
  @IBOutlet private weak var fadeImageView: UIImageView!
  @IBOutlet private weak var addToMealButtonContainerView: UIView!
  @IBOutlet private weak var addToMealButtonTitleLabel: UILabel!
  @IBOutlet private weak var addToMealButtonIconImageView: UIImageView!
  
  private var viewModel: DishInfoViewModel!
  private weak var delegate: DishInfoViewControllerDelegate?
  private weak var addToMealButtonTapRecognizer: UITapGestureRecognizer?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupTableView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    viewModel.view = self
    
    setupNavigationBar()
    setupBottomButton()
  }
  
  func setup(viewModel: DishInfoViewModel, delegate: DishInfoViewControllerDelegate?) {
    self.viewModel = viewModel
    self.delegate = delegate
  }
  
  private func setupNavigationBar() {
    title = viewModel.dish.name
    
    let favoriteButton = UIBarButtonItem(image: UIImage(systemName: "star")?.withRenderingMode(.alwaysTemplate),
                                         style: .plain,
                                         target: self,
                                         action: #selector(favoriteButtonTapped))
    navigationItem.rightBarButtonItem = favoriteButton
  }
  
  private func setupTableView() {
    tableView.tableFooterView = UIView()
    tableView.separatorStyle = .none
    tableView.register(UINib(nibName: "BigImageTableViewCell", bundle: nil), forCellReuseIdentifier: String(describing: BigImageTableViewCell.self))
    tableView.register(UINib(nibName: "InfoTextTableViewCell", bundle: nil), forCellReuseIdentifier: String(describing: InfoTextTableViewCell.self))
    tableView.register(UINib(nibName: "InfoNutritionTableViewCell", bundle: nil), forCellReuseIdentifier: String(describing: InfoNutritionTableViewCell.self))
    tableView.delegate = self
    tableView.dataSource = self
    
    fadeImageView.image = UIImage(named: "fade_bottomToTop")
    fadeImageView.contentMode = .scaleToFill
  }
  
  private func setupBottomButton() {
    guard delegate != nil else {
      tableViewBottomConstraint.constant = 16.0
      addToMealButtonContainerView.isHidden = true
      return
    }
    tableViewBottomConstraint.constant = 82.0
    
    addToMealButtonContainerView.backgroundColor = UIColor.additionalYellow
    addToMealButtonContainerView.layer.cornerRadius = 10.0
    addToMealButtonContainerView.layer.masksToBounds = true
    addToMealButtonTitleLabel.text = NSLocalizedString("Добавить прием пищи", comment: "")
    addToMealButtonTitleLabel.textColor = UIColor.white
    addToMealButtonTitleLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
    addToMealButtonIconImageView.image = UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate)
    addToMealButtonIconImageView.tintColor = UIColor.white
    
    let addToMealButtonTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(addToMealButtonTapped))
    addToMealButtonContainerView.addGestureRecognizer(addToMealButtonTapRecognizer)
    self.addToMealButtonTapRecognizer = addToMealButtonTapRecognizer
  }
  
  @objc private func favoriteButtonTapped() {
    
  }
  
  @objc private func addToMealButtonTapped() {
    delegate?.didAddToMeal(dish: viewModel.dish)
  }
  
  func reloadTableView() {
    tableView.reloadData()
  }
}

extension DishInfoViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    let cellModel = viewModel.cellModels[indexPath.row]
    if cellModel is BigImageTableViewCellModel {
      return 190.0
    } else if cellModel is InfoTextTableViewCellModel {
      return 47.0
    } else if cellModel is InfoNutritionTableViewCellModel {
      return 126.0
    } else {
      return UITableView.automaticDimension
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let cellModel = viewModel.cellModels[indexPath.row]
    if cellModel is BigImageTableViewCellModel {
      return 190.0
    } else if cellModel is InfoTextTableViewCellModel {
      return UITableView.automaticDimension
    } else if cellModel is InfoNutritionTableViewCellModel {
      return 126.0
    } else {
      return UITableView.automaticDimension
    }
  }
}

extension DishInfoViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.cellModels.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellModel = viewModel.cellModels[indexPath.row]
    if let cellModel = cellModel as? BigImageTableViewCellModel {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BigImageTableViewCell.self)) as? BigImageTableViewCell else { fatalError() }
      cell.setup(viewModel: cellModel)
      return cell
    } else if let cellModel = cellModel as? InfoTextTableViewCellModel {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: InfoTextTableViewCell.self)) as? InfoTextTableViewCell else { fatalError() }
      cell.setup(viewModel: cellModel)
      return cell
    } else if let cellModel = cellModel as? InfoNutritionTableViewCellModel {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: InfoNutritionTableViewCell.self)) as? InfoNutritionTableViewCell else { fatalError() }
      cell.setup(viewModel: cellModel)
      return cell
    } else {
      return UITableViewCell()
    }
  }
}
