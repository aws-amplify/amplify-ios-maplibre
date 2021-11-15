//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import UIKit
import Mapbox

/// Internal default callout view displayed when a user taps an annotation.
class AMLCalloutUIView: UIView {
    let xButton = UIButton()
    let nameLabel = UILabel()
    let addressLineOneLabel = UILabel()
    let addressLineTwoLabel = UILabel()
    
    /// Initializes an empty `AMLCalloutView`
    /// - Parameter frame: The view's specified frame rectangle.
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureSubviews()
        layoutConstraints()
    }
    
    /// Initializes an `AMLCalloutView` with information displayed from the feature.
    /// - Parameters:
    ///   - frame: The view's specified frame rectangle.
    ///   - feature: The `MGLPointFeature` for the callout view.
    init(frame: CGRect, feature: MGLPointFeature) {
        super.init(frame: frame)
        configureView()
        configureSubviews()
        layoutConstraints()
        setLabelText(for: feature)
    }
    
    private func setLabelText(for feature: MGLPointFeature) {
        nameLabel.text = feature.attributes["aml_display_label"] as? String
        addressLineOneLabel.text = feature.attributes["aml_display_addressLineOne"] as? String
        addressLineTwoLabel.text = feature.attributes["aml_display_addressLineTwo"] as? String
    }
    
    /// Configures the `AMLCalloutUIView`
    private func configureView() {
        backgroundColor = .white
        layer.borderWidth = 2.5
        layer.borderColor = UIColor.secondaryLabel.cgColor
        layer.cornerRadius = 12.5
    }
    
    /// Configures the `AMLCalloutUIView`'s subviews.
    private func configureSubviews() {
        [xButton, nameLabel, addressLineOneLabel, addressLineTwoLabel]
            .forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                addSubview($0)
            }
        
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.font = .systemFont(ofSize: 20, weight: .medium)
        nameLabel.textColor = .black
        [addressLineOneLabel, addressLineTwoLabel].forEach {
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
            
            addressLineOneLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            addressLineOneLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            addressLineOneLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            addressLineTwoLabel.topAnchor.constraint(equalTo: addressLineOneLabel.bottomAnchor, constant: 8),
            addressLineTwoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            addressLineTwoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            addressLineTwoLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    /// Called by `xButton`'s gesture recognizer to remove the callout view.
    @objc func xButtonTapped() {
        self.removeFromSuperview()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
}
