//
//  SeenFeedCollectionViewController.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 1/1/23.
//

import UIKit
import AVFoundation

//MARK: - FeedCollectionViewController view activity and properties
class SeenFeedCollectionViewController: UIViewController {
    private weak var currentCell : SeenFeedCollectionViewCell?
    private weak var previousCell : SeenFeedCollectionViewCell?
    private var isInitialDisplay : Bool = true
    private var items : [SeenViewModel] = []
    
    // collection view
    private lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        // collection view
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.contentInset = UIEdgeInsets.zero
        collection.isPagingEnabled = true
        collection.dataSource = self
        collection.delegate = self
        collection.prefetchDataSource = self
        collection.isPagingEnabled = true
        collection.alwaysBounceHorizontal = false
        collection.bounces = false
        collection.register(SeenFeedCollectionViewCell.self, forCellWithReuseIdentifier: SeenFeedCollectionViewCell.id)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.contentInsetAdjustmentBehavior = .never
        return collection
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPosts()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    
    private func setup(){
        self.view.backgroundColor = .white
        view.addSubview(collectionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        let safeArea = view.safeAreaLayoutGuide
        // set constraints
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
}

//MARK: - FeedCollectionViewController methods
extension SeenFeedCollectionViewController {
    
    func getPosts(section : Int = 0) {
        SeenFeedViewModel().getPostsData { [weak self] models, error in
            guard let models = models, error == nil else {
                return
            }
            DispatchQueue.main.async {
                self?.items = models
                self?.collectionView.reloadData()
            }
        }
    }
    
    func check() {
        checkPreload()
        checkVisibility()
    }
    
    
    func checkPreload() {
        guard let lastRow = collectionView.indexPathsForVisibleItems.last?.row else {return}
        let urls = items.compactMap { $0.reactionVideoURL }
            .suffix(from: min(lastRow + 1, items.count))
            .prefix(2)
//        VideoPreloadManager.shared.set(waiting: Array(urls))
    }
    
    // check the visibility of the cell
    func checkVisibility(){
        let visibleCells = collectionView.visibleCells.compactMap { $0 as? SeenFeedCollectionViewCell }
        guard visibleCells.count > 0 else {
            return
            
        }
        let visibleFrame =   CGRect(x: 0, y: collectionView.contentOffset.y, width: collectionView.bounds.width, height: collectionView.bounds.height)
        
        let visibleCell = visibleCells
            .filter { visibleFrame.intersection($0.frame).height >= $0.frame.height / 2}
            .first
        
        currentCell = visibleCell
//        previousCell?.pause()
//        currentCell?.play()
    }
    
}

//MARK: - UICollectionViewDataSource
extension SeenFeedCollectionViewController : UICollectionViewDataSource {
    // number of sections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // number of items in sections
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    // cell for item at index
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let model = items[indexPath.row]

        guard let cell : SeenFeedCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: SeenFeedCollectionViewCell.id, for: indexPath) as? SeenFeedCollectionViewCell else {
            return UICollectionViewCell()
        }
//        cell.set(url: model.reactionVideoURL)
//        cell.setPlaceHolder(data: model.placeHolder)
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension SeenFeedCollectionViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? SeenFeedCollectionViewCell {
            currentCell = cell
            if isInitialDisplay {
                isInitialDisplay.toggle()
//                cell.play()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // Pause the video if the cell is ended displaying
        if let cell = cell as? SeenFeedCollectionViewCell {
            previousCell = cell
//            cell.pause()
            check()
        }
    }
}

//MARK: - UICollectionViewDataSourcePrefetching
extension SeenFeedCollectionViewController : UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
    }
}
