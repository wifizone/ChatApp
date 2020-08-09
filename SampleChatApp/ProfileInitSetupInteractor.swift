//
//  ProfileInitSetupInteractor.swift
//  SampleChatApp
//
//  Created by Anton Poluianov on 28/06/2020.
//  Copyright © 2020 anton.poluianov. All rights reserved.
//

import Foundation
import FirebaseAuth

enum ProfileInitError: Error {
	case noAvatarImage
	case noDisplayNameEntered
	case uploadAvatarFailure
	case changeProfileRequestFailure
}

protocol ProfileInitSetupInteracting: AnyObject {
	func didSelectAvatarImage(image: UIImage)
	func didTapDone(displayName: String?, completion: @escaping (ProfileInitError?) -> Void)
}

final class ProfileInitSetupInteractor {
	private let presenter: ProfileInitSetupPresentable
	private let router: LoginRouting?
	private let storageService: ProfileStorageServiceProtocol
	private let authenticationService: AuthenticationLogic
	private let user: User

	private var avatarImageData: Data?
	private var completion: ((ProfileInitError?) -> Void)?

	init(router: LoginRouting?,
		 presenter: ProfileInitSetupPresentable,
		 storageService: ProfileStorageServiceProtocol,
		 authenticationService: AuthenticationLogic,
		 user: User) {
		self.router = router
		self.presenter = presenter
		self.storageService = storageService
		self.authenticationService = authenticationService
		self.user = user
	}
}

extension ProfileInitSetupInteractor: ProfileInitSetupInteracting {

	func didSelectAvatarImage(image: UIImage) {
		avatarImageData = image.compressedImageData(expectedSizeInKb: 512)
	}

	func didTapDone(displayName: String?, completion: @escaping (ProfileInitError?) -> Void) {
		guard let avatarImage = avatarImageData else {
			completion(.noAvatarImage)
			return
		}
		guard let displayName = displayName, displayName.count != 0 else {
			completion(.noDisplayNameEntered)
			return
		}
		storageService.store(avatarImage: avatarImage,
							 for: user) { [unowned self] resultImageURL in
								switch resultImageURL {
								case let .success(imageURL):
									self.completion = completion
									self.authenticationService.updateUser(name: displayName,
																		   photoURL: imageURL,
																		   completion: self.processProfileUpdate)
									break
								case .failure:
									completion(.uploadAvatarFailure)
								}
		}
	}

	private func processProfileUpdate(error: Error?) {
		if error != nil, let completion = completion {
			completion(.changeProfileRequestFailure)
		} else {
			completion?(nil)
		}
	}
}
