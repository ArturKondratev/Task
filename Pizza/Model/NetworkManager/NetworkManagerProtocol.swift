

import Foundation

protocol NetworkManagerProtocol {
    func loadCategory(completion: @escaping ([CategoryModel]) -> Void)
    func loadDish(completion: @escaping ([Dish]) -> Void)
}
