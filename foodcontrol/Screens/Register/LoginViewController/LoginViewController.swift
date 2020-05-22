//
//  LoginViewController.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 11.05.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import UIKit
import SwiftyVK

class LoginViewController: UIViewController {
  
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var emailTextField: UITextField!
  @IBOutlet private weak var passwordTextField: UITextField!
  @IBOutlet private weak var vkAuthButton: UIButton!
  @IBOutlet private weak var loginButton: UIButton!
  @IBOutlet private weak var skipAuthButton: UIButton!
  @IBOutlet private weak var registerButton: UIButton!
  
  private let viewModel = LoginViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupNavigationBar()
    setupLabels()
    setupTextFields()
    setupButtons()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    VKManager.shared.delegate = self
  }
  
  private func setupNavigationBar() {
    navigationController?.navigationBar.isTranslucent = false
    
    let backButton = UIBarButtonItem(image: nil, style: .done, target: nil, action: nil)
    backButton.tintColor = UIColor.additionalYellow
    navigationItem.backBarButtonItem = backButton
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
    skipAuthButton.setTitle(NSLocalizedString("Пропустить авторизацию", comment: ""), for: .normal)
    registerButton.setTitle(NSLocalizedString("Зарегистрироваться", comment: ""), for: .normal)
    
    [loginButton, registerButton].forEach { (button) in
      button?.backgroundColor = UIColor.additionalYellow
      button?.layer.cornerRadius = 10.0
      button?.layer.masksToBounds = true
      button?.setTitleColor(UIColor.white, for: .normal)
      button?.titleLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
    }
    
    skipAuthButton.setTitleColor(UIColor.black.withAlphaComponent(0.5), for: .normal)
    skipAuthButton.titleLabel?.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
    
    vkAuthButton.setTitle(nil, for: .normal)
    vkAuthButton.setImage(UIImage(named: "vkcom")?.withRenderingMode(.alwaysOriginal), for: .normal)
    vkAuthButton.contentHorizontalAlignment = .fill
    vkAuthButton.contentVerticalAlignment = .fill
    vkAuthButton.layer.cornerRadius = 10.0
    vkAuthButton.layer.masksToBounds = true
    vkAuthButton.backgroundColor = UIColor.additionalVkBlue
  }
  
  private func authorizeUsingVk(userId: String) {
    viewModel.login(email: "\(userId)@vkauth.ru", password: userId) { [weak self] (success, error) in
      guard !success else { return }
      self?.showAlertError(error: error,
                           desc: NSLocalizedString("Не удалось войти в аккаунт", comment: ""),
                           critical: false)
    }
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
  
  @IBAction private func loginButtonTapped() {
    tryToLogin()
  }
  
  @IBAction private func skipAuthButtonTapped() {
    viewModel.skipAuthorization { [weak self] (success, error) in
      guard !success else { return }
      self?.showAlertError(error: error,
                           desc: NSLocalizedString("Не удалось пропустить авторизацию", comment: ""),
                           critical: false)
    }
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

extension LoginViewController: VKManagerDelegate {
  func presentVkViewController(_ viewController: VKViewController) {
    present(viewController, animated: true, completion: nil)
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
