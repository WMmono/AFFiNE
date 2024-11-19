//
//  IntelligentsButton.swift
//
//
//  Created by 秋星桥 on 2024/11/18.
//

import UIKit

// floating button to open intelligent panel
public class IntelligentsButton: UIView {
  let image = UIImageView()
  let background = UIView()

  public init() {
    super.init(frame: .zero)

    background.backgroundColor = .white
    addSubview(background)
    background.translatesAutoresizingMaskIntoConstraints = false
    [
      background.leadingAnchor.constraint(equalTo: leadingAnchor),
      background.trailingAnchor.constraint(equalTo: trailingAnchor),
      background.topAnchor.constraint(equalTo: topAnchor),
      background.bottomAnchor.constraint(equalTo: bottomAnchor),
    ].forEach { $0.isActive = true }

    image.image = .init(named: "spark", in: .module, with: .none)
    image.contentMode = .scaleAspectFit
    image.tintColor = Constant.affineTintColor
    addSubview(image)
    let imageInsetValue: CGFloat = 12
    image.translatesAutoresizingMaskIntoConstraints = false
    [
      image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: imageInsetValue),
      image.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -imageInsetValue),
      image.topAnchor.constraint(equalTo: topAnchor, constant: imageInsetValue),
      image.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -imageInsetValue),
    ].forEach { $0.isActive = true }

//        layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
//        layer.shadowOffset = CGSize(width: 0, height: 0)
//        layer.shadowRadius = 8

    clipsToBounds = true
    layer.borderWidth = 2
    layer.borderColor = UIColor.gray.withAlphaComponent(0.1).cgColor

    let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
    addGestureRecognizer(tap)
    isUserInteractionEnabled = true
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError()
  }

  override public func layoutSubviews() {
    super.layoutSubviews()

    layer.cornerRadius = bounds.width / 2
  }

  @objc func tapped() {
    guard let controller = parentViewController else {
      assertionFailure()
      return
    }
    let targetController = IntelligentsChatController()
    controller.presentIntoCurrentContext(withTargetController: targetController)
  }
}
