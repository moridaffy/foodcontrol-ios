//
//  APIManager.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 17.05.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import Foundation
import Alamofire

class APIManager {
  
  static let shared = APIManager()
  
  var offHeader: HTTPHeaders {
    return [
      "User-Agent": "FoodControl - iOS - \(Bundle.main.releaseVersionNumber ?? "1.0")"
    ]
  }
  
  func searchForDishes(byName name: String, completionHandler: @escaping ([OFFDishCodable]?, Error?) -> Void) {
    guard let url = URL(string: URLs.domain.string + URLs.search.string + URLs.searchByName(name).string + URLs.json.string) else { fatalError() }
    
    AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: offHeader).response { (response) in
      guard let responseData = response.data else {
        completionHandler(nil, response.error)
        return
      }
      guard let offResponse = try? JSONDecoder().decode(OFFDishListResponse.self, from: responseData) else {
        completionHandler(nil, response.error)
        return
      }
      completionHandler(offResponse.products, nil)
    }
  }
  
}

extension APIManager {
  enum URLs {
    
    case domain
    case json
    
    case search
    case searchByName(String)
    var string: String {
      switch self {
      case .domain:
        return "https://ru.openfoodfacts.org"
      case .json:
        return "&json=true"
        
      case .search:
        return "/cgi/search.pl?action=process&search_simple=1"
      case .searchByName(let name):
        return "&search_terms=\(name.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")"
      }
    }
  }
}
