//
//  LotImageCarouselView.swift
//  Bidly
//
//  Created by Baytik  on 22/4/25.
//

import UIKit

final class LotImageCarouselView: UIView {
    
    // MARK: - Properties
    
    var imageUrls: [String] = [] {
        didSet {
            mainCarousel.reloadData()
            thumbnailCarousel.reloadData()
        }
    }
    
    private var currentIndex: Int = 0 {
        didSet {
            thumbnailCarousel.selectItem(at: IndexPath(item: currentIndex, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        }
    }
    
    // MARK: - Subviews
    
    private lazy var mainCarousel: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 300)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        return collectionView
    }()
    
    private lazy var thumbnailCarousel: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        layout.itemSize = CGSize(width: 60, height: 60)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ThumbnailCell.self, forCellWithReuseIdentifier: "ThumbnailCell")
        return collectionView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        let stack = UIStackView(arrangedSubviews: [mainCarousel, thumbnailCarousel])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            mainCarousel.heightAnchor.constraint(equalToConstant: 300),
            thumbnailCarousel.heightAnchor.constraint(equalToConstant: 60),
            
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource & Delegate

extension LotImageCarouselView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let image = UIImage(named: imageUrls[indexPath.item])
        
        if collectionView == mainCarousel {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell else { return UICollectionViewCell() }
            cell.configure(with: image)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThumbnailCell", for: indexPath) as? ThumbnailCell else { return UICollectionViewCell() }
            cell.configure(with: image, isSelected: indexPath.item == currentIndex)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == thumbnailCarousel {
            currentIndex = indexPath.item
            mainCarousel.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == mainCarousel {
            let visibleRect = CGRect(origin: mainCarousel.contentOffset, size: mainCarousel.bounds.size)
            if let indexPath = mainCarousel.indexPathForItem(at: CGPoint(x: visibleRect.midX, y: visibleRect.midY)) {
                currentIndex = indexPath.item
            }
        }
    }
}
