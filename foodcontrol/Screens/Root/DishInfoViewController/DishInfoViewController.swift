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
    guard !viewModel.creatingNewDish else {
      title = NSLocalizedString("Новое блюдо", comment: "")
      return
    }
    
    title = viewModel.dish.name
    let favoriteButton = UIBarButtonItem(image: UIImage(systemName: "star")?.withRenderingMode(.alwaysTemplate),
                                         style: .plain,
                                         target: self,
                                         action: #selector(favoriteButtonTapped))
    favoriteButton.tintColor = UIColor.additionalYellow
    navigationItem.rightBarButtonItem = favoriteButton
  }
  
  private func setupTableView() {
    tableView.tableFooterView = UIView()
    tableView.separatorStyle = .none
    tableView.contentInset = UIEdgeInsets(top: 12.0, left: 0.0, bottom: 0.0, right: 0.0)
    tableView.keyboardDismissMode = .interactive
    tableView.register(UINib(nibName: "BigImageTableViewCell", bundle: nil), forCellReuseIdentifier: String(describing: BigImageTableViewCell.self))
    tableView.register(UINib(nibName: "BigButtonTableViewCell", bundle: nil), forCellReuseIdentifier: String(describing: BigButtonTableViewCell.self))
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
    addToMealButtonTitleLabel.textColor = UIColor.white
    addToMealButtonTitleLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
    addToMealButtonIconImageView.image = UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate)
    addToMealButtonIconImageView.tintColor = UIColor.white
    addToMealButtonTitleLabel.text = viewModel.creatingNewDish
      ? NSLocalizedString("Создать блюдо", comment: "")
      : NSLocalizedString("Добавить блюдо", comment: "")
    
    let addToMealButtonTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(addToMealButtonTapped))
    addToMealButtonContainerView.addGestureRecognizer(addToMealButtonTapRecognizer)
    self.addToMealButtonTapRecognizer = addToMealButtonTapRecognizer
  }
  
  @objc private func favoriteButtonTapped() {
    // TODO:
  }
  
  @objc private func addToMealButtonTapped() {
    guard checkIfCanSaveDish() else { return }
    if viewModel.creatingNewDish {
      viewModel.createDish { [weak self] (dish, error) in
        if let dish = dish {
          self?.requestWeightEntry(for: dish)
        } else {
          self?.showAlertError(error: error,
                               desc: NSLocalizedString("Не удалось создать блюдо", comment: ""),
                               critical: false)
        }
      }
    } else {
      requestWeightEntry(for: viewModel.dish)
    }
  }
  
  private func checkIfCanSaveDish() -> Bool {
    guard viewModel.creatingNewDish else { return true }
    let dish = viewModel.dish
    
    if dish.name.isEmpty {
      showAlertError(error: nil,
                     desc: NSLocalizedString("Заполните имя блюда", comment: ""),
                     critical: false)
      return false
    } else if !dish.isNutritionInfoFilled {
      showAlertError(error: nil,
                     desc: NSLocalizedString("Заполните информацию о питательной ценности блюда", comment: ""),
                     critical: false)
      return false
    }
    guard !dish.name.isEmpty else {
      showAlertError(error: nil,
                     desc: NSLocalizedString("Заполните имя блюда", comment: ""),
                     critical: false)
      return false
    }
    return true
  }
  
  private func requestWeightEntry(for dish: Dish) {
    let alert = UIAlertController(title: NSLocalizedString("Размер", comment: ""),
                                  message: NSLocalizedString("Пожалуйста, укажите примерный размер порции (г)", comment: ""),
                                  preferredStyle: .alert)
    alert.addTextField { (textField) in
      textField.placeholder = "100"
      textField.keyboardType = .numberPad
    }
    alert.addAction(UIAlertAction(title: "Готово", style: .default, handler: { (_) in
      guard let weightTextValue = alert.textFields?.first?.text else { return }
      if let weightDouble = Double(weightTextValue) {
        dish.weight = weightDouble
        self.dismissViewController(addedDish: dish)
      } else if let weightInt = Int(weightTextValue) {
        dish.weight = Double(weightInt)
        self.dismissViewController(addedDish: dish)
      } else {
        self.showAlertError(error: nil,
                            desc: NSLocalizedString("Введено некорректное значение", comment: ""),
                            critical: false)
      }
    }))
    alert.addAction(UIAlertAction(title: NSLocalizedString("Отмена", comment: ""), style: .cancel, handler: { (_) in
      alert.dismiss(animated: true, completion: nil)
    }))
    present(alert, animated: true, completion: nil)
  }
  
  private func dismissViewController(addedDish dish: Dish) {
    guard let delegate = delegate else { fatalError() }
    delegate.didAddToMeal(dish: dish)
    if let mealViewController = navigationController?.viewControllers.first(where: { $0 is CreateMealViewController }) {
      navigationController?.popToViewController(mealViewController, animated: true)
    } else {
      navigationController?.popViewController(animated: true)
    }
  }
  
  private func presentImagePickerSheet() {
    let actionSheet = UIAlertController(title: NSLocalizedString("Добавить фото блюда", comment: ""),
                                        message: nil,
                                        preferredStyle: .actionSheet)
    actionSheet.addAction(UIAlertAction(title: NSLocalizedString("Фотопленка", comment: ""), style: .default, handler: { (_) in
      self.presentImagePicker(source: .photoLibrary)
    }))
    actionSheet.addAction(UIAlertAction(title: NSLocalizedString("Камера", comment: ""), style: .default, handler: { (_) in
      self.presentImagePicker(source: .camera)
    }))
    actionSheet.addAction(UIAlertAction(title: NSLocalizedString("Отмена", comment: ""), style: .cancel, handler: { (_) in
      actionSheet.dismiss(animated: true, completion: nil)
    }))
    present(actionSheet, animated: true, completion: nil)
  }
  
  private func presentImagePicker(source: UIImagePickerController.SourceType) {
    let imagePicker = UIImagePickerController()
    imagePicker.sourceType = source
    imagePicker.delegate = self
    present(imagePicker, animated: true, completion: nil)
  }
  
  func reloadTableView() {
    tableView.reloadData()
  }
}

extension DishInfoViewController: InfoTextTableViewCellDelegate {
  func textValueChanged(_ value: String, type: InfoTextTableViewCellModel.InfoType) {
    tableView.beginUpdates()
    switch type {
    case .title:
      viewModel.dish.name = value
    case .description:
      viewModel.dish.description = value
    default:
      break
    }
    tableView.endUpdates()
  }
}

extension DishInfoViewController: InfoNutritionTableViewCellDelegate {
  func didChangeNutritionValue(_ value: String, type: InfoNutritionTableViewCell.TextFieldType) {
    guard let intValue = Int(value) else { return }
    let referenceValue = Double(intValue) / 100.0
    switch type {
    case .proteins:
      viewModel.dish.proteinsReference = referenceValue
    case .fats:
      viewModel.dish.fatsReference = referenceValue
    case .carbohydrates:
      viewModel.dish.carbohydratesReference = referenceValue
    case .calories:
      viewModel.dish.calories = referenceValue
    }
  }
}

extension DishInfoViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    picker.dismiss(animated: true, completion: nil)
    guard let image = info[.originalImage] as? UIImage,
      let resizedImage = image.correctImageOrientation().resizeWithScaleAspectFitMode(to: 1024.0) else {
        showAlertError(error: nil,
                       desc: NSLocalizedString("Не удалось обработать выбранное изображение. Пожалуйста, попробуйте выбрать другое", comment: ""),
                       critical: false)
        return
    }
    
    viewModel.dish.image = resizedImage
    viewModel.reloadCellModels()
  }
}

extension DishInfoViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    let cellModel = viewModel.cellModels[indexPath.row]
    if cellModel is BigImageTableViewCellModel {
      return 190.0
    } else if cellModel is BigButtonTableViewCellModel {
      return 190.0
    } else if cellModel is InfoTextTableViewCellModel {
      return 57.0
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
    } else if cellModel is BigButtonTableViewCellModel {
      return 190.0
    } else if cellModel is InfoTextTableViewCellModel {
      return UITableView.automaticDimension
    } else if cellModel is InfoNutritionTableViewCellModel {
      return 126.0
    } else {
      return UITableView.automaticDimension
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let cellModel = viewModel.cellModels[indexPath.row]
    if let cellModel = cellModel as? BigButtonTableViewCellModel {
      if cellModel.type == .addImage {
        presentImagePickerSheet()
      }
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
    } else if let cellModel = cellModel as? BigButtonTableViewCellModel {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BigButtonTableViewCell.self)) as? BigButtonTableViewCell else { fatalError() }
      cell.setup(viewModel: cellModel)
      return cell
    } else if let cellModel = cellModel as? InfoTextTableViewCellModel {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: InfoTextTableViewCell.self)) as? InfoTextTableViewCell else { fatalError() }
      cell.setup(viewModel: cellModel, delegate: self)
      return cell
    } else if let cellModel = cellModel as? InfoNutritionTableViewCellModel {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: InfoNutritionTableViewCell.self)) as? InfoNutritionTableViewCell else { fatalError() }
      cell.setup(viewModel: cellModel, delegate: self)
      return cell
    } else {
      return UITableViewCell()
    }
  }
}
