
import UIKit

class SearchCell: UICollectionViewCell {
    
    static let identifier = "SearchCell"
    
    // MARK: - Subviews
    lazy var tagLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        tagLabel.text = nil
        contentView.backgroundColor = .systemBackground
    }
    
    // MARK: - Functions
    func configure(tag: String) {
        self.tagLabel.text = tag
    }
    
    func selectCell(state: Bool) {
        if state {
            contentView.backgroundColor = .systemBlue
            tagLabel.textColor = .white
            
        } else {
            contentView.backgroundColor = .systemGray6
            tagLabel.textColor = .black
        }
    }
    
    // MARK: - UI
    func setUI() {
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        addSubview(tagLabel)
        
        NSLayoutConstraint.activate([
            tagLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            tagLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
