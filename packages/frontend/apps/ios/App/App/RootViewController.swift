//
//  RootViewController.swift
//  App
//
//  Created by 秋星桥 on 2024/11/18.
//

import UIKit

@objc
class RootViewController: UINavigationController {
  override init(rootViewController: UIViewController) {
    fatalError() // "you are not allowed to call this"
  }
  
  override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
    fatalError() // "you are not allowed to call this"
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commitInit()
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    fatalError() // "you are not allowed to call this"
  }
  
  func commitInit() {
    assert(viewControllers.isEmpty)
    viewControllers = [AFFiNEViewController()]
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
  }
}
