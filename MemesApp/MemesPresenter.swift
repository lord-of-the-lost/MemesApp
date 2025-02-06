//
//  MemesPresenter.swift
//  MemesApp
//
//  Created by Николай Игнатов on 05.02.2025.
//

import UIKit

// MARK: - Protocols
protocol MemesViewProtocol: AnyObject {
    func setMemeImage(_ image: UIImage)
    func showError(_ message: String)
}

protocol MemesPresenterProtocol {
    func setupView(_ view: MemesViewProtocol)
    func viewDidLoad()
    func searchTextChanged(_ text: String)
    func getMemeTapped()
    func likeTapped()
    func dislikeTapped()
}

// MARK: - Presenter
final class MemesPresenter: MemesPresenterProtocol {
    weak var view: MemesViewProtocol?
    private let networkService: NetworkServiceProtocol
    private var memes: [Meme] = []
    private var currentMeme: Meme?
    private var searchText: String = ""
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func setupView(_ view: MemesViewProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        loadMemes()
    }
    
    func searchTextChanged(_ text: String) {
        searchText = text
    }
    
    func getMemeTapped() {
        guard !searchText.isEmpty else {
            view?.showError("Введите текст для поиска")
            return
        }
        
        guard !memes.isEmpty else {
            view?.showError("Мемы не загружены")
            return
        }
        
        getNewMeme()
    }
    
    func likeTapped() {
    
    }
    
    func dislikeTapped() {
        getNewMeme()
    }
}

// MARK: - private Methods
private extension MemesPresenter {
    func getNewMeme() {
        currentMeme = memes.randomElement()
        loadCurrentMemeImage()
    }
    
    func loadMemes() {
        networkService.fetchData { [weak self] result in
            switch result {
            case .success(let memes):
                self?.memes = memes
            case .failure(let error):
                self?.view?.showError("Ошибка загрузки мемов: \(error.localizedDescription)")
            }
        }
    }
    
    func loadCurrentMemeImage() {
        guard let currentMeme else { return }
        
        networkService.loadImage(from: currentMeme.url) { [weak self] result in
            switch result {
            case .success(let image):
                self?.view?.setMemeImage(image)
            case .failure(let error):
                self?.view?.showError("Ошибка загрузки изображения: \(error.localizedDescription)")
            }
        }
    }
}
