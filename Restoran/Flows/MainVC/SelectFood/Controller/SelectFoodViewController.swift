
import UIKit
import Combine

class SelectFoodViewController: UIViewController {
    
    private let viewModel: SelectFoodViewModel
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - Propertis
    var dish = [DishCellModel]()
    var allTags = [String]()
    var selectedTag = ""
    let categiryModel: CategoryModel
    let detailVC = DishDetailView()
    var selectFoodView: SelectFoodView {
        return self.view as! SelectFoodView
    }
    
    //MARK: - LifeCycle
    init(viewModel: SelectFoodViewModel, categiryModel: CategoryModel) {
        self.viewModel = viewModel
        self.categiryModel = categiryModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = SelectFoodView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        selectFoodView.collectionView.dataSource = self
        selectFoodView.collectionView.delegate = self
        viewModel.viewDidLoad()
        bindViewModel()
        title = categiryModel.name
    }
    
    //MARK: - Functions
    func bindViewModel() {
        viewModel.$filtredDish
            .sink { [weak self] dish in
                self?.dish = dish
                DispatchQueue.main.async {
                    self?.selectFoodView.collectionView.reloadData()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$allTags
            .sink { [weak self] tags in
                self?.allTags = tags
            }
            .store(in: &cancellables)
        
        viewModel.$selectCategory
            .sink { [weak self] tag in
                self?.selectedTag = tag
            }
            .store(in: &cancellables)
        
        viewModel.$showDetailView
            .sink { [weak self] state in
                if state {
                    self?.showDetailView()
                } else {
                    self?.dismissAlert()
                }
            }
            .store(in: &cancellables)
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension SelectFoodViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return dish.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DishCell.identifier,
                                                          for: indexPath) as? DishCell else { return UICollectionViewCell() }
        let model = dish[indexPath.row]
        cell.configure(name: model.name)
        viewModel.loadImage(url: model.imageURL, imageView: cell.foodImage)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchBarCell.identifier, for: indexPath) as! SearchBarCell
        header.delegate = self
        header.configure(allTags: allTags, selectedTag: selectedTag)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectDish(indexPath: indexPath)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension SelectFoodViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width,
                      height: 51)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 16, left: 0, bottom: 0, right: 0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (collectionView.frame.width - 24) / 3,
               height: 170)
    }
}

//MARK: - SearchBarCellDelegate
extension SelectFoodViewController: SearchBarCellDelegate {
    func didSelectItemAt(indexPath: IndexPath) {
        viewModel.didSelectCategory(indexPath: indexPath)
    }
}

//MARK: - NavBarConfigure
extension SelectFoodViewController: DishDetailViewDelegate {
    @objc func didTabHeartButton() {
        print("didTabHeartButton")
    }
    
    @objc func didTabCloseButton() {
        viewModel.didTabCloseButton()
    }
    
    @objc func didTabAddButton() {
        viewModel.didTabAddDishButton()
    }
    
    func dismissAlert() {
        self.detailVC.dismissAlert()
    }
    
    func showDetailView() {
        guard let model = viewModel.dishForDetailView else { return }
        detailVC.delegate = self
        self.detailVC.showAlert(with: model, on: self)
    }
    
    private func configureNavBar() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = createAvatarView(name: "avatar")
    }
    
    func createAvatarView(name: String) -> UIBarButtonItem {
        let iconView = UIImageView()
        iconView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        iconView.contentMode = .scaleAspectFit
        iconView.image = UIImage(named: name)
        let avatarView = UIBarButtonItem(customView: iconView)
        return avatarView
    }
}
