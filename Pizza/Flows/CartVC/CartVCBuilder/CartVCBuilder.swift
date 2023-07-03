
import UIKit

class CartVCBuilder {
    
    static func craeteCartVCBuilder() -> UIViewController {
        let imageLoader = ImageLoader()
        let foodCaretaker = FoodCaretaker()
        let viewModel = CartViewModel(imageLoader: imageLoader,
                                      foodCaretaker: foodCaretaker)
        let view = CartViewController(viewModel: viewModel)
        return view
    }
}
