//
//  File.swift
//  Intelligents
//
//  Created by 秋星桥 on 2024/11/18.
//

import UIKit
import Combine

extension InputEditView {
  class ViewModel: ObservableObject {
    var cancellables: Set<AnyCancellable> = []
    
    @Published var text: String = ""
    @Published var attachments: [UIImage] = []
    
    init() {
      
    }
    
    deinit {
      cancellables.forEach { $0.cancel() }
      cancellables.removeAll()
    }
  }
}

extension InputEditView.ViewModel: Hashable, Equatable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(text)
    hasher.combine(attachments)
  }
  
  static func == (lhs: InputEditView.ViewModel, rhs: InputEditView.ViewModel) -> Bool {
    lhs.hashValue == rhs.hashValue
  }
}
