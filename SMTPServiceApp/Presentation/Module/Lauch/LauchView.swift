import UIKit

final class LauchView: UIView {
    
    // MARK: - UI Components
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var splashImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textAlignment = .justified
        label.numberOfLines = 7
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func configure(with item: LauchItem) {
        titleLabel.text = item.title
        splashImage.image = UIImage(named: item.image)
        descriptionLabel.text = item.description
        
        // Добавляем анимацию появления
        animateAppearance()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        backgroundColor = UIColor.hex("343248")
        
        addSubview(titleLabel)
        addSubview(splashImage)
        addSubview(descriptionLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Title Label
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            titleLabel.bottomAnchor.constraint(equalTo: splashImage.topAnchor, constant: -30),
            
            // Splash Image
            splashImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            splashImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            splashImage.heightAnchor.constraint(equalToConstant: 200),
            splashImage.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, constant: -30),
            
            // Description Label
            descriptionLabel.topAnchor.constraint(equalTo: splashImage.bottomAnchor, constant: 30),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -15)
        ])
    }
    
    private func animateAppearance() {
        titleLabel.alpha = 0
        splashImage.alpha = 0
        descriptionLabel.alpha = 0
        
        UIView.animate(withDuration: 0.6, delay: 0.1, options: .curveEaseInOut) {
            self.titleLabel.alpha = 1
        }
        
        UIView.animate(withDuration: 0.6, delay: 0.3, options: .curveEaseInOut) {
            self.splashImage.alpha = 1
        }
        
        UIView.animate(withDuration: 0.6, delay: 0.5, options: .curveEaseInOut) {
            self.descriptionLabel.alpha = 1
        }
    }
}
