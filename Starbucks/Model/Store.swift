//
//  Store.swift
//  Starbucks
//
//  Created by User on 4/27/19.
//  Copyright © 2019 Enea Dume. All rights reserved.
//

import Foundation

class Store: Decodable {
    var address: String
    var icon: String
    var rating: Double
    var name: String
    var location: Location
    

    enum CodingKeys: String, CodingKey {
        case
        address = "formatted_address",
        icon,
        rating,
        name,
        location = "geometry"
    }
    
}



struct Location: Decodable {
    var coordinates: Coordinates
    
    enum CodingKeys: String, CodingKey {
        case
        coordinates = "location"
    }
}

struct Coordinates: Decodable {
    var lat: Double
    var long: Double
    
    enum CodingKeys: String, CodingKey {
        case
        lat = "lat",
        long = "lng"
    }
}
