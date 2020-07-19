//
//  ChatUserCell.swift
//  SampleChatApp
//
//  Created by Антон Полуянов on 19.07.2020.
//  Copyright © 2020 anton.poluianov. All rights reserved.
//

import UIKit
import Kingfisher

final class ChatUserCell: UITableViewCell {

    private let avatarView = UIImageView().disableMasks()
    private let newMessagesCountLabel = UILabel().disableMasks()
    private let nameLabel = UILabel().disableMasks()
    private let lastMessageLabel = UILabel().disableMasks()
    private let timeLable: UILabel = {
        let label = UILabel().disableMasks()
        label.textAlignment = .center
        return label
    }()

    func bind(model: ChatsScreenViewModel.ChatWithUser) {
        let processor = RoundCornerImageProcessor(radius: .heightFraction(0.5))
        avatarView.kf.setImage(with: model.avatarURL,  options: [.processor(processor)])
        newMessagesCountLabel.text = String(describing: model.numberOfUnreadMessages)
        nameLabel.text = model.name
        lastMessageLabel.text = model.lastMessage
        timeLable.text = model.time
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: String(describing: ChatUserCell.self))
        setupView()
        setupContraints()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupView() {
        contentView.addSubviews([avatarView, newMessagesCountLabel, nameLabel, lastMessageLabel, timeLable])
    }

    private func setupContraints() {
        NSLayoutConstraint.activate([
            avatarView.topAnchor.constraint(equalTo: contentView.topAnchor),
            avatarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            avatarView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            avatarView.widthAnchor.constraint(equalToConstant: 51),
            avatarView.heightAnchor.constraint(equalToConstant: 51),

            timeLable.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            timeLable.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            timeLable.widthAnchor.constraint(equalToConstant: 51),

            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            nameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            lastMessageLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            lastMessageLabel.trailingAnchor.constraint(equalTo: timeLable.leadingAnchor, constant: -6),
            lastMessageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
        ])
    }
}
