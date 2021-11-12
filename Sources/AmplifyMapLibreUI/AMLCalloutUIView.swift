//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import UIKit

/// Internal default callout view displayed when a user taps an annotation.
class AMLCalloutUIView: UIView {
    let xButton = UIButton()
    let nameLabel = UILabel()
    let addressLineOne = UILabel()
    let addressLineTwo = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        configureView()
        configureSubviews()
        layoutConstraints()
    }
    
    /// Configures the `AMLCalloutUIView`
    private func configureView() {
        backgroundColor = .white
        layer.borderWidth = 2.5
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = 12.5
    }
    
    /// Configures the `AMLCalloutUIView`'s subviews.
    private func configureSubviews() {
        [xButton, nameLabel, addressLineOne, addressLineTwo]
            .forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                addSubview($0)
            }
        
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.font = .systemFont(ofSize: 20, weight: .medium)
        nameLabel.textColor = .black
        [addressLineOne, addressLineTwo].forEach {
            $0.textColor = .secondaryLabel
        }
        
        let xMarkImage = UIImage(
            systemName: "xmark",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 19)
        )
        xButton.setImage(
            xMarkImage,
            for: .normal
        )
        xButton.tintColor = .secondaryLabel
        xButton.addTarget(self, action: #selector(xButtonTapped), for: .touchUpInside)
    }
    
    /// Layout constraints for `AMLCalloutUIView`'s subviews.
    private func layoutConstraints() {
        NSLayoutConstraint.activate([
            xButton.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            xButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            xButton.widthAnchor.constraint(equalToConstant: 25),
            xButton.heightAnchor.constraint(equalToConstant: 25),
            
            nameLabel.topAnchor.constraint(equalTo: xButton.bottomAnchor, constant: 0),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: xButton.leadingAnchor, constant: -12),
            
            addressLineOne.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            addressLineOne.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            addressLineOne.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            addressLineTwo.topAnchor.constraint(equalTo: addressLineOne.bottomAnchor, constant: 8),
            addressLineTwo.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            addressLineTwo.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            addressLineTwo.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    /// Called by `xButton`'s gesture recognizer to remove the callout view.
    @objc func xButtonTapped() {
        self.removeFromSuperview()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
}
