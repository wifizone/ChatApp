//
//  ChatsScreenInteractor.swift
//  SampleChatApp
//
//  Created by Антон Полуянов on 16.07.2020.
//  Copyright © 2020 anton.poluianov. All rights reserved.
//

import Foundation

protocol ChatsScreenInteracting: AnyObject {
    func didLoad()
}

final class ChatsScreenInteractor {
    private let presenter: ChatsScreenPresentable
    private let router: MainRouting?

    init(router: MainRouting?,
         presenter: ChatsScreenPresentable) {
        self.router = router
        self.presenter = presenter
    }
}

extension ChatsScreenInteractor: ChatsScreenInteracting {
    func didLoad() {
        // Download
        presenter.didLoad(chatModels: ChatScreenMocks.get())
    }
}
