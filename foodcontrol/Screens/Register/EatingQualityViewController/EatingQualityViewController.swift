//
//  EatingQualityViewController.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 22.05.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import UIKit

class EatingQualityViewController: UIViewController {
  
  @IBOutlet private weak var tableView: UITableView!
  @IBOutlet private weak var currentWeekLabel: UILabel!
  @IBOutlet private weak var previousWeekButton: UIButton!
  @IBOutlet private weak var nextWeekButton: UIButton!
  
  private var viewModel: EatingQualityViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    currentWeekLabel.text = ""
    title = NSLocalizedString("Качество питания", comment: "")
    
    setupTableView()
    setupButtons()
  }
  
  func setup(viewModel: EatingQualityViewModel) {
    self.viewModel = viewModel
  }
  
  private func setupTableView() {
    tableView.tableFooterView = UIView()
    tableView.separatorStyle = .none
    tableView.register(UINib(nibName: "InfoTextTableViewCell", bundle: nil), forCellReuseIdentifier: String(describing: InfoTextTableViewCell.self))
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  private func setupButtons() {
    for button in [previousWeekButton, nextWeekButton] {
      button?.backgroundColor = UIColor.additionalYellow
      button?.layer.cornerRadius = 25.0
      button?.layer.masksToBounds = true
      button?.setTitle(nil, for: .normal)
      button?.tintColor = UIColor.white
    }
    previousWeekButton.setImage(UIImage(systemName: "arrow.left")?.withRenderingMode(.alwaysTemplate),
                                for: .normal)
    nextWeekButton.setImage(UIImage(systemName: "arrow.right")?.withRenderingMode(.alwaysTemplate),
                            for: .normal)
  }
  
  @IBAction private func previousWeekButtonTapped() {
    viewModel.switchToPreviousWeek()
  }
  
  @IBAction private func nextWeekButtonTapped() {
    viewModel.switchToNextWeek()
  }
  
  func reloadTableView() {
    currentWeekLabel.text = viewModel.currentWeekId ?? ""
    tableView.reloadData()
  }
  
}

extension EatingQualityViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

extension EatingQualityViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.displayedDays.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: InfoTextTableViewCell.self)) as? InfoTextTableViewCell else { fatalError() }
    let displayedDay = viewModel.displayedDays[indexPath.row]
    cell.setup(viewModel: InfoTextTableViewCellModel(type: .custom(displayedDay.date),
                                                     text: displayedDay.value,
                                                     valueColor: displayedDay.goodCalories ? UIColor.additionalGreen : UIColor.additionalRed))
    return cell
  }
}
