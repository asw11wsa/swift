//
//  PageModel.swift
//  Example
//
//  Created by e4 on 2022/12/19.
//

import Foundation

class PageModel: ObservableObject {
    @Published var current: Int = 0
    @Published var maxCnt: Int = 0
    var hasMorePages:Bool = true
}
