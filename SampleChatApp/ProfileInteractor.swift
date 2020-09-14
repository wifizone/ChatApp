//
//  ProfileInteractor.swift
//  SampleChatApp
//
//  Created by Антон Полуянов on 12.09.2020.
//  Copyright © 2020 anton.poluianov. All rights reserved.
//

protocol ProfileInteracting: AnyObject {
    func didTapLogout()
}

final class ProfileInteractor {

    private let router: MainRouting?
    private let authenticationService: AuthenticationLogic

    init(router: MainRouting?,
         authenticationService: AuthenticationLogic) {
        self.router = router
        self.authenticationService = authenticationService
    }
}

extension ProfileInteractor: ProfileInteracting {
    func didTapLogout() {
        try? authenticationService.logout()
    }
}
