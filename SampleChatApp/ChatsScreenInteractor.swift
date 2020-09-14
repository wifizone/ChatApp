//
//  ChatsScreenInteractor.swift
//  SampleChatApp
//
//  Created by Антон Полуянов on 16.07.2020.
//  Copyright © 2020 anton.poluianov. All rights reserved.
//

import Foundation
import FirebaseAuth

protocol ChatsScreenInteracting: AnyObject {
    func didLoad()
	func didSelectChat()
}

final class ChatsScreenInteractor {
    private let presenter: ChatsScreenPresentable
    private let router: MainRouting?

    private let chatService: ChatServiceProtocol
    private let userService: UserServiceProtocol

    init(router: MainRouting?,
         presenter: ChatsScreenPresentable,
         chatService: ChatServiceProtocol,
         userService: UserServiceProtocol) {
        self.router = router
        self.presenter = presenter
        self.chatService = chatService
        self.userService = userService
    }
}

extension ChatsScreenInteractor: ChatsScreenInteracting {
    func didLoad() {
        guard let user = Auth.auth().currentUser else {
            assertionFailure("user must be there")
            return
        }
        chatService.getChatUsers(of: user) { [unowned self] result in
            switch result {
            case let .success(chatsModel):
                self.process(chatsModel: chatsModel)
            case .failure:
                self.presenter.showAlert(error: .chatsNotLoaded)
            }
        }
    }

	func didSelectChat() {
		router?.routeToChat()
	}

    private func process(chatsModel: ChatsWithUsersResponse.Chats) {
        guard let user = Auth.auth().currentUser else {
            assertionFailure("user must be there")
            return
        }
        let ids = presenter.getUserIds(chatModels: chatsModel)
            .map({ $0.uuidString })
            .filter({ $0 != user.uid })
        userService.getUserProfiles(ids: ids) { [unowned self] result in
            switch result {
            case let .success(usersDictionaries):
                self.presenter.didLoad(chatUsers: usersDictionaries)
            case .failure:
                self.presenter.showAlert(error: .chatsNotLoaded)
            }
        }
    }
}
