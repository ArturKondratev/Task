
import UIKit

protocol CartCellDelegate: AnyObject {
    func didTabPlusButton(from cell: UICollectionViewCell)
    func didTabMinusButton(from cell: UICollectionViewCell)
}

class CartCell: UICollectionViewCell {
    
    //MARK: - Properis
    weak var delgate: CartCellDelegate?
    static let identifier = "SelectFoodCell"
    
    //MARK: - SubViews
    lazy var foodImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 16
        image.clipsToBounds = true
        return image
    }()
    
    lazy var nameLable: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        return label
    }()
    
    lazy var costLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var weightlabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray3
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var plusMinusView: PlusMinusView = {
        let view = PlusMinusView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(model: Dish) {
        nameLable.text = model.name
        costLabel.text = model.price.description
        weightlabel.text = model.weight.description
        plusMinusView.countLable.text = model.count.description
    }
    
    //MARK: - SetUI
    func setUI() {
        backgroundColor = .white
        contentView.addSubview(foodImage)
        contentView.addSubview(nameLable)
        contentView.addSubview(costLabel)
        contentView.addSubview(weightlabel)
        contentView.addSubview(plusMinusView)
        
        NSLayoutConstraint.activate([
            foodImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            foodImage.leftAnchor.constraint(equalTo: leftAnchor),
            foodImage.heightAnchor.constraint(equalToConstant: contentView.frame.height),
            foodImage.widthAnchor.constraint(equalToConstant: contentView.frame.height),
            
            nameLable.topAnchor.constraint(equalTo: foodImage.topAnchor),
            nameLable.leftAnchor.constraint(equalTo: foodImage.rightAnchor, constant: 8),
            nameLable.rightAnchor.constraint(equalTo: plusMinusView.leftAnchor, constant: -10),
            
            costLabel.topAnchor.constraint(equalTo: nameLable.bottomAnchor, constant: 4),
            costLabel.leftAnchor.constraint(equalTo: nameLable.leftAnchor),
            
            weightlabel.topAnchor.constraint(equalTo: costLabel.topAnchor),
            weightlabel.leftAnchor.constraint(equalTo: costLabel.rightAnchor, constant: 4),
            
            plusMinusView.centerYAnchor.constraint(equalTo: centerYAnchor),
            plusMinusView.rightAnchor.constraint(equalTo: rightAnchor),
            plusMinusView.heightAnchor.constraint(equalToConstant: 32),
            plusMinusView.widthAnchor.constraint(equalToConstant: 99)
        ])
    }
}

extension CartCell: PlusMinusViewProtocol {
    func tabPlusButton() {
        delgate?.didTabPlusButton(from: self)
    }
    
    func tabMinusButton() {
        delgate?.didTabMinusButton(from: self)
    }
}
