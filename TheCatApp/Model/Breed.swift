//
//  Breed.swift
//  TheCatApp
//
//  Created by Federico Torres on 14/05/22.
//

import Foundation

struct Breed: Codable {
    var id: String
    var name: String
    var description: String
    var image: breedImage?
}

struct breedImage: Codable {
    var id: String?
    var url: URL?
}
