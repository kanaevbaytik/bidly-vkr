//
//  NewsCarouselView.swift
//  Bidly
//
//  Created by Baytik  on 12/6/25.
//

import Foundation
import UIKit

class NewsCarouselView: UIView {
    private let collectionView: UICollectionView
    private let newsItems: [(icon: UIImage?, text: String)] = [
        (UIImage(systemName: "gavel"), "Новые правила аукциона"),
        (UIImage(systemName: "sparkles"), "Обновление версии 2.5"),
        (UIImage(systemName: "bell"), "Акция: без комиссии"),
        (UIImage(systemName: "chart.bar"), "Статистика лотов")
    ]
    private let gradientColors: [[CGColor]] = [
        // Сине-фиолетовый → Голубой
        [UIColor(hex: "#56549EFF")!.cgColor, UIColor(hex: "#58CFEFFF")!.cgColor],
        
        // Фиолетовый → Изумрудный
        [UIColor(hex: "#56549EFF")!.cgColor, UIColor(hex: "#3DC9A6FF")!.cgColor],
        
        // Фиолетовый → Розовый
        [UIColor(hex: "#56549EFF")!.cgColor, UIColor(hex: "#E79DA7FF")!.cgColor],
        
        // Фиолетовый → Лавандовый
        [UIColor(hex: "#56549EFF")!.cgColor, UIColor(hex: "#B2A1F7FF")!.cgColor]
    ]
    
    override init(frame: CGRect = .zero) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top:0, left:0, bottom:0, right:0)
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI() {
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(NewsCarouselCell.self, forCellWithReuseIdentifier: "NewsCarouselCell")
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension NewsCarouselView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ cv: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        newsItems.count
    }
    
    func collectionView(_ cv: UICollectionView, cellForItemAt idx: IndexPath) -> UICollectionViewCell {
        let cell = cv.dequeueReusableCell(withReuseIdentifier: "NewsCarouselCell", for: idx) as! NewsCarouselCell
        let item = newsItems[idx.item]
        let gradient = gradientColors[idx.item % gradientColors.count]
        cell.configure(icon: item.icon, text: item.text, gradientColors: gradient)
        return cell
    }

    
    func collectionView(_ cv: UICollectionView, layout l: UICollectionViewLayout, sizeForItemAt idx: IndexPath) -> CGSize {
        return CGSize(width: 240, height: 132)
    }
}
