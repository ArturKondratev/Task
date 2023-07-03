
import UIKit
import Combine

class CartViewModel {
    
    @Published var dishInCard = [Dish]()
    @Published var totalCost = 0
    
    private var foodCaretaker: FoodCaretakerProtocol
    private var imageLoader: ImageLoaderProtocol
    
    //MARK: - LifeCycle
    init(imageLoader: ImageLoaderProtocol,
         foodCaretaker: FoodCaretakerProtocol) {
        self.imageLoader = imageLoader
        self.foodCaretaker = foodCaretaker
    }
    
    func viewWillAppear() {
        self.dishInCard = self.foodCaretaker.retrieveDishs()
        self.calculateTotal()
    }
    
    func viewWillDisappear() {
        foodCaretaker.saveDish(dish: dishInCard)
    }
    
    //MARK: - Function
    func calculateTotal() {
        var cost = 0
        for (_, element) in dishInCard.enumerated() {
            cost += element.price * element.count
        }
        self.totalCost = cost
    }
    
    func loadImage(url: String, imageView: UIImageView) {
        DispatchQueue.global(qos: .default).async {
            guard let url = URL(string: url) else {
                DispatchQueue.main.async {
                    imageView.image = UIImage(systemName: "star")
                }
                return
            }
            self.imageLoader.downloadImage(url: url) { image in
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
        }
    }
    
    //MARK: - Function
    func plusButtonAction(index: IndexPath) {
        dishInCard[index.row].count += 1
        calculateTotal()
    }
    
    func minusButtonAction(index: IndexPath) {
        if dishInCard[index.row].count == 1 {
            dishInCard.remove(at: index.row)
        } else {
            dishInCard[index.row].count -= 1
        }
        calculateTotal()
    }
}
