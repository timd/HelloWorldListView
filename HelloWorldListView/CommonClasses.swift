//
//  CommonClasses.swift
//  HelloWorldListView
//
//  Created by Tim Duckett on 28.06.20.
//

import Foundation
import UIKit

struct Item: Hashable {
    let uuid = UUID()
    var title: String
    var subtitle: String
    var image: UIImage?
}

enum Section {
    case main
    case second
}
