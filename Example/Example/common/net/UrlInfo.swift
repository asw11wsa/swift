//
//  UrlInfo.swift
//  Example
//
//  Created by e4 on 2022/12/20.
//

import Foundation

class URLInfo {
    static func getAny1ListUrl(currentPage: Int) -> String{
        return "https://s3.eu-west-2.amazonaws.com/com.donnywals.misc/feed-\(currentPage).json"
    }
    
    static func getLoginUrl(){
        
    }
    
    static func getLogoutUrl(){
        
    }
    
    static func getJoinUrl(){
        
    }
}
