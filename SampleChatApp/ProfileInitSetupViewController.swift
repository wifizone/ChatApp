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

    private let stackView: UIStackView = {
        let stack = UIStackView().disableMasks()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 30
        stack.alignment = .center
        return stack
    }()

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
        button.imageView?.disableMasks()
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

    private let interestedInView = ChooseInterestedInView(interests: ["Men", "Women", "Other"]).disableMasks()
    private let genderView = ChoiceGenderView(genders: ["Male", "Female"]).disableMasks()
    private let choiceAgeView = ChoiceAgeView().disableMasks()

	private let imagePicker = UIImagePickerController()
    private let activityIndicator = UIActivityIndicatorView()

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
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
		view.backgroundColor = .white
        [avatarButton, nameTextField, genderView, choiceAgeView, interestedInView, doneButton].forEach({ stackView.addArrangedSubview($0) })
		view.addSubviews([stackView, activityIndicator])
	}

	private func setupConstraints() {
		let topScreenSafeValue = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
        guard let imageView = avatarButton.imageView else { return }
		NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: topScreenSafeValue),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            imageView.heightAnchor.constraint(equalToConstant: 160),
            imageView.widthAnchor.constraint(equalToConstant: 160),
            avatarButton.heightAnchor.constraint(equalToConstant: 160),

            choiceAgeView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 2 * 20)
		])
	}

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

	@objc private func didTapAvatar() {
		imagePicker.allowsEditing = false
		imagePicker.sourceType = .photoLibrary
		present(imagePicker, animated: true)
	}

	@objc private func didTapDone() {
        activityIndicator.startAnimating()
        let profile = InitialProfileParameters(displayName: nameTextField.text,
                                               gender: genderView.selectedGender.popFirst(),
                                               age: choiceAgeView.age,
                                               interestedInGenders: interestedInView.selectedInterests)
        interactor.didTapDone(profile: profile) { [unowned self] error in
            self.activityIndicator.stopAnimating()
			switch error {
			case .changeProfileRequestFailure, .uploadAvatarFailure:
				self.showAlert(for: "Error updating profile")
			case .noAvatarImage:
				self.showAlert(for: "Please upload avatar")
			case .noDisplayNameEntered:
				self.showAlert(for: "Please enter name")
            case .noGenderEntered:
                break
            case .noInterestedInGendersEntered:
                break
			case .none:
                self.showAlert(for: "Success") { [unowned self] _ in
                    DispatchQueue.main.async {
                        self.interactor.didFinishUpdatingProfile()
                    }
                }
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
        avatarButton.setImage(newImage, for: .normal)
		print(newImage.size)
		dismiss(animated: true)
	}
}

extension ProfileInitSetupViewController: ProfileInitSetupViewControllable {}
