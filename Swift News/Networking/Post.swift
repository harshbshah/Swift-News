//
//  Post.swift
//  Swift News
//
//  Created by Harsh Shah on 2020-06-16.
//  Copyright © 2020 Pineapple Inc. All rights reserved.
//

import Foundation
// MARK: - Welcome
struct Post: Codable {
    let status: Int
    let message: String?
    let error: String?
}
