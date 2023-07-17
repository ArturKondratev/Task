
import UIKit

class AppStartBuilder {
    
    func builder() -> UITabBarController {
        
        let tabBarVC = UITabBarController()
        tabBarVC.tabBar.backgroundColor = .systemBackground
        tabBarVC.tabBar.barTintColor = .systemGray6
        tabBarVC.tabBar.tintColor = .systemBlue
        
        let mainModul = MainCoordinator().start()
        mainModul.title = "Главная"
        
        let searchModul = UINavigationController(rootViewController: SearchVC())
        searchModul.title = "Поиск"
        
        let CartModul = UINavigationController(rootViewController: CartVCBuilder.craeteCartVCBuilder() )
        CartModul.title = "Корзина"
        
        let accauntModul = UINavigationController(rootViewController: AccauntVC())
        accauntModul.title = "Аккаунт"
        
        tabBarVC.setViewControllers([mainModul, searchModul, CartModul, accauntModul], animated: true)
        
        let images = ["Главная", "Поиск", "Корзина", "Аккаунт"]
        if let items = tabBarVC.tabBar.items {
            for x in 0..<items.count {
                items[x].image = UIImage(named: images[x])
            }
        }
        return tabBarVC
    }
}
