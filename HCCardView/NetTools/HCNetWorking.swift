//
//  HCNetWorking.swift
//  HCCardView
//
//  Created by UltraPower on 2017/5/24.
//  Copyright © 2017年 UltraPower. All rights reserved.
//

import Foundation

enum HCHTTPMethod:String {
    case GET = "GET"
    case POST = "POST"
}

typealias HCSuccess = (Data) -> Void
typealias HCFailure = (Error) -> Void
typealias stringHandler = (String) -> Void
typealias jsonHandler = (Any) -> Void

class HCNetWorking {
    // 单例对象
    static let sharedInstance = HCNetWorking()
    
    // 私有化构造方法
    fileprivate init(){
    }
    
    
    // 网络请求
    static func request(_ url:String , method:HCHTTPMethod, success: @escaping HCSuccess, failure: @escaping HCFailure){
        
        DispatchQueue.global().async {
            guard let sessionURL = URL(string: url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!) else {
                return
            }
            
            let sessionConnect = URLSession.shared.dataTask(with: sessionURL) { (data, response, error) in
                
                guard error == nil  && data != nil else {
                    failure(error!)
                    return
                }
                
                success(data!)
                
            }
            
            sessionConnect.resume()
        }
        
    }
    
    static func request(_ url:String, method:HCHTTPMethod = .GET) -> URLRequest {
        
        let sessionURL = URL(string: url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        return URLRequest(url: sessionURL!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 5.0)
    }
}

extension URLRequest {
    @discardableResult
    func responseString(response:@escaping stringHandler) -> URLRequest {
        DispatchQueue.global().async {
            
            URLSession.shared.dataTask(with: self, completionHandler: { (data, result, error) in
                
                guard error == nil else {
                    response(error!.localizedDescription)
                    return
                }
                
                response(String(data: data!, encoding: .utf8)!)
            }).resume()
        }
        return self
        
    }
    
    @discardableResult
    func responseJSON(response:@escaping jsonHandler) -> URLRequest {
        DispatchQueue.global().async {
            
            URLSession.shared.dataTask(with: self, completionHandler: { (data, result, error) in
                do {
                    guard error == nil else {
                        response(error!.localizedDescription)
                        return
                    }
                    
                    let resultStr = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    response(resultStr)
                } catch {
                    
                }
            }).resume()
            
        }
        return self
        
    }
}
