//
//  ChatTableView.swift
//  Intelligents
//
//  Created by 秋星桥 on 2024/11/18.
//

import UIKit

class ChatTableView: UIView {
  let tableView = UITableView()

  var dataSource: [DataElement] = []

  init() {
    super.init(frame: .zero)

    for eachCase in DataElement.CellType.allCases {
      let cellClass = eachCase.cellClassType
      tableView.register(cellClass, forCellReuseIdentifier: eachCase.cellIdentifier)
    }

    tableView.backgroundColor = .clear

    tableView.delegate = self
    tableView.dataSource = self
    addSubview(tableView)

    tableView.translatesAutoresizingMaskIntoConstraints = false
    [
      tableView.topAnchor.constraint(equalTo: topAnchor),
      tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
    ].forEach { $0.isActive = true }

    let foot = UIView()
    foot.translatesAutoresizingMaskIntoConstraints = false
    foot.heightAnchor.constraint(equalToConstant: 200).isActive = true
    foot.widthAnchor.constraint(equalToConstant: 200).isActive = true
    tableView.tableFooterView = foot
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError()
  }
}
