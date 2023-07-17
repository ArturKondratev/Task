
import UIKit

class SelectFoodBuilder {
    static func createSelectFoodModul(coordinator: MainCoordinator, categiryModel: CategoryModel) -> UIViewController {
        let networkManager = NetworkManager()
        let imageLoader = ImageLoader()
        let foodCaretaker = FoodCaretaker()
        let viewModel = SelectFoodViewModel(networkManager: networkManager,
                                            imageLoader: imageLoader,
                                            foodCaretaker: foodCaretaker)
        viewModel.coordinator = coordinator
        let view = SelectFoodViewController(viewModel: viewModel, categiryModel: categiryModel)
        return view
    }
}
