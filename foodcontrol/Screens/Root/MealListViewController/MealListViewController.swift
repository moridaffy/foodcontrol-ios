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
  @IBOutlet private weak var placeholderLabel: UILabel!
  @IBOutlet private weak var addMealButtonContainerView: UIView!
  @IBOutlet private weak var addMealButtonTitleLabel: UILabel!
  @IBOutlet private weak var addMealButtonIconImageView: UIImageView!
  
  private let viewModel = MealListViewModel()
  private weak var activityIndicator: UIActivityIndicatorView?
  private weak var refresher: UIRefreshControl?
  private weak var addMealButtonTapRecognizer: UITapGestureRecognizer?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    viewModel.view = self
    placeholderLabel.isHidden = true
    
    setupNavigationBar()
    setupTableView()
    setupBottomButton()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    pulledToRefresh()
  }
  
  private func setupNavigationBar() {
    title = NSLocalizedString("Прием пищи", comment: "")
    
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    activityIndicator.startAnimating()
    let activityIndicatorItem = UIBarButtonItem(customView: activityIndicator)
    navigationItem.leftBarButtonItem = activityIndicatorItem
    self.activityIndicator = activityIndicator
    
    let userButton = UIBarButtonItem(image: UIImage(systemName: "person.circle.fill")?.withRenderingMode(.alwaysTemplate), style: .done, target: self, action: #selector(userButtonTapped))
    userButton.tintColor = UIColor.additionalYellow
    navigationItem.rightBarButtonItem = userButton
    
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
    
    let refresher = UIRefreshControl()
    refresher.addTarget(self, action: #selector(pulledToRefresh), for: .valueChanged)
    tableView.refreshControl = refresher
    self.refresher = refresher
    
    fadeImageView.image = UIImage(named: "fade_bottomToTop")
    fadeImageView.contentMode = .scaleToFill
  }
  
  private func setupBottomButton() {
    addMealButtonContainerView.backgroundColor = UIColor.additionalYellow
    addMealButtonContainerView.layer.cornerRadius = 10.0
    addMealButtonContainerView.layer.masksToBounds = true
    addMealButtonTitleLabel.text = AuthManager.shared.isAnonymous
      ? NSLocalizedString("Доступные блюда", comment: "")
      : NSLocalizedString("Добавить прием пищи", comment: "")
    addMealButtonTitleLabel.textColor = UIColor.white
    addMealButtonTitleLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
    addMealButtonIconImageView.image = UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate)
    addMealButtonIconImageView.tintColor = UIColor.white
    
    let addMealButtonTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(addMealButtonTapped))
    addMealButtonContainerView.addGestureRecognizer(addMealButtonTapRecognizer)
    self.addMealButtonTapRecognizer = addMealButtonTapRecognizer
  }
  
  @objc private func userButtonTapped() {
    if AuthManager.shared.isAnonymous {
      let loginAction = UIAlertAction(title: NSLocalizedString("Войти в аккаунт", comment: ""), style: .default) { (_) in
        DBManager.shared.deleteAll()
        AuthManager.shared.switchToAuthWorkflow()
      }
      showAlert(title: NSLocalizedString("Необходим вход", comment: ""),
                body: NSLocalizedString("Необходимо войти в аккаунт, чтобы просмотреть информацию о своем профиле и профиле своих друзей", comment: ""),
                button: NSLocalizedString("Отмена", comment: ""),
                actions: [loginAction])
    } else {
      guard let userViewController = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "UserViewController") as? UserViewController else { fatalError() }
      guard let user = AuthManager.shared.currentUser else { return }
      userViewController.setup(viewModel: UserViewModel(user: user, meals: viewModel.meals))
      navigationController?.pushViewController(userViewController, animated: true)
    }
  }
  
  @objc private func addMealButtonTapped() {
    if AuthManager.shared.isAnonymous {
      guard let addDishViewController = UIStoryboard(name: "Root", bundle: nil).instantiateViewController(withIdentifier: "AddDishViewController") as? AddDishViewController else { return }
      addDishViewController.setup(delegate: nil)
      navigationController?.pushViewController(addDishViewController, animated: true)
    } else {
      guard let createMealViewController = UIStoryboard(name: "Root", bundle: nil).instantiateViewController(withIdentifier: "CreateMealViewController") as? CreateMealViewController else { return }
      navigationController?.pushViewController(createMealViewController, animated: true)
    }
  }
  
  @objc private func pulledToRefresh() {
    viewModel.reloadMeals { [weak self] (error) in
      self?.refresher?.endRefreshing()
      if let error = error {
        self?.showAlertError(error: error,
                             desc: NSLocalizedString("Не удалось загрузить список приемов пищи", comment: ""),
                             critical: false)
      }
    }
  }
  
  private func openMealViewController(for meal: Meal) {
    guard let mealInfoViewController = UIStoryboard(name: "Root", bundle: nil).instantiateViewController(withIdentifier: "MealInfoViewController") as? MealInfoViewController else { fatalError() }
    mealInfoViewController.setup(viewModel: MealInfoViewModel(meal: meal))
    navigationController?.pushViewController(mealInfoViewController, animated: true)
  }
  
  private func openDishViewController(for dish: Dish) {
    guard let dishInfoViewController = UIStoryboard(name: "Root", bundle: nil).instantiateViewController(withIdentifier: "DishInfoViewController") as? DishInfoViewController else { return }
    dishInfoViewController.setup(viewModel: DishInfoViewModel(dish: dish), delegate: nil)
    navigationController?.pushViewController(dishInfoViewController, animated: true)
  }
  
  func reloadTableView() {
    tableView.reloadData()
    
    guard viewModel.cellModels.isEmpty else {
      placeholderLabel.isHidden = true
      return
    }
    
    placeholderLabel.isHidden = false
    placeholderLabel.text = AuthManager.shared.isAnonymous
      ? NSLocalizedString("Авторизуйтесь, чтобы добавлять начать добавлять свои приемы пищи и отслеживать их.", comment: "")
      : NSLocalizedString("У вас пока нет ни одного приема пищи. Самое время, чтобы его добавить?", comment: "")
  }
  
  func updateActivityIndicator(animating: Bool) {
    activityIndicator?.isHidden = !animating
  }
}

extension MealListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let cellModel = viewModel.cellModels[indexPath.row]
    if let cellModel = cellModel as? MealHeaderTableViewCellModel {
      openMealViewController(for: cellModel.meal)
    } else if let cellModel = cellModel as? DishTableViewCellModel {
      openDishViewController(for: cellModel.dish)
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
