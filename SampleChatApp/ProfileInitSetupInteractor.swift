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
    case noGenderEntered
    case noInterestedInGendersEntered
	case uploadAvatarFailure
	case changeProfileRequestFailure
}

struct InitialProfileParameters {
    let displayName: String?
    let gender: String?
    let age: Float
    let interestedInGenders: Set<String>
}

protocol ProfileInitSetupInteracting: AnyObject {
	func didSelectAvatarImage(image: UIImage)
	func didTapDone(profile: InitialProfileParameters, completion: @escaping (ProfileInitError?) -> Void)
    func didFinishUpdatingProfile()
}

final class ProfileInitSetupInteractor {
	private let presenter: ProfileInitSetupPresentable
	private let router: MainRouting?
	private let storageService: ProfileStorageServiceProtocol
	private let authenticationService: AuthenticationLogic
    private let userService: UserServiceProtocol
	private let user: User
    private var profileParameters: InitialProfileParameters?
    private let didCompleteProfile: () -> Void

	private var avatarImageData: Data?
	private var completion: ((ProfileInitError?) -> Void)?

	init(router: MainRouting?,
		 presenter: ProfileInitSetupPresentable,
		 storageService: ProfileStorageServiceProtocol,
		 authenticationService: AuthenticationLogic,
         userService: UserServiceProtocol,
		 user: User,
         completion: @escaping () -> Void) {
		self.router = router
		self.presenter = presenter
		self.storageService = storageService
		self.authenticationService = authenticationService
        self.userService = userService
		self.user = user
        self.didCompleteProfile = completion
	}
}

extension ProfileInitSetupInteractor: ProfileInitSetupInteracting {

	func didSelectAvatarImage(image: UIImage) {
		avatarImageData = image.compressedImageData(expectedSizeInKb: 512)
	}

	func didTapDone(profile: InitialProfileParameters, completion: @escaping (ProfileInitError?) -> Void) {
		guard let avatarImage = avatarImageData else {
			completion(.noAvatarImage)
			return
		}
        guard let displayName = profile.displayName, !displayName.isEmpty else {
			completion(.noDisplayNameEntered)
			return
        }

        self.profileParameters = profile
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

    func didFinishUpdatingProfile() {
        didCompleteProfile()
    }

	private func processProfileUpdate(error: Error?) {
		if error != nil, let completion = completion {
			completion(.changeProfileRequestFailure)
		} else {
			createUser()
		}
	}

    private func createUser() {
        guard let profileParams = profileParameters else {
            assertionFailure("ProfileParameters must be set")
            return
        }
        userService.createUser(user: user, profileParams: profileParams) { [unowned self] error in
            guard let completion = self.completion else {
                assertionFailure("Completion must be set")
                return
            }
            if error != nil {
                completion(.changeProfileRequestFailure)
            } else {
                completion(nil)
            }
        }
    }
}
