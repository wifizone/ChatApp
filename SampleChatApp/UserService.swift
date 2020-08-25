//
//  UserService.swift
//  SampleChatApp
//
//  Created by Антон Полуянов on 09.08.2020.
//  Copyright © 2020 anton.poluianov. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

enum UserServiceError: Error {
    case creatingUser
    case userNotFound
    case userExists
    case retrievingUser
    case noId
}

protocol UserServiceProtocol: AnyObject {
    func createUser(user: User, completion: @escaping (UserServiceError?) -> Void)
    func getUserProfile(id: String, completion: @escaping (Result<UserInfo, UserServiceError>) -> Void)
    func getUserProfiles(ids: [String], completion: @escaping (Result<[UserInfo], UserServiceError>) -> Void)
}

final class UserService: UserServiceProtocol {

    private static let profileUploadedKey = "profileUploaded"

    private var usersCollection = Firestore.firestore().collection("User")

    static func isNameAndPhotoUploaded() -> Bool {
        return (UserDefaults.standard.value(forKey: Self.profileUploadedKey) as? Bool) ?? false
    }

    static func makeNameAndPhotoUploaded() {
        return UserDefaults.standard.set(true, forKey: Self.profileUploadedKey)
    }

    func createUser(user: User, completion: @escaping (UserServiceError?) -> Void) {
//        getProfile(user: user) { [unowned self] error in
//            switch error {
//            case let .some(error):
//                if error == .some(.userNotFound) {
//                    let data: [String: String?] = [
//                        "id": user.uid,
//                        "displayName": user.displayName,
//                        "photoURL" : user.photoURL?.absoluteString
//                    ]
//                    self.usersCollection.addDocument(data: data as [String: Any]) { error in
//                        guard error != nil else {
//                            completion(.creatingUser)
//                            return
//                        }
//                        Self.makeNameAndPhotoUploaded()
//                        completion(nil)
//                    }
//                } else {
//                    completion(.creatingUser)
//                }
//            case .none:
//                completion(.userExists)
//            }
//        }
        let data: [String: String?] = [
            "id": user.uid,
            "displayName": user.displayName,
            "photoURL" : user.photoURL?.absoluteString
        ]
        self.usersCollection.addDocument(data: data as [String: Any]) { error in
            guard error == nil else {
                completion(.creatingUser)
                return
            }
            Self.makeNameAndPhotoUploaded()
            completion(nil)
        }
    }

    func getUserProfile(id: String, completion: @escaping (Result<UserInfo, UserServiceError>) -> Void) {
        let usersQuery = usersCollection.whereField("id", arrayContains: id)
        usersQuery.getDocuments { (snapshot, error) in
            guard error == nil else {
                completion(.failure(.retrievingUser))
                return
            }
            guard let documents = snapshot?.documents, !documents.isEmpty else {
                completion(.failure(.userNotFound))
                return
            }
            guard let userInfo = UserInfo(userData: documents.first?.data()) else {
                completion(.failure(.noId))
                return
            }
            completion(.success(userInfo))
        }
    }

    func getUserProfiles(ids: [String], completion: @escaping (Result<[UserInfo], UserServiceError>) -> Void) {
        let usersQuery = usersCollection.whereField("id", in: ids)
        usersQuery.getDocuments { (snapshot, error) in
            guard error == nil else {
                completion(.failure(.retrievingUser))
                return
            }
            guard let documents = snapshot?.documents, !documents.isEmpty else {
                completion(.failure(.userNotFound))
                return
            }
            var users = [UserInfo]()
            for document in documents {
                if let user = UserInfo(userData: document.data()) {
                    users.append(user)
                }
            }
            completion(.success(users))
        }
    }

    private func getProfile(user: User, completion: @escaping (UserServiceError?) -> Void) {
        getUserProfile(id: user.uid) { (result) in
            switch result {
            case .success:
                completion(nil)
            case let .failure(error):
                completion(error)
            }
        }
    }
}
