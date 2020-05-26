//
//  UserViewController.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 20.05.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
  
  @IBOutlet private weak var tableView: UITableView!
  @IBOutlet private weak var fadeImageView: UIImageView!
  @IBOutlet private weak var logoutButtonContainerView: UIView!
  @IBOutlet private weak var logoutButtonTitleLabel: UILabel!
  @IBOutlet private weak var logoutButtonIconImageView: UIImageView!
  
  private var viewModel: UserViewModel!
  private weak var logoutButtonTapRecognizer: UITapGestureRecognizer?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    viewModel.view = self
    
    setupTableView()
    setupBottomButton()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    setupNavigationBar()
  }
  
  func setup(viewModel: UserViewModel) {
    self.viewModel = viewModel
  }
  
  private func setupNavigationBar() {
    title = NSLocalizedString("Профиль", comment: "")
    
    if viewModel.isCurrentUser {
       let qrButton = UIBarButtonItem(image: UIImage(systemName: "qrcode")?.withRenderingMode(.alwaysTemplate), style: .done, target: self, action: #selector(qrButtonTapped))
       qrButton.tintColor = UIColor.additionalYellow
       navigationItem.rightBarButtonItem = qrButton
    } else {
      let buttonImage = UIImage(systemName: viewModel.isFollowingUser ? "xmark" : "plus")
      let addFriendButton = UIBarButtonItem(image: buttonImage?.withRenderingMode(.alwaysTemplate), style: .done, target: self, action: #selector(addFriendButtonTapped))
      addFriendButton.tintColor = UIColor.additionalYellow
      navigationItem.rightBarButtonItem = addFriendButton
    }
    
    let backButton = UIBarButtonItem(image: nil, style: .done, target: nil, action: nil)
    backButton.tintColor = UIColor.additionalYellow
    navigationItem.backBarButtonItem = backButton
  }
  
  private func setupTableView() {
    tableView.tableFooterView = UIView()
    tableView.separatorStyle = .none
    tableView.register(UINib(nibName: "InfoTextTableViewCell", bundle: nil), forCellReuseIdentifier: String(describing: InfoTextTableViewCell.self))
    tableView.delegate = self
    tableView.dataSource = self
    
    fadeImageView.image = UIImage(named: "fade_bottomToTop")
    fadeImageView.contentMode = .scaleToFill
  }
  
  private func setupBottomButton() {
    guard viewModel.user.id == AuthManager.shared.currentUser?.id else {
      logoutButtonContainerView.isHidden = true
      return
    }
    logoutButtonContainerView.isHidden = false
    
    logoutButtonContainerView.backgroundColor = UIColor.additionalRed
    logoutButtonContainerView.layer.cornerRadius = 10.0
    logoutButtonContainerView.layer.masksToBounds = true
    logoutButtonTitleLabel.text = NSLocalizedString("Выйти из аккаунта", comment: "")
    logoutButtonTitleLabel.textColor = UIColor.white
    logoutButtonTitleLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
    logoutButtonIconImageView.image = UIImage(systemName: "xmark")?.withRenderingMode(.alwaysTemplate)
    logoutButtonIconImageView.tintColor = UIColor.white
    
    let logoutButtonTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(logoutButtonTapped))
    logoutButtonContainerView.addGestureRecognizer(logoutButtonTapRecognizer)
    self.logoutButtonTapRecognizer = logoutButtonTapRecognizer
  }
  
  private func openUserListViewController() {
    guard let userListViewController = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "UserListViewController") as? UserListViewController else { fatalError() }
    userListViewController.setup(viewModel: UserListViewModel(rootUser: viewModel.user))
    navigationController?.pushViewController(userListViewController, animated: true)
  }
  
  private func openEatingQualityViewController() {
    guard !viewModel.meals.isEmpty else {
      showAlertError(error: nil,
                     desc: NSLocalizedString("Для отображения качества питания пользователя необходимо добавить хотя бы один прием пищи", comment: ""),
                     critical: false)
      return
    }
    guard let eatingQualityViewController = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "EatingQualityViewController") as? EatingQualityViewController else { fatalError() }
    eatingQualityViewController.setup(viewModel: EatingQualityViewModel(meals: viewModel.meals, dailyCalories: viewModel.user.dailyCaloryAmount))
    navigationController?.pushViewController(eatingQualityViewController, animated: true)
  }
  
  private func weightPlanCellTapped() {
    let actions: [UIAlertAction] = [
      UIAlertAction(title: User.WeightPlanType.loseWeight.title, style: .default, handler: { (_) in
        self.viewModel.updateUser(weightPlan: .loseWeight)
      }),
      UIAlertAction(title: User.WeightPlanType.keepWeight.title, style: .default, handler: { (_) in
        self.viewModel.updateUser(weightPlan: .keepWeight)
      }),
      UIAlertAction(title: User.WeightPlanType.gainWeight.title, style: .default, handler: { (_) in
        self.viewModel.updateUser(weightPlan: .gainWeight)
      })
    ]
    showAlert(title: NSLocalizedString("План питания", comment: ""),
              body: ProfileSetupViewModel().getHelpText(for: 2),
              button: NSLocalizedString("Отмена", comment: ""),
              actions: actions)
  }
  
  private func activityCellTapped() {
    let actions: [UIAlertAction] = [
      UIAlertAction(title: User.ActivityType.lowActivity.title, style: .default, handler: { (_) in
        self.viewModel.updateUser(activity: .lowActivity)
      }),
      UIAlertAction(title: User.ActivityType.mediumActivity.title, style: .default, handler: { (_) in
        self.viewModel.updateUser(activity: .mediumActivity)
      }),
      UIAlertAction(title: User.ActivityType.highActivity.title, style: .default, handler: { (_) in
        self.viewModel.updateUser(activity: .highActivity)
      })
    ]
    showAlert(title: NSLocalizedString("Уровень активности", comment: ""),
              body: ProfileSetupViewModel().getHelpText(for: 3),
              button: NSLocalizedString("Отмена", comment: ""),
              actions: actions)
  }
  
  private func sexCellTapped() {
    let actions: [UIAlertAction] = [
      UIAlertAction(title: User.SexType.female.title, style: .default, handler: { (_) in
        self.viewModel.updateUser(sex: .female)
      }),
      UIAlertAction(title: User.SexType.male.title, style: .default, handler: { (_) in
        self.viewModel.updateUser(sex: .male)
      })
    ]
    showAlert(title: NSLocalizedString("Пол", comment: ""),
              body: ProfileSetupViewModel().getHelpText(for: 4),
              button: NSLocalizedString("Отмена", comment: ""),
              actions: actions)
  }
  
  private func weightCellTapped() {
    let alert = UIAlertController(title: NSLocalizedString("Ваш вес", comment: ""),
                                  message: ProfileSetupViewModel().getHelpText(for: 1),
                                  preferredStyle: .alert)
    alert.addTextField { (textField) in
      textField.text = AuthManager.shared.currentUser?.weight.roundedString(to: 1, separator: ",")
      textField.keyboardType = .numbersAndPunctuation
    }
    alert.addAction(UIAlertAction(title: NSLocalizedString("Отмена", comment: ""), style: .cancel, handler: { (_) in
      alert.dismiss(animated: true, completion: nil)
    }))
    alert.addAction(UIAlertAction(title: NSLocalizedString("Сохранить", comment: ""), style: .default, handler: { (_) in
      var newWeight: Double?
      if var newWeightText = alert.textFields?.first?.text, !newWeightText.isEmpty {
        newWeightText = newWeightText.replacingOccurrences(of: ",", with: ".")
        if !newWeightText.contains(".") {
          newWeightText += ".0"
        }
        newWeight = Double(newWeightText)
      }
      
      guard newWeight != nil else {
        self.showAlertError(error: nil,
                            desc: NSLocalizedString("Введено некорректное значение веса", comment: ""),
                            critical: false)
        return
      }
      self.viewModel.updateUser(weight: newWeight)
    }))
    present(alert, animated: true, completion: nil)
  }
  
  @objc private func qrButtonTapped() {
    let userQrViewController = UserQrViewController(qrValue: viewModel.user.id)
    present(userQrViewController, animated: true, completion: nil)
  }
  
  @objc private func addFriendButtonTapped() {
    if viewModel.isFollowingUser {
      viewModel.removeFriend { [weak self] (error) in
        if let error = error {
          self?.showAlertError(error: error,
                               desc: NSLocalizedString("Не удалось удалить пользователя из друзей", comment: ""),
                               critical: false)
        } else {
          self?.showAlert(title: NSLocalizedString("Готово", comment: "") + "!",
                          body: NSLocalizedString("Пользователь удален из друзей", comment: ""),
                          button: "OK",
                          actions: nil)
        }
      }
    } else {
      viewModel.addFriend { [weak self] (error) in
        if let error = error {
          self?.showAlertError(error: error,
                               desc: NSLocalizedString("Не удалось добавить пользователя в друзья", comment: ""),
                               critical: false)
        } else {
          self?.showAlert(title: NSLocalizedString("Готово", comment: "") + "!",
                          body: NSLocalizedString("Пользователь добавлен в друзья", comment: ""),
                          button: "OK",
                          actions: nil)
        }
      }
    }
  }
  
  @objc private func logoutButtonTapped() {
    viewModel.logout()
  }
  
  func reloadTableView() {
    tableView.reloadData()
  }
}

extension UserViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    switch indexPath.row {
    case 2:
      weightPlanCellTapped()
    case 3:
      activityCellTapped()
    case 4:
      sexCellTapped()
    case 5:
      weightCellTapped()
    case 8:
      openEatingQualityViewController()
    case 9:
      openUserListViewController()
    default:
      break
    }
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return 57.0
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
}

extension UserViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // 0. username
    // 1. email
    // 2. weightPlan
    // 3. activity
    // 4. sex
    // 5. currentWeight
    // 6. total meals count
    // 7. dailyNorm
    // 8. statistics
    // 9. friends
    return 10
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: InfoTextTableViewCell.self)) as? InfoTextTableViewCell else { fatalError() }
    let user = viewModel.user
    
    switch indexPath.row {
    case 0:
      cell.setup(viewModel: InfoTextTableViewCellModel(type: .custom(NSLocalizedString("Никнейм", comment: "")), text: user.username))
    case 1:
      if user.isVkConnected {
        cell.setup(viewModel: InfoTextTableViewCellModel(type: .custom("ID VK"), text: user.vkId))
      } else {
        cell.setup(viewModel: InfoTextTableViewCellModel(type: .custom("Email"), text: user.email))
      }
    case 2:
      cell.setup(viewModel: InfoTextTableViewCellModel(type: .custom(NSLocalizedString("План питания", comment: "")), text: user.weightPlan.fullTitle))
    case 3:
      cell.setup(viewModel: InfoTextTableViewCellModel(type: .custom(NSLocalizedString("Уровень активности", comment: "")), text: user.activity.title))
    case 4:
      cell.setup(viewModel: InfoTextTableViewCellModel(type: .custom(NSLocalizedString("Пол", comment: "")), text: user.sex.title))
    case 5:
      cell.setup(viewModel: InfoTextTableViewCellModel(type: .custom(NSLocalizedString("Текущий вес", comment: "")), text: user.weight.roundedString(to: 1, separator: ",") + " кг"))
    case 6:
      cell.setup(viewModel: InfoTextTableViewCellModel(type: .custom(NSLocalizedString("Приемов пищи", comment: "")), text: "\(viewModel.meals.count)"))
    case 7:
      cell.setup(viewModel: InfoTextTableViewCellModel(type: .custom(NSLocalizedString("Дневная норма калорий", comment: "")), text: user.dailyCaloryAmount.roundedString(to: 1, separator: ",") + " ккал"))
    case 8:
      cell.setup(viewModel: InfoTextTableViewCellModel(type: .custom(NSLocalizedString("Качество питания", comment: "")), text: user.calculateWeekQuality(weekId: Date().weekId, meals: viewModel.meals)))
    case 9:
      cell.setup(viewModel: InfoTextTableViewCellModel(type: .custom(NSLocalizedString("Друзья", comment: "")), text: "\(user.friendIds.count)"))
      cell.selectionStyle = .default
    default:
      break
    }
    
    return cell
  }
}
