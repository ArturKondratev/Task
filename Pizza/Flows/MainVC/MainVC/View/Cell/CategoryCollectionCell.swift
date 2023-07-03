

import UIKit

class CategoryCollectionCell: UICollectionViewCell {
    
    //MARK: - Properis
    static let identifier = "CategoryCollectionCell"
    
    //MARK: - SubViews
    lazy var mainImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 16
        image.clipsToBounds = true
        return image
    }()
    
    lazy var nameText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.numberOfLines = 3
        return label
    }()
    
    // MARK: - Private constants
    private enum UIConstants {
        static let top: CGFloat = 12
        static let left: CGFloat = 16
    }
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(image: UIImage, name: String) {
        self.mainImage.image = image
        //  self.nameText.text = name
    }
    
    //MARK: - SetUI
    func setUI() {
        backgroundColor = .systemGray6
        contentView.addSubview(mainImage)
        contentView.addSubview(nameText)
        
        NSLayoutConstraint.activate([
            mainImage.topAnchor.constraint(equalTo: topAnchor),
            mainImage.leftAnchor.constraint(equalTo: leftAnchor),
            mainImage.rightAnchor.constraint(equalTo: rightAnchor),
            mainImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            nameText.topAnchor.constraint(equalTo: topAnchor, constant: UIConstants.top),
            nameText.leftAnchor.constraint(equalTo: leftAnchor, constant: UIConstants.left),
            nameText.rightAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
