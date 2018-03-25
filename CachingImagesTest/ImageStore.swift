//
//  ImageCache.swift
//  CachingImagesTest
//
//  Created by Dustin Hart on 3/24/18.
//  Copyright © 2018 Dustin Hart. All rights reserved.
//

import Foundation
import UIKit

class ImageStore {
    
    let imageDict: NSDictionary
    
    init(_ plistName: String) {
        // blows up if plist doesn't exist
        let path = Bundle.main.path(forResource: plistName, ofType: "plist")
        imageDict = NSDictionary(contentsOfFile: path!)!
    }
    
    func clearCache() {
        // removes each cached image if it exists
        print("clearing cache")
        for name in imageDict.allKeys as! [String]{
            let filename = getDocumentsDirectory().appendingPathComponent(name)
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filename.path) {
                try? fileManager.removeItem(at: filename)
            }
        }
    }
    
    // hits the url for each image in the plist and saves to disk
    func cacheAllImages() {
        print("cache all images")
        for name in imageDict.allKeys as! [String]{
            let url = imageDict[name] as! String
            _ = cacheImageURL(key: name, url: url)
        }
    }
    
    // pulls image from plist from disk
    // if the image isn't on disk, it downloads the url first and saves the image
    func getImage(named name: String) -> UIImage? {
        let filename = getDocumentsDirectory().appendingPathComponent(name)
        let url = imageDict[name] as! String
        
        var image: UIImage? = nil
        
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filename.path) {
            // image cached, load from disk
            print("image \(name) cached, loading from disk")
            do {
                let imageData = try Data(contentsOf: filename)
                image = UIImage(data: imageData)
            } catch {
                print("Error loading image : \(error)")
            }
        } else {
            // image isn't cached, load from url and save
            print("image \(name) not found, loading from URL")
            image = cacheImageURL(key: name, url: url, filename: filename)
        }
        
        return image
    }
    
    // helper that downloads url and saves the image if successful
    private func cacheImageURL(key name: String, url: String, filename: URL? = nil) -> UIImage? {
        let filename = filename ?? getDocumentsDirectory().appendingPathComponent(name)
        
        let imageUrl = URL(string: url)!
        let imageData = NSData(contentsOf: imageUrl)!
        
        let image = UIImage(data: imageData as Data)
        
        // write image to disk
        if image != nil {
            if let data = UIImagePNGRepresentation(image!) {
                try? data.write(to: filename)
            }
        }
        
        return image
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
}
