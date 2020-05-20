//
//  ProfileSetupViewController.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 11.05.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import UIKit

class ProfileSetupViewController: UIViewController {
  
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private var questionTitleLabels: [UILabel]!
  @IBOutlet private var questionButtons: [UIButton]!
  @IBOutlet private weak var weightTextField: UITextField!
  @IBOutlet private weak var weightPlanSelector: UISegmentedControl!
  @IBOutlet private weak var activitySelector: UISegmentedControl!
  @IBOutlet private weak var sexSelector: UISegmentedControl!
  @IBOutlet private weak var setupProfileButton: UIButton!
  @IBOutlet private weak var hideKeyboardButton: UIButton!
  
  private let viewModel = ProfileSetupViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupNavigationBar()
    setupLabels()
    setupButtons()
    setupSelectors()
  }
  
  private func setupNavigationBar() {
    navigationController?.navigationBar.isTranslucent = false
  }
  
  private func setupLabels() {
    titleLabel.text = NSLocalizedString("Расскажите о себе", comment: "")
    titleLabel.textColor = UIColor.label
    titleLabel.font = UIFont.systemFont(ofSize: 24.0, weight: .semibold)
  }
  
  private func setupButtons() {
    questionButtons.forEach { (button) in
      button.setTitle(nil, for: .normal)
      button.setImage(UIImage(systemName: "questionmark.circle.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
      button.tintColor = UIColor.additionalYellow
      button.imageView?.contentMode = .scaleAspectFit
      button.backgroundColor = .clear
    }
    
    setupProfileButton.setTitle(NSLocalizedString("Настроить профиль", comment: ""), for: .normal)
    setupProfileButton.backgroundColor = UIColor.additionalYellow
    setupProfileButton.layer.cornerRadius = 10.0
    setupProfileButton.layer.masksToBounds = true
    setupProfileButton.setTitleColor(UIColor.white, for: .normal)
    setupProfileButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
    
    hideKeyboardButton.setTitle(nil, for: .normal)
  }
  
  private func setupSelectors() {
    weightPlanSelector.removeAllSegments()
    weightPlanSelector.insertSegment(withTitle: User.WeightPlanType.gainWeight.title, at: 0, animated: false)
    weightPlanSelector.insertSegment(withTitle: User.WeightPlanType.keepWeight.title, at: 0, animated: false)
    weightPlanSelector.insertSegment(withTitle: User.WeightPlanType.loseWeight.title, at: 0, animated: false)
    weightPlanSelector.addTarget(self, action: #selector(selectorValueChanged(_:)), for: .valueChanged)
    
    activitySelector.removeAllSegments()
    activitySelector.insertSegment(withTitle: User.ActivityType.highActivity.title, at: 0, animated: false)
    activitySelector.insertSegment(withTitle: User.ActivityType.mediumActivity.title, at: 0, animated: false)
    activitySelector.insertSegment(withTitle: User.ActivityType.lowActivity.title, at: 0, animated: false)
    activitySelector.addTarget(self, action: #selector(selectorValueChanged(_:)), for: .valueChanged)
    
    sexSelector.removeAllSegments()
    sexSelector.insertSegment(withTitle: User.SexType.female.title, at: 0, animated: false)
    sexSelector.insertSegment(withTitle: User.SexType.male.title, at: 0, animated: false)
    sexSelector.addTarget(self, action: #selector(selectorValueChanged(_:)), for: .valueChanged)
  }
  
  @IBAction private func questionButtonTapped(_ button: UIButton) {
    guard let helpText = viewModel.getHelpText(for: button.tag) else { return }
    showAlert(title: NSLocalizedString("Помощь", comment: ""),
              body: helpText,
              button: "ОК",
              actions: nil)
  }
  
  @IBAction private func setupProfileButtonTapped() {
    tryToSetupProfile()
  }
  
  @IBAction private func hideKeyboardButtonTapped() {
    view.endEditing(true)
  }
  
  @objc private func selectorValueChanged(_ selector: UISegmentedControl) {
    if selector == weightPlanSelector {
      viewModel.selectedWeightPlan = User.WeightPlanType(rawValue: selector.selectedSegmentIndex + 1)
    } else if selector == activitySelector {
      viewModel.selectedActivity = User.ActivityType(rawValue: selector.selectedSegmentIndex + 1)
    } else if selector == sexSelector {
      viewModel.selectedSex = User.SexType(rawValue: selector.selectedSegmentIndex + 1)
    }
  }
  
  private func tryToSetupProfile() {
    guard let weight = Double((weightTextField.text ?? "").replacingOccurrences(of: ",", with: ".")) else {
      showAlertError(error: nil,
                     desc: NSLocalizedString("Укажите Ваш вес", comment: ""),
                     critical: false)
      return
    }
    guard let weightPlan = viewModel.selectedWeightPlan else {
      showAlertError(error: nil,
                     desc: NSLocalizedString("Выберите Ваш план питания", comment: ""),
                     critical: false)
      return
    }
    guard let activity = viewModel.selectedActivity else {
      showAlertError(error: nil,
                     desc: NSLocalizedString("Выберите Ваш уровень актвности", comment: ""),
                     critical: false)
      return
    }
    guard let sex = viewModel.selectedSex else {
      showAlertError(error: nil,
                     desc: NSLocalizedString("Выберите Ваш пол", comment: ""),
                     critical: false)
      return
    }
    
    viewModel.setupProfile(weightPlan: weightPlan, activity: activity, sex: sex, weight: weight) { [weak self] (error) in
      guard let error = error else { return }
      self?.showAlertError(error: error,
                           desc: NSLocalizedString("Не удалось настроить профиль", comment: ""),
                           critical: false)
    }
  }
}
