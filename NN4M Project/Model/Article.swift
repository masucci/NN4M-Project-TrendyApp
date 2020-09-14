//
//  Article.swift
//  NN4M Project
//
//  Created by Lorenzo on 14/09/2020.
//  Copyright © 2020 Lorenzo. All rights reserved.
//

import Foundation


struct Article: Codable {
    let name: String
    let cost: String
    let allImages: [String]
    let prodid: String
    let isTrending: Bool
}
