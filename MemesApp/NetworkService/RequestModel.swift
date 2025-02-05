//
//  RequestModel.swift
//  MemesApp
//
//  Created by Николай Игнатов on 05.02.2025.
//

import Foundation

struct Meme: Decodable {
    let id: String
    let name: String
    let url: String
}

struct MemeResponse: Decodable {
    let success: Bool
    let data: MemeData
}

struct MemeData: Decodable {
    let memes: [Meme]
}
