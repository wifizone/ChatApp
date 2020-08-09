//
//  LoginViewController.swift
//  SampleChatApp
//
//  Created by Anton Poluianov on 19/06/2020.
//  Copyright © 2020 anton.poluianov. All rights reserved.
//

import UIKit

protocol LoginViewControllable: AnyObject {
	func showUpdate(update: Result<LoginViewModel.Registration, LoginViewModel.RegistrationError>)
	func showUpdate(update: Result<LoginViewModel.Login, LoginViewModel.LoginError>)
}

final class LoginViewController: UIViewController {

	enum SegmentState: Int {
		case login = 0
		case registration
	}

	private let interactor: LoginInteracting
	private let validationService: UserInputValidatorProtocol

	private var segmentState: SegmentState = .login {
		didSet {
			if segmentState == .login {
				signInUpButton.setTitle("Login", for: .normal)
			} else {
				signInUpButton.setTitle("Register", for: .normal)
			}
		}
	}

	private lazy var segmented: UISegmentedControl = {
		let items = ["Login", "Registration"]
		let segments = UISegmentedControl(items: items).disableMasks()
		segments.selectedSegmentIndex = 0
		segments.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
		return segments
	}()

	private lazy var emailTextField: UITextField = {
		let field = UITextField(frame: .zero).disableMasks()
		field.autocapitalizationType = .none
		field.textAlignment = .left
		field.placeholder = "Email"
		return field
	}()

	private lazy var passwordTextField: UITextField = {
		let field = UITextField(frame: .zero).disableMasks()
		field.textAlignment = .left
		field.isSecureTextEntry = true
		field.placeholder = "Password"
		return field
	}()

	private lazy var stackView: UIStackView = {
		let stack = UIStackView().disableMasks()
		stack.axis = .vertical
		stack.alignment = .leading
		stack.distribution = .fillProportionally
		stack.spacing = 6
		return stack
	}()

	private lazy var signInUpButton: UIButton = {
		let button = UIButton(frame: .zero).disableMasks()
		button.setTitle("Login", for: .normal)
		button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
		button.setTitleColor(.black, for: .normal)
		return button
	}()

	init(interactor: LoginInteracting) {
		self.validationService = UserInputValidator()
		self.interactor = interactor
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
		setupConstraints()
	}

	@objc private func segmentChanged(sender: UISegmentedControl) {
		switch sender.selectedSegmentIndex {
		case SegmentState.login.rawValue:
			segmentState = .login
		case SegmentState.registration.rawValue:
			segmentState = .registration
		default:
			break
		}
	}

	@objc private func buttonTapped() {
		if segmentState == .registration {
			interactor.didTapRegister(email: emailTextField.text, password: passwordTextField.text)
		} else {
			interactor.didTapLogin(email: emailTextField.text, password: passwordTextField.text)
		}
	}

	private func setupView() {
		view.backgroundColor = UIColor.white
		stackView.addArrangedSubviews([segmented, emailTextField, passwordTextField, signInUpButton])
		view.addSubview(stackView)
	}
	
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
			stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
		])
	}
}

extension LoginViewController: LoginViewControllable {

	func showUpdate(update: Result<LoginViewModel.Registration, LoginViewModel.RegistrationError>) {
		switch(update) {
		case .success:
			showAlert(for: "Registration successful")
		case let .failure(error):
			switch error {
			case let .error(message: message):
				showAlert(for: message)
			}
		}
	}

	func showUpdate(update: Result<LoginViewModel.Login, LoginViewModel.LoginError>) {
		switch(update) {
		case let .success(user):
			showAlert(for: "Login success") { [weak self] _ in
				self?.interactor.didFinishLogin(user: user.user)
			}
		case let .failure(error):
			switch error {
			case let .error(message: message):
				showAlert(for: message)
			}
		}
	}
}

