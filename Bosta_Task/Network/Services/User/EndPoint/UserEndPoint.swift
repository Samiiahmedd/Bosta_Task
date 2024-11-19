//
//  UserEndPoint.swift
//  Bosta_Task
//
//  Created by Sami Ahmed on 18/11/2024.
//

import Foundation
import Moya
import Combine
import CombineMoya

enum UserEndPoint {
    case getUser(id: Int)
}

extension UserEndPoint: Moya.TargetType {
    
    var baseURL: URL {
        return URL(string: Constants.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getUser(let id):
            return "/users/\(id)"
        }
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Moya.Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return nil
    }
}



