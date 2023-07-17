//
//  DishDetailView.swift
//  Pizza
//
//  Created by Артур Кондратьев on 01.07.2023.
//

import UIKit

protocol DishDetailViewDelegate: AnyObject {
    func didTabHeartButton()
    func didTabCloseButton()
    func didTabAddButton()
}

class DishDetailView {
    
    weak var delegate: DishDetailViewDelegate?
    
    struct Constants {
        static let backgroundAlphaTo: CGFloat = 0.3
        static let imageHeight: Int = 232
        static let addButtonHeight: CGFloat = 48.0
    }
    
    let imageLoader = ImageLoader()
    
    //MARK: - SubViews
    lazy var foodImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 16
        image.clipsToBounds = true
        return image
    }()
    
    lazy var nameLable: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    lazy var costLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    lazy var weightlabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray3
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    lazy var descriptionlabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
    }()
    
    lazy var addToCartButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .link
        button.tintColor = .white
        button.layer.cornerRadius = 14
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitle("Добавить в корзину", for: .normal)
        return button
    }()
    
    lazy var heartButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemGray6
        button.tintColor = .black
        button.layer.cornerRadius = 8
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        return button
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemGray6
        button.tintColor = .black
        button.layer.cornerRadius = 8
        button.setImage(UIImage(systemName: "multiply"), for: .normal)
        return button
    }()
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()
    
    private let alertView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12
        return view
    }()
    
    private var alertViewHeight: CGFloat = 0
    private var alertViewWidth: CGFloat = 0
    private var myTargetView: UIView?
    
    func showAlert(with model: Dish,
                   on viewController: SelectFoodViewController) {
        
        guard let targetView = viewController.view else { return }
        foodImage.image = nil
        
        //MARK: - ItemSize
        let alertViewWidth = targetView.frame.size.width - 32
        self.alertViewWidth = alertViewWidth
        
        let nameLableSize = getLabelSize(text: model.name,
                                         font: .boldSystemFont(ofSize: 17),
                                         maxWidth: alertViewWidth)
        
        let costLabelSize = getLabelSize(text: model.price.description + String("₽"),
                                         font: .boldSystemFont(ofSize: 15),
                                         maxWidth: alertViewWidth)
        
        let weightlabelSize = getLabelSize(text: String(" • ") + model.weight.description + String("г"),
                                           font: .boldSystemFont(ofSize: 15),
                                           maxWidth: alertViewWidth)
        
        let descriptionlabelSize = getLabelSize(text: model.description,
                                                font: .systemFont(ofSize: 15),
                                                maxWidth: alertViewWidth)
        
        let alertViewHeight: CGFloat = 64.0 + CGFloat(Constants.imageHeight) + nameLableSize.height + costLabelSize.height + descriptionlabelSize.height + Constants.addButtonHeight
        self.alertViewHeight = alertViewHeight
        
        //MARK: - targetView
        myTargetView = targetView
        backgroundView.frame = targetView.bounds
        targetView.addSubview(backgroundView)
        
        //MARK: - alertView
        alertView.frame = CGRect(x: 40,
                                 y: targetView.frame.size.height + 300,
                                 width: alertViewWidth,
                                 height: alertViewHeight)
        
        targetView.addSubview(alertView)
        
        //MARK: - foodImage
        foodImage.frame = CGRect(x: 16,
                                 y: 16,
                                 width: Int(alertView.frame.size.width) - 32,
                                 height: Constants.imageHeight)
        loadImage(url: model.imageURL, imageView: foodImage)
        alertView.addSubview(foodImage)
        
        //MARK: - nameLable
        nameLable.frame = CGRect(x: 16,
                                 y: foodImage.frame.height + 24,
                                 width: nameLableSize.width,
                                 height: nameLableSize.height)
        nameLable.text = model.name
        alertView.addSubview(nameLable)
        
        //MARK: - costLabel
        costLabel.frame = CGRect(x: 16,
                                 y: foodImage.frame.height + 24 + nameLableSize.height + 8,
                                 width: costLabelSize.width,
                                 height: costLabelSize.height)
        costLabel.text = model.price.description + String("₽")
        alertView.addSubview(costLabel)
        
        //MARK: - weightlabel
        weightlabel.frame = CGRect(x: 16 + costLabelSize.width,
                                   y: foodImage.frame.height + 24 + nameLableSize.height + 8 ,
                                   width: weightlabelSize.width,
                                   height: weightlabelSize.height)
        weightlabel.text = String(" • ") + model.weight.description + String("г")
        alertView.addSubview(weightlabel)
        
        //MARK: - descriptionlabel
        descriptionlabel.frame = CGRect(x: 16,
                                        y: foodImage.frame.height + 24 + nameLableSize.height + 8 + costLabelSize.height + 8,
                                        width: foodImage.frame.width,
                                        height: descriptionlabelSize.height)
        descriptionlabel.text = model.description
        alertView.addSubview(descriptionlabel)
        
        //MARK: - addToCartButton
        addToCartButton.frame = CGRect(x: 16,
                                       y: alertView.frame.size.height - 64,
                                       width: foodImage.frame.width,
                                       height: Constants.addButtonHeight)
        addToCartButton.addTarget(self, action: #selector(didTabAddButton), for: .touchUpInside)
        alertView.addSubview(addToCartButton)
        
        //MARK: - closeButton
        closeButton.frame = CGRect(x: self.alertViewWidth - 48,
                                   y: 8,
                                   width: 40,
                                   height: 40)
        closeButton.addTarget(self, action: #selector(didTabCloseButton), for: .touchUpInside)
        
        
        alertView.addSubview(closeButton)
        
        //MARK: - heartButton
        heartButton.frame = CGRect(x: self.alertViewWidth - 96,
                                   y: 8,
                                   width: 40,
                                   height: 40)
        heartButton.addTarget(self, action: #selector(didTabHeartButton), for: .touchUpInside)
        alertView.addSubview(heartButton)
        
        //MARK: - Animation
        UIView.animate(withDuration: 0.1) {
            self.backgroundView.alpha = Constants.backgroundAlphaTo
        } completion: { done in
            if done {
                UIView.animate(withDuration: 0.3) {
                    self.alertView.center = targetView.center
                }
            }
        }
    }
    
    func dismissAlert() {
        guard let targetView = myTargetView else { return }
        
        UIView.animate(withDuration: 0.3) {
            self.alertView.frame = CGRect(x: 40,
                                          y: targetView.frame.size.height + self.alertViewHeight,
                                          width: self.alertViewWidth,
                                          height: self.alertViewHeight)
        } completion: { done in
            if done {
                UIView.animate(withDuration: 0.1) {
                    self.backgroundView.alpha = 0
                }
            }
        }
    }
    
    @objc func didTabHeartButton() {
        delegate?.didTabHeartButton()
    }
    
    @objc func didTabCloseButton() {
        delegate?.didTabCloseButton()
    }
    
    @objc func didTabAddButton() {
        delegate?.didTabAddButton()
    }
    
    private func getLabelSize(text: String, font: UIFont, maxWidth: CGFloat) -> CGSize {
        let textBlock = CGSize(width: maxWidth,
                               height: CGFloat.greatestFiniteMagnitude)
        let rect = text.boundingRect(with: textBlock,
                                     options: .usesLineFragmentOrigin,
                                     attributes: [NSAttributedString.Key.font: font],
                                     context: nil)
        let width = Double(rect.size.width)
        let height = Double(rect.size.height)
        let size = CGSize(width: ceil(width), height: ceil(height))
        return size
    }
    
    private func loadImage(url: String, imageView: UIImageView) {
        DispatchQueue.global(qos: .default).async {
            guard let url = URL(string: url) else {
                DispatchQueue.main.async {
                    imageView.image = UIImage(systemName: "star")
                }
                return
            }
            self.imageLoader.downloadImage(url: url) { image in
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
        }
    }
}
