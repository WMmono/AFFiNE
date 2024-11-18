//
//  IntelligentsChatController.swift
//
//
//  Created by 秋星桥 on 2024/11/18.
//

import UIKit

class IntelligentsChatController: UIViewController {
  let header = Header()
  let inputBox = InputBox()
  let tableView = ChatTableView()

  override var title: String? {
    set {
      super.title = newValue
      header.titleLabel.text = newValue
    }
    get {
      super.title
    }
  }

  init() {
    super.init(nibName: nil, bundle: nil)
    title = "Chat with AI".localized()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    assert(navigationController != nil)
    view.backgroundColor = .secondarySystemBackground

    hideKeyboardWhenTappedAround()
    setupLayout()
  }

  func setupLayout() {
    view.addSubview(header)
    header.translatesAutoresizingMaskIntoConstraints = false
    [
      header.topAnchor.constraint(equalTo: view.topAnchor),
      header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      header.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
    ].forEach { $0.isActive = true }

    view.addSubview(inputBox)
    inputBox.translatesAutoresizingMaskIntoConstraints = false
    [
      inputBox.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      inputBox.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      inputBox.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ].forEach { $0.isActive = true }

    view.addSubview(tableView)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    [
      tableView.topAnchor.constraint(equalTo: header.bottomAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: inputBox.topAnchor),
    ].forEach { $0.isActive = true }
  }
}
