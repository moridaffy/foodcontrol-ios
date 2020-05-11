//
//  RegisterViewController.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 11.05.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import UIKit

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
    
    // TODO: заменить на иконку VK
    vkAuthButton.setTitle("VK", for: .normal)
    vkAuthButton.setTitleColor(UIColor.white, for: .normal)
    vkAuthButton.layer.cornerRadius = 10.0
    vkAuthButton.layer.masksToBounds = true
    vkAuthButton.backgroundColor = UIColor.additionalVkBlue
  }
  
  @IBAction private func vkAuthButtonTapped() {
    
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
