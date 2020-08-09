//
//  ChatsViewController.swift
//  SampleChatApp
//
//  Created by Антон Полуянов on 16.07.2020.
//  Copyright © 2020 anton.poluianov. All rights reserved.
//

import UIKit

protocol ChatsViewControllable: AnyObject {
    func update(model: Result<ChatsScreenViewModel.Chats, Error>)
}

final class ChatsViewController: UIViewController {

    private let interactor: ChatsScreenInteracting
    private var screenModel: ChatsScreenViewModel.Chats?

    private lazy var tableView: UITableView = {
        let tableView = UITableView().disableMasks()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChatUserCell.self, forCellReuseIdentifier: ChatUserCell.identifier())
        tableView.estimatedRowHeight = 51
        tableView.separatorStyle = .none
        return tableView
    }()
    
    init(interactor: ChatsScreenInteracting) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.didLoad()
        setupView()
        setupConstraints()
    }

    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(tableView)
    }

    private func setupConstraints() {
        tableView.pin(to: .all, of: view, respectingSafeArea: true)
    }
}

extension ChatsViewController: ChatsViewControllable {
    func update(model: Result<ChatsScreenViewModel.Chats, Error>) {
        switch model {
        case let .success(screenModel):
            self.screenModel = screenModel
            tableView.reloadData()
        case .failure:
            // TODO: Manage errors
            break
        }
    }
}

extension ChatsViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		interactor.didSelectChat()
	}
}

extension ChatsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return screenModel?.chats.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ChatUserCell.identifier()) as? ChatUserCell,
            let chat = screenModel?.chats[indexPath.row] {
            cell.bind(model: chat)
            return cell
        } else {
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "My messages"
    }
}
