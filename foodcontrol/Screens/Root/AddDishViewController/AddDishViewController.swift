//
//  AddDishViewController.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 20.04.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import UIKit

protocol AddDishViewControllerDelegate: class {
  func didAddDish(_ dish: String)
}

class AddDishViewController: UIViewController {
  
  @IBOutlet private weak var searchContainerView: UIView!
  @IBOutlet private weak var searchIconImageView: UIImageView!
  @IBOutlet private weak var searchTextField: UITextField!
  @IBOutlet private weak var sortingContainerView: UIView!
  @IBOutlet private weak var sortingIconImageView: UIImageView!
  @IBOutlet private weak var sortingButton: UIButton!
  @IBOutlet private weak var tableView: UITableView!
  
  private let viewModel = AddDishViewModel()
  weak var delegate: AddDishViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupNavigationBar()
    setupSearchSortBar()
    setupTableView()
  }
  
  private func setupNavigationBar() {
    title = NSLocalizedString("Список блюд", comment: "")
  }
  
  private func setupSearchSortBar() {
    searchContainerView.backgroundColor = UIColor.additionalGrayLight
    searchContainerView.layer.cornerRadius = 8.0
    searchContainerView.layer.masksToBounds = true
    searchIconImageView.image = UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate)
    searchIconImageView.tintColor = UIColor.additionalGrayDark
    searchTextField.placeholder = NSLocalizedString("Поиск", comment: "")
    searchTextField.textColor = UIColor.additionalGrayDark
    searchTextField.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
    searchTextField.backgroundColor = UIColor.clear
    searchTextField.delegate = self
    searchTextField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
    
    sortingContainerView.backgroundColor = UIColor.additionalGrayLight
    sortingContainerView.layer.cornerRadius = 8.0
    sortingContainerView.layer.masksToBounds = true
    sortingIconImageView.image = UIImage(systemName: "arrow.up.arrow.down")?.withRenderingMode(.alwaysTemplate)
    sortingIconImageView.tintColor = UIColor.additionalGrayDark
    sortingButton.setTitleColor(UIColor.additionalGrayDark, for: .normal)
    sortingButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
    sortingButton.setTitle(viewModel.sortingType.title, for: .normal)
  }
  
  private func setupTableView() {
    tableView.tableFooterView = UIView()
    tableView.separatorStyle = .none
    tableView.register(UINib(nibName: "DishTableViewCell", bundle: nil), forCellReuseIdentifier: String(describing: DishTableViewCell.self))
    tableView.register(UINib(nibName: "BigButtonTableViewCell", bundle: nil), forCellReuseIdentifier: String(describing: BigButtonTableViewCell.self))
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  private func openDishViewController(for dish: Dish) {
    guard let dishInfoViewController = UIStoryboard(name: "Root", bundle: nil).instantiateViewController(withIdentifier: "DishInfoViewController") as? DishInfoViewController else { return }
    dishInfoViewController.setup(viewModel: DishInfoViewModel(dish: dish), delegate: self)
    navigationController?.pushViewController(dishInfoViewController, animated: true)
  }
  
  @IBAction private func sortingButtonTapped() {
    let actionSheet = UIAlertController(title: NSLocalizedString("Сортировка", comment: ""),
                                        message: NSLocalizedString("Выберите способ сортировки блюд", comment: ""),
                                        preferredStyle: .actionSheet)
    actionSheet.addAction(UIAlertAction(title: AddDishViewModel.SortingType.calloriesAsc.title, style: .default, handler: { [weak self] (_) in
      self?.viewModel.sortingType = .calloriesAsc
    }))
    actionSheet.addAction(UIAlertAction(title: AddDishViewModel.SortingType.calloriesDesc.title, style: .default, handler: { [weak self] (_) in
      self?.viewModel.sortingType = .calloriesDesc
    }))
    actionSheet.addAction(UIAlertAction(title: AddDishViewModel.SortingType.nameAsc.title, style: .default, handler: { [weak self] (_) in
      self?.viewModel.sortingType = .nameAsc
    }))
    actionSheet.addAction(UIAlertAction(title: AddDishViewModel.SortingType.nameDesc.title, style: .default, handler: { [weak self] (_) in
      self?.viewModel.sortingType = .nameDesc
    }))
    actionSheet.addAction(UIAlertAction(title: NSLocalizedString("Отмена", comment: ""), style: .cancel, handler: { (_) in
      actionSheet.dismiss(animated: true, completion: nil)
    }))
    present(actionSheet, animated: true, completion: nil)
  }
  
  @objc private func textFieldEditingChanged() {
    viewModel.searchQuery = searchTextField.text ?? ""
  }
  
  func reloadTableView() {
    sortingButton.setTitle(viewModel.sortingType.title, for: .normal)
    tableView.reloadData()
  }
}

extension AddDishViewController: DishInfoViewControllerDelegate {
  func didAddToMeal(dish: Dish) {
    // TODO: добавление этого блюда в прием пищи
  }
}

extension AddDishViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let cellModel = viewModel.cellModels[indexPath.row]
    if let cellModel = cellModel as? DishTableViewCellModel {
      openDishViewController(for: cellModel.dish)
    }
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    let cellModel = viewModel.cellModels[indexPath.row]
    if cellModel is DishTableViewCellModel {
      return 58.0
    } else if let cellModel = cellModel as? BigButtonTableViewCellModel {
      return CGFloat(cellModel.type.height)
    } else {
      return UITableView.automaticDimension
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let cellModel = viewModel.cellModels[indexPath.row]
    if cellModel is DishTableViewCellModel {
      return UITableView.automaticDimension
    } else if let cellModel = cellModel as? BigButtonTableViewCellModel {
      return CGFloat(cellModel.type.height)
    } else {
      return UITableView.automaticDimension
    }
  }
}

extension AddDishViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.cellModels.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellModel = viewModel.cellModels[indexPath.row]
    if let cellModel = cellModel as? DishTableViewCellModel {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DishTableViewCell.self)) as? DishTableViewCell else { fatalError() }
      cell.setup(viewModel: cellModel)
      return cell
    } else if let cellModel = cellModel as? BigButtonTableViewCellModel {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BigButtonTableViewCell.self)) as? BigButtonTableViewCell else { fatalError() }
      cell.setup(viewModel: cellModel)
      return cell
    } else {
      fatalError()
    }
  }
}

extension AddDishViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.endEditing(true)
    return false
  }
}
