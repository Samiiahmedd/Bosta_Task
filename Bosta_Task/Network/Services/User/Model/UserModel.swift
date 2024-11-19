//
//  UserModel.swift
//  Bosta_Task
//
//  Created by Sami Ahmed on 18/11/2024.
//

import Foundation

struct User: Codable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let address: Address
}

struct Address: Codable {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
}
