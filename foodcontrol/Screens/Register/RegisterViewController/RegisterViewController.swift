//
//  RegisterViewController.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 11.05.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import UIKit
import SwiftyVK

class RegisterViewController: UIViewController {
  
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var usernameTextField: UITextField!
  @IBOutlet private weak var emailTextField: UITextField!
  @IBOutlet private weak var passwordTextField: UITextField!
  @IBOutlet private weak var repeatPasswordTextField: UITextField!
  @IBOutlet private weak var vkAuthButton: UIButton!
  @IBOutlet private weak var registerButton: UIButton!
  
  private let viewModel = RegisterViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupLabels()
    setupTextFields()
    setupButtons()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    VKManager.shared.delegate = self
  }
  
  private func setupLabels() {
    titleLabel.text = NSLocalizedString("Зарегистрироваться", comment: "")
    titleLabel.textColor = UIColor.label
    titleLabel.font = UIFont.systemFont(ofSize: 24.0, weight: .semibold)
  }
  
  private func setupTextFields() {
    usernameTextField.placeholder = NSLocalizedString("Ваш никнейм", comment: "")
    emailTextField.placeholder = NSLocalizedString("Ваш email", comment: "")
    passwordTextField.placeholder = NSLocalizedString("Ваш пароль", comment: "")
    repeatPasswordTextField.placeholder = NSLocalizedString("Повторите пароль", comment: "")
    
    [usernameTextField, emailTextField, passwordTextField, repeatPasswordTextField].forEach { (textField) in
      textField?.delegate = self
      textField?.borderStyle = .none
      textField?.layer.cornerRadius = 4.0
      textField?.layer.borderColor = UIColor.placeholderText.cgColor
      textField?.layer.borderWidth = 1.0
      textField?.setLeftPaddingPoints(8.0)
      textField?.setRightPaddingPoints(8.0)
    }
  }
  
  private func setupButtons() {
    registerButton.setTitle(NSLocalizedString("Создать аккаунт", comment: ""), for: .normal)
    registerButton.backgroundColor = UIColor.additionalYellow
    registerButton.layer.cornerRadius = 10.0
    registerButton.layer.masksToBounds = true
    registerButton.setTitleColor(UIColor.white, for: .normal)
    registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
    
    vkAuthButton.setTitle(nil, for: .normal)
    vkAuthButton.setImage(UIImage(named: "vkcom")?.withRenderingMode(.alwaysOriginal), for: .normal)
    vkAuthButton.contentHorizontalAlignment = .fill
    vkAuthButton.contentVerticalAlignment = .fill
    vkAuthButton.layer.cornerRadius = 10.0
    vkAuthButton.layer.masksToBounds = true
    vkAuthButton.backgroundColor = UIColor.additionalVkBlue
  }
  
  private func authorizeUsingVk(userId: String) {
    let alert = UIAlertController(title: NSLocalizedString("Готово", comment: "") + "!",
                                  message: NSLocalizedString("Осталось лишь указать Ваш никнейм", comment: ""),
                                  preferredStyle: .alert)
    alert.addTextField { (textField) in
      textField.keyboardType = .asciiCapable
      textField.placeholder = "best_username"
    }
    alert.addAction(UIAlertAction(title: NSLocalizedString("Зарегистрироваться", comment: ""), style: .default, handler: { (_) in
      guard let username = alert.textFields?.first?.text, username.isValidUsername() else {
        self.showAlertError(error: nil,
                            desc: NSLocalizedString("Введенный никнейм некорректный", comment: ""), critical: false)
        self.authorizeUsingVk(userId: userId)
        return
      }
      
      self.viewModel.register(username: username, email: "\(userId)@vkauth.ru", password: userId) { [weak self] (success, error) in
        guard !success else { return }
        self?.showAlertError(error: error,
                             desc: NSLocalizedString("Не удалось зарегистрироваться", comment: ""),
                             critical: false)
      }
    }))
    alert.addAction(UIAlertAction(title: NSLocalizedString("Отмена", comment: ""), style: .cancel, handler: { (_) in
      alert.dismiss(animated: true, completion: nil)
    }))
    present(alert, animated: true, completion: nil)
  }
  
  @IBAction private func vkAuthButtonTapped() {
    VKManager.shared.login { [weak self] (userId, error) in
      if let userId = userId {
        self?.authorizeUsingVk(userId: userId)
      } else {
        self?.showAlertError(error: error,
                             desc: NSLocalizedString("Не удалось авторизоваться через ВК", comment: ""),
                             critical: false)
      }
    }
  }
  
  @IBAction private func registerButtonTapped() {
    tryToRegister()
  }
  
  private func tryToRegister() {
    guard let usernameValue = usernameTextField.text, usernameValue.isValidUsername() else {
      showAlertError(error: nil,
                     desc: NSLocalizedString("Введен невалидный никнейм", comment: ""),
                     critical: false)
      return
    }
    guard let emailValue = emailTextField.text, emailValue.isValidEmail() else {
      showAlertError(error: nil,
                     desc: NSLocalizedString("Введен невалидный email", comment: ""),
                     critical: false)
      return
    }
    guard let passwordValue = passwordTextField.text, passwordValue.isValidPassword() else {
      showAlertError(error: nil,
                     desc: NSLocalizedString("Введен невалидный пароль", comment: ""),
                     critical: false)
      return
    }
    guard passwordValue == repeatPasswordTextField.text else {
      showAlertError(error: nil,
                     desc: NSLocalizedString("Введенные пароли не совпадают", comment: ""),
                     critical: false)
      return
    }
    
    viewModel.register(username: usernameValue, email: emailValue, password: passwordValue) { [weak self] (success, error) in
      guard !success else { return }
      self?.showAlertError(error: error,
                           desc: NSLocalizedString("Не удалось зарегистрироваться", comment: ""),
                           critical: false)
    }
  }
}

extension RegisterViewController: VKManagerDelegate {
  func presentVkViewController(_ viewController: VKViewController) {
    DispatchQueue.main.async {
      self.present(viewController, animated: true, completion: nil)
    }
  }
}

extension RegisterViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == usernameTextField {
      emailTextField.becomeFirstResponder()
    } else if textField == emailTextField {
      passwordTextField.becomeFirstResponder()
    } else if textField == passwordTextField {
      repeatPasswordTextField.becomeFirstResponder()
    } else {
      view.endEditing(true)
    }
    return false
  }
}
