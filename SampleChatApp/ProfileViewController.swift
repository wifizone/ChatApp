//
//  ProfileViewController.swift
//  SampleChatApp
//
//  Created by Антон Полуянов on 19.07.2020.
//  Copyright © 2020 anton.poluianov. All rights reserved.
//

import UIKit

final class ProfileViewController: UIViewController {

    private let interactor: ProfileInteracting

    private lazy var button: UIButton = {
        let button = UIButton().disableMasks()
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }()

    init(interactor: ProfileInteracting) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    @objc private func didTapButton() {
        interactor.didTapLogout()
    }

    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}
