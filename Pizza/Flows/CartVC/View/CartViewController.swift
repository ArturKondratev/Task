
import UIKit
import Combine

class CartViewController: UIViewController {
    // MARK: - Properties
    var foodInCart = [Dish]()
    let viewModel: CartViewModel
    var cancellables = Set<AnyCancellable>()
    
    var cartView: CartView {
        return self.view as! CartView
    }
    
    //MARK: - LifeCycle
    init(viewModel: CartViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = CartView()
        cartView.collectionView.delegate = self
        cartView.collectionView.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.viewWillDisappear()
    }
    
    func bindViewModel() {
        viewModel.$dishInCard
            .sink { [weak self] dish in
                self?.foodInCart = dish
                self?.cartView.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$totalCost
            .sink { [weak self] cost in
                if cost == 0 {
                    self?.cartView.payButton.setTitle("Оплатить", for: .normal)
                } else {
                    self?.cartView.payButton.setTitle("Оплатить \(cost)", for: .normal)
                }
            }
            .store(in: &cancellables)
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension CartViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodInCart.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CartCell.identifier, for: indexPath) as? CartCell else { return UICollectionViewCell() }
        cell.delgate = self
        let model = foodInCart[indexPath.row]
        cell.configure(model: model)
        viewModel.loadImage(url: model.imageURL, imageView: cell.foodImage)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 62)
    }
}

//MARK: - CartCellDelegate
extension CartViewController: CartCellDelegate {
    func didTabPlusButton(from cell: UICollectionViewCell) {
        if let index = cartView.collectionView.indexPath(for: cell) {
            viewModel.plusButtonAction(index: index)
        }
    }
    
    func didTabMinusButton(from cell: UICollectionViewCell) {
        if let index = cartView.collectionView.indexPath(for: cell) {
            viewModel.minusButtonAction(index: index)
        }
    }
    
    //MARK: - NavBarConfigure
    private func configureNavBar() {
        title = "Корзина"
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = createAvatarView(name: "avatar")
        navigationItem.titleView = createCustomTitleView(cityName: "Санкт-Петербург", date: .now)
    }
    
    private func createAvatarView(name: String) -> UIBarButtonItem {
        let iconView = UIImageView()
        iconView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        iconView.contentMode = .scaleAspectFit
        iconView.image = UIImage(named: name)
        let avatarView = UIBarButtonItem(customView: iconView)
        return avatarView
    }
    
    private func createCustomTitleView(cityName: String, date: Date) -> UIView {
        let dateFormatter: DateFormatter = {
            let df = DateFormatter()
            df.locale = Locale(identifier: "ru")
            df.dateFormat = "d MMMM, yyy"
            return df
        }()
        let stringDate = dateFormatter.string(from: date)
        
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 280, height: 41)
        
        let location = UIImageView()
        location.image = UIImage(named: "location")
        location.layer.cornerRadius = location.frame.height / 2
        location.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        view.addSubview(location)
        
        let cityLabel = UILabel()
        cityLabel.text = cityName
        cityLabel.frame = CGRect(x: 40, y: 0, width: 220, height: 20)
        cityLabel.font = UIFont.systemFont(ofSize: 20)
        view.addSubview(cityLabel)
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = stringDate
        descriptionLabel.frame = CGRect(x: 40, y: 21, width: 220, height: 20)
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        view.addSubview(descriptionLabel)
        
        return view
    }
}
