//
//  ChatService.swift
//  SampleChatApp
//
//  Created by Anton Poluianov on 02.08.2020.
//  Copyright © 2020 anton.poluianov. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

enum ChatServiceError: Error {
	case retrievingChats
	case noChats
}

protocol ChatServiceProtocol: AnyObject {
	func getChatUsers(of user: User, completion: @escaping (Result<ChatsWithUsersResponse.Chats, ChatServiceError>) -> Void)
}

final class ChatService: ChatServiceProtocol {

	private var chatsCollection = Firestore.firestore().collection("Chats")

	func getChatUsers(of user: User, completion: @escaping (Result<ChatsWithUsersResponse.Chats, ChatServiceError>) -> Void) {
		let userChatsQuery = chatsCollection.whereField("users", arrayContains: user.uid)
		userChatsQuery.getDocuments { [unowned self] (snapshot, error) in
			guard error == nil else {
				completion(.failure(.retrievingChats))
				return
			}
			guard let documents = snapshot?.documents else {
				completion(.failure(.noChats))
				return
			}
            
		}
	}
}
