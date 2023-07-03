//
//  MainCoordinator.swift
//  Pizza
//
//  Created by Артур Кондратьев on 30.06.2023.
//

import UIKit

class MainCoordinator {
    
    var navigatinController: UINavigationController
    
    init() {
        self.navigatinController = UINavigationController()
    }
    
    func start() -> UINavigationController {
        goToMainVC()
        return navigatinController
    }
    
    func goToMainVC() {
        let mainVC = MainVcBuilder.createMainModul(coordinator: self)
        navigatinController.pushViewController(mainVC, animated: true)
    }
    
    func goToSelectFoodVC(with model: CategoryModel) {
        let selectVC = SelectFoodBuilder.createSelectFoodModul(coordinator: self, categiryModel: model)
        navigatinController.pushViewController(selectVC, animated: true)
    }
}
