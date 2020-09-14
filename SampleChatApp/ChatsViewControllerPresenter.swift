//
//  ChatsViewControllerPresenter.swift
//  SampleChatApp
//
//  Created by Антон Полуянов on 19.07.2020.
//  Copyright © 2020 anton.poluianov. All rights reserved.
//

import Foundation

enum ChatScreenError {
    case chatsNotLoaded
}

protocol ChatsScreenPresentable {
    func getUserIds(chatModels: ChatsWithUsersResponse.Chats) -> [UUID]
    func didLoad(chatUsers: [UserInfo])
    func showAlert(error: ChatScreenError)
}

final class ChatsViewControllerPresenter {
    weak var viewController: ChatsViewControllable?
}

extension ChatsViewControllerPresenter: ChatsScreenPresentable {
    func getUserIds(chatModels: ChatsWithUsersResponse.Chats) -> [UUID] {
        let chats = chatModels.chats
        var ids = [UUID]()
        chats.forEach({
            ids.append($0.userID)
        })
        return ids
    }
    
    func didLoad(chatUsers: [UserInfo]) {
        let chats: [ChatsScreenViewModel.ChatWithUser] = chatUsers.map({
            guard let id = UUID(uuidString: $0.id),
                let name = $0.displayName,
                let photoURL = $0.photoURL else {
                    return nil
            }
            return ChatsScreenViewModel.ChatWithUser(userID: id,
                                                     name: name,
                                                     lastMessage: "hmmm",
                                                     avatarURL: photoURL,
                                                     time: "12:30",
                                                     numberOfUnreadMessages: 0)
        }).compactMap({ $0 })
        viewController?.update(model: .success(ChatsScreenViewModel.Chats(chats: chats)))
    }

    func showAlert(error: ChatScreenError) {
        switch error {
        case .chatsNotLoaded:
            viewController?.alert(text: "Error loading chats")
        }
    }
}
