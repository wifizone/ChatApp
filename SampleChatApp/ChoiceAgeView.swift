//
//  ChoiceAgeView.swift
//  SampleChatApp
//
//  Created by Антон Полуянов on 23.08.2020.
//  Copyright © 2020 anton.poluianov. All rights reserved.
//

import UIKit

final class ChoiceAgeView: UIView {

    lazy var ageString = getString(age: age)

    var age: Float {
        didSet {
            age = round(age)
            let justAgeString = getString(age: age)
            ageLabel.text = justAgeString + " years"
            ageString = justAgeString
        }
    }

    private lazy var ageLabel: UILabel = {
        let label = UILabel().disableMasks()
        label.text = getString(age: age) + " years"
        return label
    }()

    private let ageNumberLabel = UILabel().disableMasks()

    private lazy var slider: UISlider = {
        let slider = UISlider().disableMasks()
        slider.addTarget(self, action: #selector(ageChanged(sender:)), for: .valueChanged)
        slider.minimumValue = age
        slider.maximumValue = 150
        return slider
    }()

    init() {
        age = 18
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupView() {
        addSubviews([ageLabel, ageNumberLabel, slider])
        NSLayoutConstraint.activate([
            ageLabel.topAnchor.constraint(equalTo: topAnchor),
            ageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),

            ageNumberLabel.topAnchor.constraint(equalTo: ageLabel.topAnchor),
            ageNumberLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            slider.topAnchor.constraint(equalTo: ageLabel.bottomAnchor, constant: 20),
            slider.leadingAnchor.constraint(equalTo: leadingAnchor),
            slider.trailingAnchor.constraint(equalTo: trailingAnchor),
            slider.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    @objc private func ageChanged(sender: UISlider) {
        self.age = sender.value
    }

    private func getString(age: Float) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        if let ageString = formatter.string(for: age) {
            return ageString
        } else {
            return ""
        }
    }
}
