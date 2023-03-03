//
//  HomeItemsCollectionView.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 1/16/23.
//

import UIKit
import Combine
import SwiftUI

class HomeItemsCollectionView: UIView {

    private var homeViewModel : HomeViewModel
    private let coreLocation : CoreLocationManager? =
    (UIApplication.shared.delegate as? AppDelegate)?.locationManager
    private var footerView : DealsFooterCollectionReusableView?
    private var subscribers = Set<AnyCancellable>()
    
    private var isInitialDisplay : Bool = true
    private var allLoaded : Bool = false
    private var currentDealsSectionOffset : CGFloat = 0
    private var currentDotIndex : Int = 0 {
        didSet {
            footerView?.currentDotIndex = currentDotIndex
        }
    }
    
    // data
    private var currentState : String?
    private var nearbyParks : [ParkViewModel]? = nil
    private var activities : [ActivityVM]? = nil
  
    // collection view
    private lazy var collectionView : UICollectionView = {
        // collection view
        let collection = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collection.contentInset = UIEdgeInsets.zero
        collection.isPagingEnabled = false
        collection.dataSource = self
        collection.delegate = self
        collection.alwaysBounceHorizontal = false
        collection.bounces = true
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.contentInsetAdjustmentBehavior = .never
        collection.showsVerticalScrollIndicator = false

        // register collection cells
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collection.register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: ItemCollectionViewCell.id)
        collection.register(NearbyForYouCollectionViewCell.self, forCellWithReuseIdentifier: NearbyForYouCollectionViewCell.id)
        collection.register(ShimmerNearbyForYouCollectionViewCell.self, forCellWithReuseIdentifier: ShimmerNearbyForYouCollectionViewCell.id)
        collection.register(ActivityCollectionViewCell.self, forCellWithReuseIdentifier: ActivityCollectionViewCell.id)
        collection.register(ShimmerActivityCollectionViewCell.self, forCellWithReuseIdentifier: ShimmerActivityCollectionViewCell.id)
        collection.register(FeatureCollectionViewCell.self, forCellWithReuseIdentifier: FeatureCollectionViewCell.id)
        collection.register(ShimmerFeatureCollectionViewCell.self, forCellWithReuseIdentifier: ShimmerFeatureCollectionViewCell.id)
        collection.register(CreditFooterCollectionViewCell.self, forCellWithReuseIdentifier: CreditFooterCollectionViewCell.id)
        collection.register(ShimmerCreditFooterCollectionViewCell.self, forCellWithReuseIdentifier: ShimmerCreditFooterCollectionViewCell.id)
        
        // register headers
        collection.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.id)
        collection.register(ShimmerHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ShimmerHeaderCollectionReusableView.id)
        collection.register(DealsFooterCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: DealsFooterCollectionReusableView.id)
       
        collection.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "CollectionReusableView")

        return collection
    }()
    
    
    init(viewModel : HomeViewModel){
        self.homeViewModel = viewModel
        super.init(frame: .zero)
        
        self.setup()
        self.layout()
        self.setupBinding()
        self.initializeHomeRequests()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.addSubview(collectionView)
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    // data binding
    private func setupBinding() {
        if let coreLocation = coreLocation {
            coreLocation
                .$currentState
                .receive(on: RunLoop.main)
                .sink(receiveValue: { [weak self] state in
                    guard
                        let self = self,
                        let state = state,
                        state != self.currentState else { return }
                    DispatchQueue.main.async {
                        self.currentState = state
                        self.homeViewModel.searchNearby(for: state)
                    }
                    
                })
                .store(in: &subscribers)
        }
        
        homeViewModel
            .$initialDisply
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] value in
                guard let self = self else { return  }
                DispatchQueue.main.async {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.isInitialDisplay = false
                        self.collectionView.reloadData()
                       }
                }
                
            })
            .store(in: &subscribers)
        
        homeViewModel
            .$nearbyParks
            .receive(on: RunLoop.main)
            .sink { [weak self] parks in
                guard let self = self else { return}
                DispatchQueue.main.async {
                    self.nearbyParks = parks
                    UIView.performWithoutAnimation {
                        self.collectionView.reloadSections([1])
                    }
                }
            }
            .store(in: &subscribers)
        
        homeViewModel
            .$activities
            .receive(on: RunLoop.main)
            .sink { [weak self] activies in
                guard let self = self else { return}
                DispatchQueue.main.async {
                    self.activities = activies
                    self.collectionView.reloadSections([3])
                }
            }
            .store(in: &subscribers)
    }
}

//MARK: - Collection View Setup
extension HomeItemsCollectionView {
    // create layout
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [unowned self]
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let section : NSCollectionLayoutSection = {
                switch sectionIndex {
                case 0 : return self.empyt()
                case 1 : return self.placesLayoutSection()
                case 2 : return self.dealsLayoutSection()
                case 3 : return self.creditLayoutSection()
                case 4 : return self.activitiesLayoutSection()
                default : return self.activitiesLayoutSection()
                }
            }()
                        
            return section
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.contentInsetsReference = .none
        config.scrollDirection = .vertical
        layout.configuration = config
        return layout
    }
    
    // places layout
    private func placesLayoutSection() -> NSCollectionLayoutSection {
        let subItems = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
        )
        
        subItems.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)
        
        let containerGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.7),
                heightDimension: .fractionalWidth(0.6)
            ),
            subitems: [subItems]
        )
        
        let section = NSCollectionLayoutSection(group: containerGroup)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 0, leading: 10, bottom: 30, trailing: 5)

        setHeader(section)
        
        return section
    }
    
    // seens section
    private func activitiesLayoutSection() -> NSCollectionLayoutSection {
        let subItems1 = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1/2)
            )
        )
        
        let subItems2 = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1/2)
            )
        )
        
        subItems1.contentInsets = .init(top: 0, leading: 3, bottom: 0, trailing: 3)
        
        subItems2.contentInsets = .init(top: 6, leading: 3, bottom: 0, trailing: 3)
        
        let containerGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .absolute(150),
                heightDimension: .absolute(180)
            ),
            subitems: [subItems1 , subItems2]
        )
        
        let section = NSCollectionLayoutSection(group: containerGroup)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 0, leading: 10, bottom: 30, trailing: 5)
        
        setHeader(section)
        
        return section
    }
    // deals layout
    private func dealsLayoutSection() -> NSCollectionLayoutSection {
        let subItems = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
        )
        
        subItems.contentInsets = .init(top: 20, leading: 10, bottom: 0, trailing: 10)
        
        let containerGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(200)
            ),
            subitems: [subItems]
        )
        
        let section = NSCollectionLayoutSection(group: containerGroup)
        section.orthogonalScrollingBehavior = .paging
        
        setFooter(section)
        section.visibleItemsInvalidationHandler = { [weak self] visibleItems, point, environment in
            
            self?.currentDealsSectionOffset = point.x
        }
        
        return section
    }

    // profiles section
    private func profilesLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0/5.0),
            heightDimension: .fractionalWidth(1.0/5.0))
         let item = NSCollectionLayoutItem(layoutSize: itemSize)

         // Define the group of items
         let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(1/5))
         let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

         // Define the section
         let section = NSCollectionLayoutSection(group: group)
         section.interGroupSpacing = 10
         section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 20, trailing: 10)
        
        setHeader(section)
        
         return section
    }
    
    // cerdit section
    private func xxx() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(120))
         let item = NSCollectionLayoutItem(layoutSize: itemSize)

         // Define the group of items
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(120))
         let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

         // Define the section
         let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 35, leading: 0, bottom: 15, trailing: 0)

         return section
    }
    
    // deals layout
    private func creditLayoutSection() -> NSCollectionLayoutSection {
        // 1. item size
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        
        // 2. sub items
        let subItems = NSCollectionLayoutItem(
            layoutSize: itemSize
        )
                
        // 3. group size
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(150)
        )
        // 4. container group
        let containerGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [subItems]
        )
        
        let section = NSCollectionLayoutSection(group: containerGroup)
        section.contentInsets = NSDirectionalEdgeInsets(top: 35, leading: 0, bottom: 30, trailing: 0)

        return section
    }
    
    // profiles section
    private func empyt() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(1), heightDimension: .estimated(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(115))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0)
            return section
    }
    
    // set header
    private func setHeader( _ section : NSCollectionLayoutSection) {
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: getFooterHeaderSize(),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        section.boundarySupplementaryItems.append(header)
        
        
    }
    
    // set footer
    private func setFooter( _ section : NSCollectionLayoutSection) {
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: getFooterHeaderSize(),
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom)
        section.boundarySupplementaryItems.append(footer)
    }
    
    // get footer and header size
    private func getFooterHeaderSize() -> NSCollectionLayoutSize {
        let footerHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(40))
        return footerHeaderSize
    }
}

//MARK: - Functions
extension HomeItemsCollectionView {
    private func initializeHomeRequests()  {
        homeViewModel.createInitialServiceRequest(self.currentState)
    }
}

//MARK: - UICollectionViewDataSource
extension HomeItemsCollectionView : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0 : return 1
        case 1 : return self.isInitialDisplay ? 3 : getRowCounts(self.nearbyParks, maxCount: 5)
        case 2 : return 3
        case 4 : return  self.isInitialDisplay ? 12 : getRowCounts(self.activities, maxCount: 0)
        case 3 : return 1
        default : return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 1 :
            
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShimmerNearbyForYouCollectionViewCell.id, for: indexPath) as? ShimmerNearbyForYouCollectionViewCell, self.isInitialDisplay {
                return cell
            }
            else if let cell : NearbyForYouCollectionViewCell = dequeueCollectinoViewCell(collectionView, indexPath: indexPath, models: self.nearbyParks) {
                return cell
            }
            
        case 2 :
            if let cell : ShimmerFeatureCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: ShimmerFeatureCollectionViewCell.id, for: indexPath) as? ShimmerFeatureCollectionViewCell, self.isInitialDisplay {
                return cell
            }
            else if let cell : FeatureCollectionViewCell = dequeueCollectinoViewCell(collectionView, indexPath: indexPath, models: FEATURE.featuers) {
                return cell
            }
            
        case 3 :
            if let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: ShimmerCreditFooterCollectionViewCell.id, for: indexPath) as? ShimmerCreditFooterCollectionViewCell, self.isInitialDisplay {
                return cell
            }
            else if let cell : CreditFooterCollectionViewCell = dequeueCollectinoViewCell(collectionView, indexPath: indexPath, models: [CREDIT.credit]) {
                return cell
            }
        case 4 :
            if let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: ShimmerActivityCollectionViewCell.id, for: indexPath) as? ShimmerActivityCollectionViewCell, self.isInitialDisplay {
                return cell
            }
            else if let cell : ActivityCollectionViewCell = dequeueCollectinoViewCell(collectionView, indexPath: indexPath, models: self.activities) {
                return cell
            }
            
            
        default : break
        }
        let defaultCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return defaultCell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
            
        // header
        case UICollectionView.elementKindSectionHeader :
            if self.isInitialDisplay {
               if let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ShimmerHeaderCollectionReusableView.id, for: indexPath) as? ShimmerHeaderCollectionReusableView {
                    
                    return header
                }
            } else
            if let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.id, for: indexPath) as? HeaderCollectionReusableView {
                let title : String = {
                    if indexPath.section == 1 {
                        if let state = currentState {
                            return "Nearby in \(state)"
                        }
                        return "Popular places"
                    }
                    if indexPath.section == 4 {
                        return "Activities"
                    }
                    return ""
                }()
                
                header.configure(with: title)
                return header
            }
        // footer
        case UICollectionView.elementKindSectionFooter :
            if let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: DealsFooterCollectionReusableView.id, for: indexPath) as? DealsFooterCollectionReusableView {
                footerView = footer
                if self.isInitialDisplay {
                    footer.layoutSubviews()
                    footer.addShimmerEffect()
                } else {
                    footer.layoutSubviews()
                    footer.removeShimmerEffect()
                }
                return footer
            }
            
        default :
            if let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.id, for: indexPath) as? HeaderCollectionReusableView {
//                header.configure(with: "talala")
                return header
            }
        }
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CollectionReusableView", for: indexPath)
        
        return header
    }
    
    func dequeueCollectinoViewCell<Cell:CellConfigurable>(_ collectinoView : UICollectionView, indexPath : IndexPath, models : [Cell.Model]?) -> Cell? {
        if let cell = collectinoView.dequeueReusableCell(withReuseIdentifier: Cell.identifier, for: indexPath) as? Cell {
            if let models = models{
                let model = models[indexPath.row]
                cell.configureCell(with: model)
            }
            return cell
    }
    return nil
}

    
    func getRowCounts<T>(_ models : [T]?, maxCount : Int) -> Int {
        guard let models = models else { return 0}
        if maxCount == 0 { return models.count}
        return  models.count <= maxCount ? models.count : maxCount
        }
}

//MARK: - UICollectionViewDelegate
extension HomeItemsCollectionView : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 1 :
            if let parks = self.nearbyParks {
                let park = parks[indexPath.row]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "goToDetailResult"), object: self, userInfo: ["park" : park])
            }
        case 4 :
            if let activitis = self.activities {
                let activity = activitis[indexPath.row]
                homeViewModel.searchParks(for: activity)
            }
            
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case 1,4 : return true && !self.isInitialDisplay
        default : return false
        }
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let currentIndex : Int  =  Int(round(currentDealsSectionOffset / UIScreen.screenWidth))
        if currentIndex != self.currentDotIndex {
            self.currentDotIndex = currentIndex
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 75 {
            homeViewModel.updateAppBarVisibility(true)
        } else {
            homeViewModel.updateAppBarVisibility(false)
        }
    }
}
