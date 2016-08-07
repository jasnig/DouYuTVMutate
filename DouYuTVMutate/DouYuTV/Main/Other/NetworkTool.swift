//
//  NetworkTool.swift
//  DouYuTVMutate
//
//  Created by ZeroJ on 16/7/18.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit
import Alamofire

class NetworkTool {
    /// get
    class func GET(URLString: String, parameters: [String: AnyObject]? = nil, successHandler:((result: AnyObject?) -> Void)?, failureHandler: ((error: NSError?) -> Void)?) {
        
        Alamofire.request(.GET, URLString, parameters: parameters, encoding: .URL, headers: nil).responseJSON { (response) in
            
            if response.result.isSuccess {
                print("初始请求:\(response.request)")
                successHandler?(result: response.result.value)
            } else {
                failureHandler?(error: response.result.error)
            }
            
        }
        
    }
    
    /// post
    class func POST(URLString: String, parameters: [String: AnyObject]? = nil, successHandler:((result: AnyObject?) -> Void)?, failureHandler: ((error: NSError?) -> Void)?) {
        
        Alamofire.request(.POST, URLString, parameters: parameters, encoding: .URL, headers: nil).responseJSON { (response) in
            
            if response.result.isSuccess {
                successHandler?(result: response.result.value)
            } else {
                failureHandler?(error: response.result.error)
            }
            
        }
        
    }}
    /// upload

    /// download


