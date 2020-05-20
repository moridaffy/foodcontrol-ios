//
//  UserListViewController.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 20.05.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import UIKit

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
    tableView.contentInset = UIEdgeInsets(top: -32.0, left: 0.0, bottom: 0.0, right: 0.0)
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
    // TODO
  }
  
  @objc private func addFriendButtonTapped() {
    // TODO: открытие сканнера qr кодов
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
