//
//  UrlInfo.swift
//  e4net
//
//  Created by e4 on 2022/12/21.
//

import Foundation
class URLInfo {
    static let backUrl: String = "http://192.168.8.56:8888"
    
    static func getAny1ListUrl(currentPage: Int) -> String{
        return "https://s3.eu-west-2.amazonaws.com/com.donnywals.misc/feed-\(currentPage).json"
    }
    
    static func getLoginUrl() -> String{
        return "\(backUrl)/login"
    }
    
    static func getJoinUrl() -> String{
        return "\(backUrl)/join"
    }
    
    static func getIdcheckUrl() -> String{
        return "\(backUrl)/idcheck"
    }
}
