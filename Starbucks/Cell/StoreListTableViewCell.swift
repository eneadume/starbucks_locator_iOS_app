//
//  StoreListTableViewCell.swift
//  Starbucks
//
//  Created by User on 4/27/19.
//  Copyright © 2019 Enea Dume. All rights reserved.
//

import UIKit
import Kingfisher
class StoreListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var storeIcon: UIImageView!
    @IBOutlet weak var storeRatingLabel: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeAddressLabel: UILabel!
    
    static var reuseIdentifier: String {
        get {
            return "StoreListTableViewCell"
        }
    }
    
    func setStore(store: Store) {
        storeRatingLabel.text = "Rating \(store.rating)"
        storeNameLabel.text = store.name
        storeAddressLabel.text = store.address
        //use kingfisher to download and set the image to storeIcon
        if let imageUrl = URL(string: store.icon) {
            storeIcon.kf.indicatorType = .activity
            storeIcon.kf.setImage(with: ImageResource(downloadURL: imageUrl))
        }
    }
    
    //prepare cell for reuse, clear all label's text and the icon image
    override func prepareForReuse() {
        storeRatingLabel.text = ""
        storeAddressLabel.text = ""
        storeNameLabel.text = ""
        storeIcon.image = nil
    }

}
