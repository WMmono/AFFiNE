//
//  ChatTableView+BaseCell.swift
//  Intelligents
//
//  Created by 秋星桥 on 2024/11/18.
//

import UIKit

extension ChatTableView {
  class BaseCell: UITableViewCell {
    var inset: UIEdgeInsets = .zero {
      didSet { setNeedsLayout() }
    }

    let containerView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
      selectionStyle = .none
      backgroundColor = .clear
      contentView.addSubview(containerView)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
      fatalError()
    }

    override func layoutSubviews() {
      super.layoutSubviews()
      containerView.frame = contentView.bounds.inset(by: inset)
    }

    func update(via _: AnyObject?) {
      assertionFailure() // "should be override"
    }
  }
}
