//
//  ChatsViewControllerPresenter.swift
//  SampleChatApp
//
//  Created by Антон Полуянов on 19.07.2020.
//  Copyright © 2020 anton.poluianov. All rights reserved.
//

import Foundation

protocol ChatsScreenPresentable {
    func didLoad(chatModels: ChatsScreenViewModel.Chats)
}

final class ChatsViewControllerPresenter {
    weak var viewController: ChatsViewControllable?
}

extension ChatsViewControllerPresenter: ChatsScreenPresentable {
    func didLoad(chatModels: ChatsScreenViewModel.Chats) {
        viewController?.update(model: .success(chatModels))
    }
}
