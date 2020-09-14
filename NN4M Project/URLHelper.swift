//
//  URLHelper.swift
//  NN4M Project
//
//  Created by Lorenzo on 13/09/2020.
//  Copyright © 2020 Lorenzo. All rights reserved.
//

import Foundation

class URLHelper {
    private static let catalogURL = "https://static-ri.ristack-3.nn4maws.net/v1/plp/en_gb/2506/products.json"
    private static let defaultLink = "https://images.riverisland.com/is/image/RiverIsland/"
    
    
    static func getCatalog() -> URL {
        return URL(string: catalogURL)!
    }
    
    
    static func getMainImg(articleName: String, prodId: String) -> URL {
        
        let nameLink = articleName.replacingOccurrences(of: " ", with: "-")
        let completeURL = defaultLink + nameLink + "_" + prodId + "_main"
        guard let url =  URL(string: completeURL) else {
            fatalError("Invalid URL: \(completeURL)")
        }
        return url
    }
}
