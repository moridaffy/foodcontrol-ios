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
    
    viewModel.view = self
    title = NSLocalizedString("Качество питания", comment: "")
    
    setupTableView()
    setupButtons()
    updateWeekSelector()
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
  
  private func updateWeekSelector() {
    if let currentWeekId = viewModel.currentWeekId {
      currentWeekLabel.text = NSLocalizedString("Неделя", comment: "") + ":\n" + currentWeekId
    } else {
      currentWeekLabel.text = ""
    }
    
    let previousWeekAvailable = viewModel.getPreviousWeekId() != nil
    previousWeekButton.isUserInteractionEnabled = previousWeekAvailable
    previousWeekButton.alpha = previousWeekAvailable ? 1.0 : 0.5
    let nextWeekAvailable = viewModel.getNextWeekId() != nil
    nextWeekButton.isUserInteractionEnabled = nextWeekAvailable
    nextWeekButton.alpha = nextWeekAvailable ? 1.0 : 0.5
  }
  
  @IBAction private func previousWeekButtonTapped() {
    viewModel.switchToPreviousWeek()
  }
  
  @IBAction private func nextWeekButtonTapped() {
    viewModel.switchToNextWeek()
  }
  
  func reloadTableView() {
    tableView.reloadData()
    updateWeekSelector()
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
