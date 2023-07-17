
import UIKit

class DishCell: UICollectionViewCell {
    
    //MARK: - Properis
    static let identifier = "DishCell"
    
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
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 2
        return label
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        foodImage.image = nil
        nameLable.text = nil
    }
    
    func configure(name: String) {
        self.nameLable.text = name
    }
    
    //MARK: - SetUI
    func setUI() {
        backgroundColor = .systemBackground
        contentView.addSubview(foodImage)
        contentView.addSubview(nameLable)
        
        NSLayoutConstraint.activate([
            foodImage.topAnchor.constraint(equalTo: topAnchor),
            foodImage.leftAnchor.constraint(equalTo: leftAnchor),
            foodImage.rightAnchor.constraint(equalTo: rightAnchor),
            foodImage.heightAnchor.constraint(equalToConstant: contentView.frame.width),
            
            nameLable.topAnchor.constraint(equalTo: foodImage.bottomAnchor , constant: 5),
            nameLable.leftAnchor.constraint(equalTo: leftAnchor),
            nameLable.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
}
