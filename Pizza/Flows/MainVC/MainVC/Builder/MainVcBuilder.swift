
import UIKit

class MainVcBuilder {
    static func createMainModul(coordinator: MainCoordinator) -> UIViewController {
        let networkManager = NetworkManager()
        let viewModel = MainVcVewModel(networkManager: networkManager, coordinator: coordinator)
        let view = MainViewController(viewModel: viewModel)
        return view
    }
}
