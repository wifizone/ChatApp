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
    case retrievingUser
    case profileNotComplete
    case noId
}

protocol UserServiceProtocol: AnyObject {
    func createUser(user: User, completion: @escaping (UserServiceError?) -> Void)
    func createUser(user: User, profileParams: InitialProfileParameters, completion: @escaping (UserServiceError?) -> Void)
    func getUserProfile(id: String, completion: @escaping (Result<UserInfo, UserServiceError>) -> Void)
    func getUserProfiles(ids: [String], completion: @escaping (Result<[UserInfo], UserServiceError>) -> Void)
    func isUserProfileFull(user: User, completion: @escaping (Result<Bool, UserServiceError>) -> Void)
}

final class UserService: UserServiceProtocol {

    private static let idField = "id"
    private static let nameField = "displayName"
    private static let photoURLField = "photoURL"
    private static let genderField = "gender"
    private static let ageField = "age"
    private static let partnerInterestsField = "partnerInterests"
    private static let isCompleteProfileField = "isComplete"

    private var usersCollection = Firestore.firestore().collection("User")

    func createUser(user: User, completion: @escaping (UserServiceError?) -> Void) {
        let data: [String: Any] = [
            Self.idField: user.uid,
            Self.nameField: user.displayName as Any,
            Self.photoURLField : user.photoURL?.absoluteString as Any,
            Self.isCompleteProfileField : true
        ]
        self.usersCollection.addDocument(data: data) { error in
            guard error == nil else {
                completion(.creatingUser)
                return
            }
            completion(nil)
        }
    }

    func createUser(user: User, profileParams: InitialProfileParameters, completion: @escaping (UserServiceError?) -> Void) {
        let data: [String: Any] = [
            Self.idField: user.uid,
            Self.nameField: profileParams.displayName as Any,
            Self.genderField: profileParams.gender as Any,
            Self.ageField: profileParams.age as Any,
            Self.partnerInterestsField: Array(profileParams.interestedInGenders) as Any,
            Self.photoURLField : user.photoURL?.absoluteString as Any,
            Self.isCompleteProfileField : true
        ]
        self.usersCollection.addDocument(data: data) { error in
            guard error == nil else {
                completion(.creatingUser)
                return
            }
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

    func isUserProfileFull(user: User, completion: @escaping (Result<Bool, UserServiceError>) -> Void) {
        let usersQuery = usersCollection
            .whereField(Self.idField, isEqualTo: user.uid)
            .whereField(Self.isCompleteProfileField, isEqualTo: true)
        usersQuery.getDocuments(completion: { (snapshot, error) in
            guard error == nil else {
                completion(.failure(.profileNotComplete))
                return
            }
            guard let documents = snapshot?.documents, !documents.isEmpty else {
                completion(.failure(.profileNotComplete))
                return
            }
            if !documents.isEmpty {
                completion(.success(true))
            } else {
                completion(.success(false))
            }
        })
    }
}
