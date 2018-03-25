//
//  ViewController.swift
//  CachingImagesTest
//
//  Created by Dustin Hart on 3/24/18.
//  Copyright © 2018 Dustin Hart. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var myImageView: UIImageView!
    
    let imageStore = ImageStore("images") // images.plist
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // clear cache incase it was saved on last run
        // You don't really want to do this every time the app loads
        imageStore.clearCache()
        
        // cache all images to disk
        imageStore.cacheAllImages()
        
        // set default image
        myImageView.contentMode = UIViewContentMode.scaleAspectFit
        myImageView.image = imageStore.getImage(named: "bird")
    }
    
    // change image based on the text of the button pressed
    @IBAction func changeImage(sender: UIButton) {
        let name = sender.currentTitle!
        myImageView.image = imageStore.getImage(named: name)
    }
}

