//
//  LoginViewController.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 11.05.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
  
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var emailTextField: UITextField!
  @IBOutlet private weak var passwordTextField: UITextField!
  @IBOutlet private weak var vkAuthButton: UIButton!
  @IBOutlet private weak var loginButton: UIButton!
  @IBOutlet private weak var registerButton: UIButton!
  
  private let viewModel = LoginViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupLabels()
    setupTextFields()
    setupButtons()
  }
  
  private func setupLabels() {
    titleLabel.text = NSLocalizedString("Войти", comment: "")
    titleLabel.textColor = UIColor.label
    titleLabel.font = UIFont.systemFont(ofSize: 24.0, weight: .semibold)
  }
  
  private func setupTextFields() {
    emailTextField.placeholder = NSLocalizedString("Ваш email", comment: "")
    passwordTextField.placeholder = NSLocalizedString("Ваш пароль", comment: "")
    
    [emailTextField, passwordTextField].forEach { (textField) in
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
    loginButton.setTitle(NSLocalizedString("Войти в аккаунт", comment: ""), for: .normal)
    registerButton.setTitle(NSLocalizedString("Зарегистрироваться", comment: ""), for: .normal)
    
    [loginButton, registerButton].forEach { (button) in
      button?.backgroundColor = UIColor.additionalYellow
      button?.layer.cornerRadius = 10.0
      button?.layer.masksToBounds = true
      button?.setTitleColor(UIColor.white, for: .normal)
      button?.titleLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
    }
    
    // TODO: заменить на иконку VK
    vkAuthButton.setTitle("VK", for: .normal)
    vkAuthButton.setTitleColor(UIColor.white, for: .normal)
    vkAuthButton.layer.cornerRadius = 10.0
    vkAuthButton.layer.masksToBounds = true
    vkAuthButton.backgroundColor = UIColor.additionalVkBlue
  }
  
  @IBAction private func vkAuthButtonTapped() {
    
  }
  
  @IBAction private func loginButtonTapped() {
    tryToLogin()
  }
  
  @IBAction private func registerButtonTapped() {
    guard let registerViewController = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController else { fatalError() }
    navigationController?.pushViewController(registerViewController, animated: true)
  }
  
  private func tryToLogin() {
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
    
    viewModel.login(email: emailValue, password: passwordValue) { [weak self] (success, error) in
      guard !success else { return }
      self?.showAlertError(error: error,
                           desc: NSLocalizedString("Не удалось войти в аккаунт", comment: ""),
                           critical: false)
    }
  }
}

extension LoginViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == emailTextField {
      passwordTextField.becomeFirstResponder()
    } else {
      view.endEditing(true)
    }
    return false
  }
}
