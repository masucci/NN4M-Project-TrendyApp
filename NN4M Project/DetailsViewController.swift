//
//  DetailsViewController.swift
//  NN4M Project
//
//  Created by Lorenzo on 11/09/2020.
//  Copyright © 2020 Lorenzo. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {


    
    @IBOutlet weak var imageZoomed: UIImageView!
    @IBOutlet weak var imageLabel: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var addItemButton: UIButton!
    
    var imageDetail = UIImage()
    var labelDetail = ""
    var labelCost = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageZoomed.image = imageDetail
        imageLabel.text = labelDetail
        labelPrice.text = labelCost
        
        addItemButton.layer.cornerRadius = 10

//   Adding SFSymbols into string
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "heart.fill")
        let fullString = NSMutableAttributedString(attachment: imageAttachment)
        fullString.append(NSAttributedString(string: "\(Int.random(in: 1...100)) TIMES"))
        likeCount.attributedText = fullString
    }

}
