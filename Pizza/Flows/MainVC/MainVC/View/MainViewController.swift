
import UIKit
import Combine

class MainViewController: UIViewController {
    
    // MARK: - Private Properties
    private let viewModel: MainVcVewModel
    private var cancellables = Set<AnyCancellable>()
    private var allCategory = [CategoryModel]() {
        didSet {
            mainView.collectionView.reloadData()
        }
    }
    private var mainView: MainView {
        return self.view as! MainView
    }
    
    //MARK: - LifeCycle
    init(viewModel: MainVcVewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = MainView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        mainView.collectionView.dataSource = self
        mainView.collectionView.delegate = self
        viewModel.viewDidLoad()
        bindViewModel()
    }
    
    //MARK: - Functions
    func bindViewModel() {
        viewModel.$category
            .sink { [weak self] category in
                self?.allCategory = category
                self?.mainView.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionCell.identifier, for: indexPath) as? CategoryCollectionCell else { return UICollectionViewCell() }
        let model = allCategory[indexPath.row]
        cell.configure(image: UIImage(named: model.image) ?? UIImage(),
                       name: model.name)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectItemAt(indexPath: indexPath)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: collectionView.frame.height / 4)
    }
}

//MARK: - NavBarConfigure
extension MainViewController {
    
    private func configureNavBar() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = createAvatarView(name: "avatar")
        navigationItem.titleView = createCustomTitleView(cityName: "Санкт-Петербург", date: .now)
    }
    
    func createAvatarView(name: String) -> UIBarButtonItem {
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
