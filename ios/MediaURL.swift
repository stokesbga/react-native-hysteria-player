//
//  MediaURL.swift
//  Playlist
//
//  Created by Alex Stokes on 2/24/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation

struct MediaURL {
    let value: URL
    let isLocal: Bool
    private let originalObject: Any
    
    init?(object: Any?) {
        guard let object = object else { return nil }
        originalObject = object
        
        if let localObject = object as? [String: Any] {
            let uri = localObject["uri"] as! String
            isLocal = uri.contains("http") ? false : true
            let encodedURI = uri.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            value = URL(string: encodedURI.replacingOccurrences(of: "file://", with: ""))!
        } else {
            let url = object as! String
            isLocal = url.lowercased().hasPrefix("file://")
            value = URL(string: url.replacingOccurrences(of: "file://", with: ""))!
        }
    }
}
