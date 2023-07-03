
import UIKit

protocol FoodCaretakerProtocol {
    func saveDish(dish: [Dish])
    func addNewDish(dish: Dish)
    func retrieveDishs() -> [Dish]
}

class FoodCaretaker: FoodCaretakerProtocol {
    
    // MARK: - Properties
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    private let key = "food"
    private let caretakerQueue = DispatchQueue(label: "FoodCaretakerSyncQueue", attributes: .concurrent)
    
    // MARK: - Functions
    func saveDish(dish: [Dish]) {
        caretakerQueue.async(flags: .barrier) {
            do {
                let data = try self.encoder.encode(dish)
                UserDefaults.standard.set(data, forKey: self.key)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func addNewDish(dish: Dish) {
        caretakerQueue.async {
            var list = self.retrieveDishs()
            
            if list.contains(dish) {
                if let i = list.firstIndex(where: { $0.id == dish.id }) {
                    list[i].count += 1
                }
            } else {
                list.append(dish)
            }
            self.saveDish(dish: list)
        }
    }
    
    func retrieveDishs() -> [Dish] {
        var eptylist = [Dish]()
        caretakerQueue.sync {
            guard let data = UserDefaults.standard.data(forKey: self.key) else {
                return
            }
            do {
                let list = try self.decoder.decode([Dish].self, from: data)
                eptylist = list
            } catch {
                print(error.localizedDescription)
                return
            }
        }
        return eptylist
    }
}
