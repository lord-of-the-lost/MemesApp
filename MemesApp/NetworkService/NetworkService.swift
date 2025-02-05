//
//  NetworkService.swift
//  MemesApp
//
//  Created by Николай Игнатов on 05.02.2025.
//

import UIKit

// MARK: - NetworkServiceProtocol
protocol NetworkServiceProtocol {
    func fetchData(completion: @escaping (Result<[Meme], Error>) -> ())
    func loadImage(from urlString: String, completion: @escaping (Result<UIImage, Error>) -> ())
}

// MARK: - NetworkError
enum NetworkError: Error {
    case badURL, badResponse, invalidData, decodeError
}

// MARK: - NetworkService

final class NetworkService: NetworkServiceProtocol {
    private let baseURL = "https://api.imgflip.com"
    private let imageCache = NSCache<NSString, UIImage>()
    
    func fetchData(completion: @escaping (Result<[Meme], Error>) -> ()) {
        guard let url = URL(string: "\(baseURL)/get_memes") else {
            completion(.failure(NetworkError.badURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let _ = error {
                completion(.failure(NetworkError.badResponse))
                return
            }
            
            guard let data else {
                completion(.failure(NetworkError.invalidData))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(MemeResponse.self, from: data)
                completion(.success(response.data.memes))
            } catch {
                completion(.failure(NetworkError.decodeError))
            }
            
        }.resume()
    }
    
    func loadImage(from urlString: String, completion: @escaping (Result<UIImage, Error>) -> ()) {
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            completion(.success(cachedImage))
            return
        }
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.badURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let _ = error {
                completion(.failure(NetworkError.badResponse))
                return
            }
            
            guard let data, let image = UIImage(data: data) else {
                completion(.failure(NetworkError.invalidData))
                return
            }
            
            self?.imageCache.setObject(image, forKey: urlString as NSString)
            completion(.success(image))
        }.resume()
    }
}
