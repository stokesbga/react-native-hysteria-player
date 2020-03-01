//
//  RNPlaylistBundle.swift
//  Playlist
//
//  Created by Alex Stokes on 2/28/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation

class RNPlaylistGlobal: NSObject {
  
  static private var bundle: Bundle!
  static func getResourceBundle() -> Bundle {
    if(bundle != nil) {
      return bundle
    }
    
   let myBundle = Bundle(for: RNPlaylist.self)
    guard let resourceBundleURL = myBundle.url(
      forResource: "RNPlaylistBundle", withExtension: "bundle")
      else { fatalError("RNPlaylistBundle.bundle not found!") }

    guard let resourceBundle = Bundle(url: resourceBundleURL)
      else { fatalError("Cannot access RNPlaylistBundle.bundle!") }
    
    bundle = resourceBundle
    return bundle
  }
  
  
  // Fallback Icons + Resources
  static private var icons: [String: UIImage]! = [String: UIImage]()
  static func getFallbackResource(_ assetStr: String) -> UIImage {
    if (icons != nil && icons[assetStr] != nil) {
      return icons[assetStr] ?? addResourceToDict(assetStr)
    }
    return addResourceToDict(assetStr)
  }
  private static func addResourceToDict(_ assetStr: String) -> UIImage {
    let img = UIImage(named: assetStr, in: getResourceBundle(), compatibleWith: nil) ?? UIImage()
    icons[assetStr] = img
    return img
  }
  
}
