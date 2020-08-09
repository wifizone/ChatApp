//
//  ProfileInitSetupViewController.swift
//  SampleChatApp
//
//  Created by Anton Poluianov on 28/06/2020.
//  Copyright © 2020 anton.poluianov. All rights reserved.
//

import UIKit

protocol ProfileInitSetupViewControllable: AnyObject {}

final class ProfileInitSetupViewController: UIViewController  {

	private let interactor: ProfileInitSetupInteracting

	private lazy var nameTextField: UITextField = {
		let field = UITextField(frame: .zero).disableMasks()
		field.autocapitalizationType = .none
		field.textAlignment = .center
		field.placeholder = "Your name"
		return field
	}()

	private var avatarButton: UIButton = {
		let button = UIButton().disableMasks()
		let image = UIImage(named: "user")
		button.setImage(image, for: .normal)
		button.addTarget(self, action: #selector(didTapAvatar), for: .touchUpInside)
		return button
	}()

	private var doneButton: UIButton = {
		let button = UIButton().disableMasks()
		button.setTitle("Done", for: .normal)
		button.setTitleColor(.systemBlue, for: .normal)
		button.addTarget(self, action: #selector(didTapDone), for: .touchUpInside)
		return button
	}()

	private let imagePicker = UIImagePickerController()

	init(interactor: ProfileInitSetupInteracting) {
		self.interactor = interactor
		super.init(nibName: nil, bundle: nil)
		imagePicker.delegate = self
	}

	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
		setupConstraints()
	}

	private func setupView() {
		view.backgroundColor = .white
		view.addSubviews([avatarButton, nameTextField, doneButton])
	}

	private func setupConstraints() {
		let topScreenSafeValue = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
		let bottomScreenSafeValue = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0

		NSLayoutConstraint.activate([
			avatarButton.topAnchor.constraint(equalTo: view.topAnchor, constant: topScreenSafeValue),
			avatarButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			avatarButton.heightAnchor.constraint(equalToConstant: 160),
			avatarButton.widthAnchor.constraint(equalToConstant: 160),

			nameTextField.topAnchor.constraint(equalTo: avatarButton.bottomAnchor, constant: 30),
			nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor),

			doneButton.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
			doneButton.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
			doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottomScreenSafeValue)
		])
	}

	@objc private func didTapAvatar() {
		imagePicker.allowsEditing = false
		imagePicker.sourceType = .photoLibrary
		present(imagePicker, animated: true)
	}

	@objc private func didTapDone() {
		interactor.didTapDone(displayName: nameTextField.text) { [unowned self] error in
			switch error {
			case .changeProfileRequestFailure, .uploadAvatarFailure:
				self.showAlert(for: "Error updating profile")
			case .noAvatarImage:
				self.showAlert(for: "Please upload avatar")
			case .noDisplayNameEntered:
				self.showAlert(for: "Please enter name")
			case .none:
				self.showAlert(for: "Success")
			}
		}
	}
}

extension ProfileInitSetupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController,
							   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		var newImage: UIImage
		
		if let possibleImage = info[.editedImage] as? UIImage {
			newImage = possibleImage
		} else if let possibleImage = info[.originalImage] as? UIImage {
			newImage = possibleImage
		} else {
			return
		}
		interactor.didSelectAvatarImage(image: newImage)
		print(newImage.size)
		dismiss(animated: true)
	}
}

extension ProfileInitSetupViewController: ProfileInitSetupViewControllable {}
