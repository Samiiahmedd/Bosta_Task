//
//  ImagesEndPoint.swift
//  Bosta_Task
//
//  Created by Sami Ahmed on 19/11/2024.
//


import Foundation
import Moya
import Combine
import CombineMoya

enum ImagesEndPoint {
    case getImages(albumId: Int)
}

extension ImagesEndPoint: Moya.TargetType {
    var baseURL: URL {
        return URL(string: Constants.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getImages:
            return "/photos"
        }
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Moya.Task {
        switch self {
        case .getImages(let albumId):
            return .requestParameters(parameters: ["albumId": albumId], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
}
