
import UIKit
import Combine

class SelectFoodViewModel {
    
    // MARK: - PublishedProperties
    @Published var allTags = [String]()
    @Published var filtredDish = [DishCellModel]()
    @Published var selectCategory = ""
    @Published var showDetailView: Bool = false
    var dishForDetailView: Dish?
    
    // MARK: - Properties
    private let networkManager: NetworkManagerProtocol
    private let foodCaretaker: FoodCaretakerProtocol
    private let imageLoader: ImageLoaderProtocol
    weak var coordinator: MainCoordinator?
    private var allDish = [Dish]()
    
    // MARK: - Init
    init(networkManager: NetworkManagerProtocol,
         imageLoader: ImageLoaderProtocol,
         foodCaretaker: FoodCaretakerProtocol) {
        self.networkManager = networkManager
        self.imageLoader = imageLoader
        self.foodCaretaker = foodCaretaker
    }
    
    //MARK: - Functions
    func viewDidLoad() {
        fetchDish()
    }
    
    private func fetchDish() {
        networkManager.loadDish { dish in
            var tags = [String]()
            
            for i in dish {
                for tag in i.tegs {
                    if !tags.contains(tag) {
                        tags.append(tag)
                    }
                }
            }
            self.allTags = tags
            self.selectCategory = tags[0]
            self.filtredDish = DishCellModelFactory.cellModel(from: dish)
            self.allDish = dish
        }
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
    
    func didSelectDish(indexPath: IndexPath) {
        guard let model = allDish.first(where: { $0.id == filtredDish[indexPath.row].id }) else { return }
        self.dishForDetailView = model
        self.showDetailView = true
    }
    
    func didSelectCategory(indexPath: IndexPath) {
        let tag = allTags[indexPath.row]
        var filtredDish = [Dish]()
        
        for (_, element) in allDish.enumerated() {
            if element.tegs.contains(tag) {
                filtredDish.append(element)
            }
        }
        self.selectCategory = allTags[indexPath.row]
        self.filtredDish = DishCellModelFactory.cellModel(from: filtredDish)
    }
    
    func didTabAddDishButton() {
        if let dish = dishForDetailView {
            DispatchQueue.global(qos: .default).async {
                self.foodCaretaker.addNewDish(dish: dish)
            }
        }
        showDetailView = false
    }
    
    func didTabCloseButton() {
        showDetailView = false
    }
}
