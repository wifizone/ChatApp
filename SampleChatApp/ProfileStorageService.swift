//
//  ProfileStorageService.swift
//  SampleChatApp
//
//  Created by Anton Poluianov on 25.07.2020.
//  Copyright © 2020 anton.poluianov. All rights reserved.
//

import FirebaseStorage
import FirebaseAuth

enum StorageError: Error {
	case failedToUploadAvatar
}

protocol ProfileStorageServiceProtocol: AnyObject {
	func store(avatarImage: Data, for user: User, completion: @escaping (Result<URL, StorageError>) -> Void)
}

final class ProfileStorageService: ProfileStorageServiceProtocol {

	let storage = Storage.storage()

	func store(avatarImage: Data, for user: User, completion: @escaping (Result<URL, StorageError>) -> Void) {
		let userId = user.uid
		let avatarRef = storage.reference().child("users/\(userId)/avatar.jpg")
		avatarRef.putData(avatarImage, metadata: nil) { (metadata, error) in
			guard metadata != nil else {
				completion(.failure(.failedToUploadAvatar))
				return
			}
			// You can also access to download URL after upload.
			avatarRef.downloadURL { (url, error) in
				guard let downloadURL = url else {
					completion(.failure(.failedToUploadAvatar))
					return
				}
				completion(.success(downloadURL))
			}
		}
	}
}
