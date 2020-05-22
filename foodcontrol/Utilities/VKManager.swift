//
//  VKManager.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 22.05.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import SwiftyVK

protocol VKManagerDelegate: class {
  func presentVkViewController(_ viewController: VKViewController)
}

class VKManager: SwiftyVKDelegate {
  
  weak var delegate: VKManagerDelegate?
  
  static let shared = VKManager()
  
  init() {
    VK.setUp(appId: "7478337", delegate: self)
  }
  
  func login(completionHandler: @escaping (String?, Error?) -> Void) {
    if let userId = VK.sessions.default.accessToken?.info["user_id"] {
      completionHandler(userId, nil)
    } else {
      VK.sessions.default.logIn(
        onSuccess: { dictionary in
          completionHandler(dictionary["user_id"], nil)
      }, onError: { error in
          completionHandler(nil, error)
      })
    }
  }
  
  func getFriendIds(completionHandler: @escaping ([String]?, Error?) -> Void) {
    let parameters: Parameters = [.userId: AuthManager.shared.currentUser?.vkId ?? ""]
    VK.API.Friends.get(parameters).onSuccess { (data) in
      guard let vkFriendsResponse = try? JSONDecoder().decode(VKFriendsResponse.self, from: data) else {
          completionHandler(nil, nil)
          return
      }
      completionHandler(vkFriendsResponse.items.compactMap({ "\($0)" }), nil)
    }.onError { (error) in
      completionHandler(nil, error)
    }.send()
  }
  
  func vkNeedsScopes(for sessionId: String) -> Scopes {
    return [.friends]
  }
  
  func vkNeedToPresent(viewController: VKViewController) {
    delegate?.presentVkViewController(viewController)
  }
  
}

struct VKFriendsResponse: Decodable {
  let items: [Int]
}
