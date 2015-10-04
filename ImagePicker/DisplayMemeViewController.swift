//
//  DisplayMemeViewController.swift
//  ImagePicker
//
//  Created by Moritz Gort on 04/10/15.
//  Copyright © 2015 Gabriele Gort. All rights reserved.
//

import UIKit

class DisplayMemeViewController: UIViewController {

    @IBOutlet weak var finishedMemeImageView: UIImageView!
    
    var finishedImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        finishedMemeImageView.image = finishedImage
        tabBarController?.hidesBottomBarWhenPushed = true
    }
}
