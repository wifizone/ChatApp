//
//  MainRouter.swift
//  SampleChatApp
//
//  Created by Антон Полуянов on 19.07.2020.
//  Copyright © 2020 anton.poluianov. All rights reserved.
//

import UIKit

protocol MainRouting {}

final class MainRouter {

    weak var rootViewController: UITabBarController?
    var chatsNavigationController: UINavigationController?

    private weak var assembly: MainAssembly?

    init(assembly: MainAssembly) {
        self.assembly = assembly
    }
}

extension MainRouter: MainRouting {}
