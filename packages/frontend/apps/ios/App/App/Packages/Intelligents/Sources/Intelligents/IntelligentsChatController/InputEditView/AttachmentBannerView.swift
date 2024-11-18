//
//  AttachmentBannerView.swift
//  Intelligents
//
//  Created by 秋星桥 on 2024/11/18.
//

import UIKit

private let attachmentSize: CGFloat = 100
private let attachmentSpacing: CGFloat = 16

class AttachmentBannerView: UIScrollView {
  var attachments: [UIImage] = [] {
    didSet {
      rebuildViews()
    }
  }

  override var intrinsicContentSize: CGSize {
    if attachments.isEmpty { return .zero }
    return .init(
      width: (attachmentSize + attachmentSize) * CGFloat(attachments.count)
        - attachmentSpacing,
      height: attachmentSize
    )
  }
  
  init() {
    super.init(frame: .zero)

    translatesAutoresizingMaskIntoConstraints = false

    showsHorizontalScrollIndicator = false
    showsVerticalScrollIndicator = false
    
    rebuildViews()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError()
  }
  
  func rebuildViews() {
    subviews.forEach { $0.removeFromSuperview() }
    for (index, attachment) in attachments.enumerated() {
      let view = AttachmentPreviewView()
      view.imageView.image = attachment
      addSubview(view)
      view.translatesAutoresizingMaskIntoConstraints = false
      view.frame = .init(
        origin: .init(
          x: (attachmentSize + attachmentSpacing) * CGFloat(index),
          y: 0
        ),
        size: .init(width: attachmentSize, height: attachmentSize)
      )
    }
    invalidateIntrinsicContentSize()
    contentSize = intrinsicContentSize
  }
}

extension AttachmentBannerView {
  class AttachmentPreviewView: UIView {
    let imageView = UIImageView()
    let deleteButton = UIButton()

    override var intrinsicContentSize: CGSize {
      .init(width: attachmentSize, height: attachmentSize)
    }

    init() {
      super.init(frame: .zero)
      addSubview(imageView)
      addSubview(deleteButton)

      layer.cornerRadius = 8
      clipsToBounds = true

      imageView.contentMode = .scaleAspectFill
      imageView.clipsToBounds = true
      imageView.translatesAutoresizingMaskIntoConstraints = false
      [
        imageView.topAnchor.constraint(equalTo: topAnchor),
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
      ].forEach { $0.isActive = true }

      deleteButton.setImage(.init(named: "close", in: .module, with: nil), for: .normal)
      deleteButton.imageView?.contentMode = .scaleAspectFit
      deleteButton.tintColor = .white
      deleteButton.translatesAutoresizingMaskIntoConstraints = false
      [
        deleteButton.topAnchor.constraint(equalTo: topAnchor, constant: 4),
        deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
        deleteButton.widthAnchor.constraint(equalToConstant: 32),
        deleteButton.heightAnchor.constraint(equalToConstant: 32),
      ].forEach { $0.isActive = true }

      [
        widthAnchor.constraint(equalToConstant: attachmentSize),
        heightAnchor.constraint(equalToConstant: attachmentSize),
      ].forEach { $0.isActive = true }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
      fatalError()
    }
  }
}
