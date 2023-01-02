//
//  JoinModel.swift
//  e4net
//
//  Created by e4 on 2022/12/21.
//

import Foundation

struct JoinModel: Encodable {
    var membId: String
    var membPwd: String
    var membNm: String
    var mobileNo: String
    var emailAddr: String
    var zipCd: String
    var zipAddr: String
    var detailAddr: String
}
