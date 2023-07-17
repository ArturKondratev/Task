
import Foundation

struct DishCellModel {
    let id: Int
    let name: String
    let imageURL: String
}

class DishCellModelFactory {
    static func cellModel(from model: [Dish]) -> [DishCellModel] {
        return model.compactMap { model -> DishCellModel in
            return DishCellModel(id: model.id, name: model.name, imageURL: model.imageURL)
        }
    }
}
