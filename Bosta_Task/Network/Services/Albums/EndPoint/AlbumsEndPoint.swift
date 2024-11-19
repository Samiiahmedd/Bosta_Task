//
//  AlbumsEndPoint.swift
//  Bosta_Task
//
//  Created by Sami Ahmed on 19/11/2024.
//

import Foundation
import Moya
import Combine
import CombineMoya

enum AlbumsEndPoint {
    case getAlbums(userId: Int)
}

extension AlbumsEndPoint: Moya.TargetType {
    var baseURL: URL {
        return URL(string: Constants.baseURL)!
        
    }
    
    var path: String {
        switch self {
        case .getAlbums:
            return "/albums"
        }
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Moya.Task {
        switch self {
        case .getAlbums(let userId):
            return .requestParameters(parameters: ["userId": userId], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
}
