//
//  Meme.swift
//  ImagePicker
//
//  Created by Moritz Gort on 11/09/15.
//  Copyright (c) 2015 Gabriele Gort. All rights reserved.
//

import Foundation
import UIKit

class Meme {
    var topText: String!
    var bottomText: String!
    var image: UIImage
    var memeImage: UIImage
    
    init (topText: String, bottomText: String, image: UIImage, memeImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.image = image
        self.memeImage = memeImage
    }
    
}