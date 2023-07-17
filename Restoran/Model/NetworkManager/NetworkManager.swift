
import UIKit

fileprivate enum TypeMethods: String {
    case getDishes = "/v3/aba7ecaa-0a70-453b-b62d-0e326c859b3b"
}

fileprivate enum TypeRequest: String {
    case get = "GET"
}

class NetworkManager: NetworkManagerProtocol {
    
    private let scheme = "https"
    private let host = "run.mocky.io"
    private let decoder = JSONDecoder()
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        return session
    }()
    
    func loadCategory(completion: @escaping ([CategoryModel]) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let category = [
                CategoryModel(image: "Image1", name: "Пекарни и кондитерские"),
                CategoryModel(image: "Image2", name: "Фастфуд"),
                CategoryModel(image: "Image3", name: "Азиатская кухня"),
                CategoryModel(image: "Image4", name: "Супы"),
            ]
            completion(category)
        }
    }
    
    func loadDish(completion: @escaping ([Dish]) -> Void) {
        let url = configureUrl(method: .getDishes, httpMethod: .get)
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard
                let data = data,
                let results = try? self.decoder.decode(Food.self, from: data)
            else { return }
            
            let resultModel: [Dish] = results.dishes.map { dish in
                let rModel = Dish(id: dish.id ?? 0,
                                  name: dish.name ?? "",
                                  price: dish.price ?? 0,
                                  weight: dish.weight ?? 0,
                                  description: dish.description ?? "",
                                  imageURL: dish.imageURL ?? "",
                                  tegs: dish.tegs ?? [""],
                                  count: 1)
                return rModel
            }
            completion(resultModel)
        }
        .resume()
    }
}

private extension NetworkManager {
    func configureUrl(method: TypeMethods,
                      httpMethod: TypeRequest) -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = method.rawValue
        
        guard let url = urlComponents.url else {
            fatalError("URL is invalid")
        }
        return url
    }
}
