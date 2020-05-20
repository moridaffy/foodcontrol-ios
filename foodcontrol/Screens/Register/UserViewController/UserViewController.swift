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
    
    setupNavigationBar()
    setupTableView()
    setupBottomButton()
  }
  
  func setup(viewModel: UserViewModel) {
    self.viewModel = viewModel
  }
  
  private func setupNavigationBar() {
    title = NSLocalizedString("Прием пищи", comment: "")
    
    let qrButton = UIBarButtonItem(image: UIImage(systemName: "qrcode")?.withRenderingMode(.alwaysTemplate), style: .done, target: self, action: #selector(qrButtonTapped))
    qrButton.tintColor = UIColor.additionalYellow
    navigationItem.rightBarButtonItem = qrButton
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
  
  @objc private func qrButtonTapped() {
    // TODO
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
    // TODO
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
    // 1. username
    // 2. email
    // 3. weightPlan
    // 4. activity
    // 5. sex
    // 6. currentWeight
    // 7. total meals count
    // 8. dailyNorm
    // 9. statistics
    // 10. friends
    return 9
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: InfoTextTableViewCell.self)) as? InfoTextTableViewCell else { fatalError() }
    let user = viewModel.user
    
    switch indexPath.row {
    case 0:
      cell.setup(viewModel: InfoTextTableViewCellModel(type: .custom(NSLocalizedString("Никнейм", comment: "")), text: user.username))
    case 1:
      cell.setup(viewModel: InfoTextTableViewCellModel(type: .custom("Email"), text: user.email))
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
    default:
      break
    }
    
    return cell
  }
}
