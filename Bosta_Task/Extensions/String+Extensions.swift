//
//  String+Extensions.swift
//  Bosta_Task
//
//  Created by Sami Ahmed on 19/11/2024.
//

import Foundation

extension String {
    var asUrl: URL? {
        return URL(string: self)
    }
}
