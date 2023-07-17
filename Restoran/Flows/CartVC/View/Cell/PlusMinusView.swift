
import UIKit

protocol PlusMinusViewProtocol: AnyObject {
    func tabPlusButton()
    func tabMinusButton()
}

class PlusMinusView: UIView {
    
    weak var delegate: PlusMinusViewProtocol?
    
    //MARK: - Subviews
    
    lazy var countLable: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.textAlignment = .center
        label.text = "1"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    lazy var plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.setImage(UIImage(named: "plus"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(plusButtonAction), for: .touchUpInside)
        return button
    }()
    
    lazy var minusButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.setImage(UIImage(named: "minus"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(minusButtonAction), for: .touchUpInside)
        return button
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .clear
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    //MARK: - Action
    @objc func plusButtonAction() {
        delegate?.tabPlusButton()
    }
    
    @objc func minusButtonAction() {
        delegate?.tabMinusButton()
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addViews()
    }
    
    // MARK: - UI
    func addViews() {
        backgroundColor = .systemGray5
        layer.cornerRadius = 12
        clipsToBounds = true
        
        addSubview(stackView)
        stackView.addArrangedSubview(minusButton)
        stackView.addArrangedSubview(countLable)
        stackView.addArrangedSubview(plusButton)
        
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 6),
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -6),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
