//
//  MemesFactory.swift
//  MemesApp
//
//  Created by Николай Игнатов on 07.02.2025.
//

import UIKit

struct MemesFactory {
   static func makeModule(networkService: NetworkServiceProtocol) -> UIViewController {
        let presenter = MemesPresenter(networkService: networkService)
        let viewController = MemesViewController(presenter: presenter)
        presenter.setupView(viewController)
        return viewController
    }
}
