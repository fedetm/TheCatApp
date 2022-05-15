//
//  BreedController.swift
//  TheCatApp
//
//  Created by Federico Torres on 14/05/22.
//

import Foundation
import UIKit

class BreedController {
    
    static let shared = BreedController()
    
    let baseURL = URL(string: "https://api.thecatapi.com/v1/breeds")!
    let apiKey = "b201fc95-221c-4465-b391-df610e6da9bb"
    
    enum BreedControllerError: Error, LocalizedError {
        case breedNotFound
        case imageDataMissing
    }
    
    func fetchBreeds() async throws -> [Breed] {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)!
        components.queryItems = [URLQueryItem(name: "api_key", value: apiKey), URLQueryItem(name: "attach_breed", value: "0")]
        let baseURL = components.url!
        
        let (data, response) = try await URLSession.shared.data(from:
               baseURL)
        guard let httpResponse = response as? HTTPURLResponse,
           httpResponse.statusCode == 200 else {
            throw BreedControllerError.breedNotFound
        }
        
        let decoder = JSONDecoder()
        let breedResponse = try decoder.decode([Breed].self, from: data)
        
        return breedResponse
    }
    
    func fetchImage(from url: URL) async throws -> UIImage {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 200 else {
            throw BreedControllerError.imageDataMissing
        }
    
        guard let image = UIImage(data: data) else {
            throw BreedControllerError.imageDataMissing
        }
    
        return image
    }
}
