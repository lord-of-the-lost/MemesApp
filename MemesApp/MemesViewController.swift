//
//  MemesViewController.swift
//  MemesApp
//
//  Created by Николай Игнатов on 03.02.2025.
//

import UIKit

final class MemesViewController: UIViewController {
    private let presenter: MemesPresenterProtocol

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Введите ваш запрос"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private lazy var memesView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var getMemesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Получить предсказание", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .purple.withAlphaComponent(0.6)
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(getMemesButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var dislikeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("👎", for: .normal)
        button.backgroundColor = .red.withAlphaComponent(0.6)
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(dislikeButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("👍", for: .normal)
        button.backgroundColor = .green.withAlphaComponent(0.6)
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(presenter: MemesPresenterProtocol = MemesPresenter()) {
         self.presenter = presenter
         super.init(nibName: nil, bundle: nil)
     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
     
     override func viewDidLoad() {
         super.viewDidLoad()
         setupView()
         setupConstraints()
         presenter.setupView(self)
         presenter.viewDidLoad()
     }
}


// MARK: - UISearchBarDelegate
extension MemesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.searchTextChanged(searchText)
    }
}

// MARK: - MemesViewProtocol
extension MemesViewController: MemesViewProtocol {
    func setMemeImage(_ image: UIImage) {
        DispatchQueue.main.async {
            self.memesView.image = image
        }
    }
    
    func showError(_ message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Ошибка",
                message: message,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
}

// MARK: - Private Methods
private extension MemesViewController {
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(searchBar)
        view.addSubview(getMemesButton)
        view.addSubview(memesView)
        view.addSubview(dislikeButton)
        view.addSubview(likeButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            getMemesButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            getMemesButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            getMemesButton.heightAnchor.constraint(equalToConstant: 60),
            getMemesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            memesView.topAnchor.constraint(equalTo: getMemesButton.bottomAnchor, constant: 20),
            memesView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            memesView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            memesView.bottomAnchor.constraint(equalTo: dislikeButton.topAnchor, constant: -20),
            
            dislikeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            dislikeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -40),
            dislikeButton.widthAnchor.constraint(equalToConstant: 60),
            dislikeButton.heightAnchor.constraint(equalToConstant: 60),
            
            likeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            likeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 40),
            likeButton.widthAnchor.constraint(equalToConstant: 60),
            likeButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    @objc func getMemesButtonTapped() {
        presenter.getMemeTapped()
    }
    
    @objc func dislikeButtonTapped() {
        presenter.dislikeTapped()
    }
    
    @objc func likeButtonTapped() {
        presenter.likeTapped()
    }
}
