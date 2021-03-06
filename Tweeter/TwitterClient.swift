//
//  TwitterClient.swift
//  Tweeter
//
//  Created by William Huang on 2/22/17.
//  Copyright © 2017 William Huang. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com"), consumerKey: "bRFFweljdqXmeTyuCm5OeoTMm", consumerSecret: "alOB7bWzbseTWuChr6IN5qPoBaKvDdoWEBqnIPZHoFZBOK1mCW")!
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance.deauthorize()
        TwitterClient.sharedInstance.fetchRequestToken(withPath: "/oauth/request_token", method: "GET", callbackURL: URL(string: "tweeter://oauth"), scope: nil, success: { (requestToken) in
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)")!
            UIApplication.shared.open(url)
        }, failure: { (error) in
            print("error \(error?.localizedDescription)")
            self.loginFailure?(error!)
        })
        
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        NotificationCenter.default.post(name: User.userDidLogoutNotification, object: nil)
    }
    
    func tweet(status: String) {
        let endpoint = "/1.1/statuses/update.json?status="
        guard let encodedStatus = status.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            print("wat")
            return
        }
        let url = endpoint + encodedStatus
        post(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            print("tweet succeeded")
        }) { (task: URLSessionDataTask?, error: Error) in
            print("error: \(error.localizedDescription)")
        }
    }
    
    func homeTimeline(withMaxId maxId: Int?, success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        var endpoint = "/1.1/statuses/home_timeline.json"
        if let maxId = maxId {
            endpoint = "/1.1/statuses/home_timeline.json?max_id=\(maxId)"
        }
        get(endpoint, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let tweetsDictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: tweetsDictionaries)
            success(tweets)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("error: \(error.localizedDescription)")
            failure(error)
        })
    }
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("/1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            success(user)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("error: \(error.localizedDescription)")
            failure(error)
        })
    }
    
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "/oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken) in
            self.currentAccount(success: { (user: User) in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: Error) in
                self.loginFailure?(error)
            })
        }, failure: { (error) in
            print("error: \(error?.localizedDescription)")
            self.loginFailure?(error!)
        })

    }
}
