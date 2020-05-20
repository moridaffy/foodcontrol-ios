//
//  UserListViewController.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 20.05.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import UIKit
import BarcodeScanner

class UserListViewController: UIViewController {
  
  @IBOutlet private weak var tableView: UITableView!
  @IBOutlet private weak var fadeImageView: UIImageView!
  @IBOutlet private weak var addFriendButtonContainerView: UIView!
  @IBOutlet private weak var addFriendButtonTitleLabel: UILabel!
  @IBOutlet private weak var addFriendButtonIconImageView: UIImageView!
  
  private var viewModel: UserListViewModel!
  private weak var refresher: UIRefreshControl?
  private weak var addFriendButtonTapRecognizer: UITapGestureRecognizer?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    viewModel.view = self
    
    setupNavigationBar()
    setupTableView()
    setupBottomButton()
  }
  
  func setup(viewModel: UserListViewModel) {
    self.viewModel = viewModel
  }
  
  private func setupNavigationBar() {
    title = NSLocalizedString("Друзья", comment: "")
    
    let backButton = UIBarButtonItem(image: nil, style: .done, target: nil, action: nil)
    backButton.tintColor = UIColor.additionalYellow
    navigationItem.backBarButtonItem = backButton
  }
  
  private func setupTableView() {
    tableView.tableFooterView = UIView()
    tableView.separatorStyle = .none
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
    addFriendButtonContainerView.backgroundColor = UIColor.additionalYellow
    addFriendButtonContainerView.layer.cornerRadius = 10.0
    addFriendButtonContainerView.layer.masksToBounds = true
    addFriendButtonTitleLabel.text = NSLocalizedString("Добавить друга", comment: "")
    addFriendButtonTitleLabel.textColor = UIColor.white
    addFriendButtonTitleLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
    addFriendButtonIconImageView.image = UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate)
    addFriendButtonIconImageView.tintColor = UIColor.white
    
    let addFriendButtonTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(addFriendButtonTapped))
    addFriendButtonContainerView.addGestureRecognizer(addFriendButtonTapRecognizer)
    self.addFriendButtonTapRecognizer = addFriendButtonTapRecognizer
  }
  
  @objc private func pulledToRefresh() {
    viewModel.reloadUsers { [weak self] (error) in
      self?.refresher?.endRefreshing()
      guard let error = error else { return }
      self?.showAlertError(error: error,
                           desc: NSLocalizedString("Не удалось загрузить список друзей", comment: ""),
                           critical: false)
    }
  }
  
  @objc private func addFriendButtonTapped() {
    presentQrCodeScanner()
  }
  
  private func presentQrCodeScanner() {
    let scannerViewController = BarcodeScannerViewController()
    scannerViewController.codeDelegate = self
    scannerViewController.errorDelegate = self
    scannerViewController.dismissalDelegate = self

    present(scannerViewController, animated: true, completion: nil)
  }
  
  private func scannedUserId(_ userId: String) {
    viewModel.findUser(withId: userId) { [weak self] (user, error) in
      if let user = user {
        self?.openUserViewController(for: user)
      } else {
        self?.showAlertError(error: error,
                             desc: NSLocalizedString("Не удалось найти пользователя", comment: ""),
                             critical: false)
      }
    }
  }
  
  private func openUserViewController(for user: User) {
    guard let userViewController = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "UserViewController") as? UserViewController else { fatalError() }
    userViewController.setup(viewModel: UserViewModel(user: user))
    navigationController?.pushViewController(userViewController, animated: true)
  }
  
  func reloadTableView() {
    tableView.reloadData()
  }
}

extension UserListViewController: BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate {
  func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
    controller.dismiss(animated: true) { [weak self] in
      self?.scannedUserId(code)
    }
  }
  
  func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
    controller.dismiss(animated: true) { [weak self] in
      self?.showAlertError(error: error,
                           desc: NSLocalizedString("Не удалось сканировать код", comment: ""),
                           critical: false)
    }
  }
  
  func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
    controller.dismiss(animated: true, completion: nil)
  }
}

extension UserListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    openUserViewController(for: viewModel.users[indexPath.row])
  }
}

extension UserListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.users.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else { fatalError() }
    cell.textLabel?.text = viewModel.users[indexPath.row].username
    return cell
  }
}
