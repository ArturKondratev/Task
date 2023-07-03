
import UIKit
import Combine

class MainVcVewModel {
    
    // MARK: - PublishedProperties
    @Published var category = [CategoryModel]()
    
    // MARK: - Properties
    let networkManager: NetworkManagerProtocol
    let coordinator: MainCoordinator?
    
    // MARK: - Init
    init(networkManager: NetworkManagerProtocol, coordinator: MainCoordinator) {
        self.networkManager = networkManager
        self.coordinator = coordinator
    }
    
    //MARK: - Functions
    func viewDidLoad() {
        networkManager.loadCategory { category in
            self.category = category
        }
    }
    
    func didSelectItemAt(indexPath: IndexPath) {
        print(indexPath)
        coordinator?.goToSelectFoodVC(with: category[indexPath.row])
    }
}
