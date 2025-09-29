import UIKit

class UserDomainCollectionLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        self.setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupLayout()
    }
    
    private func setupLayout() {
        self.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        self.minimumLineSpacing = 16
        self.scrollDirection = .vertical
        self.sectionInset = .init(top: 16, left: 16, bottom: 16, right: 16)
    }
}
