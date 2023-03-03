//
//  ContainerViewController.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 2/28/23.
//

import UIKit

class ContainerViewController: UIViewController {
    weak var coordinator : MainCoordinator?
    private let sideBarWidth = UIScreen.screenWidth * 0.7
    
    private var showSideBar : Bool = false {
        didSet {
            handleTabBar()
        }
    }
    
    private let sideBar : SideBarView = {
        let view = SideBarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let tabBarViewControllerView : UIViewController = {
        let controller = TabBarViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        return controller
    }()
    
    private let darkLayer : UIView = {
        let layer = UIView()
        layer.backgroundColor = .black
        layer.layer.opacity = 0
        layer.translatesAutoresizingMaskIntoConstraints = false
        
        return layer
    }()
    
    private var xOffsetConstraint : NSLayoutConstraint = NSLayoutConstraint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        coordinator?.setNavBarHidden(true,controller: self)
    }
}

extension ContainerViewController {
    private func setup() {
        
        sideBar.delegate = self
        
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(tabBarViewControllerView.view)
        self.view.addSubview(darkLayer)
        self.view.addSubview(sideBar)
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        let pan:UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(_:)))
        self.darkLayer.addGestureRecognizer(tap)
        self.darkLayer.addGestureRecognizer(pan)
        
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(toggleTabBar(_:)),
                         name: NSNotification.Name ("SideBar"),object: nil)
        
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(setBackground(_:)),
                         name: NSNotification.Name ("HideTabBar"),object: nil)
    }
    
    private func layout() {
        let safeArea = self.view.safeAreaLayoutGuide
        guard let tabView = tabBarViewControllerView.view else { return }
        xOffsetConstraint = tabView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        NSLayoutConstraint.activate([
            tabView.topAnchor.constraint(equalTo: self.view.topAnchor),
            xOffsetConstraint,
            tabView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tabView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            
            darkLayer.topAnchor.constraint(equalTo: self.view.topAnchor),
            darkLayer.leadingAnchor.constraint(equalTo: tabView.leadingAnchor),
            darkLayer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            darkLayer.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            
            sideBar.topAnchor.constraint(equalTo: self.view.topAnchor),
            sideBar.trailingAnchor.constraint(equalTo: tabView.leadingAnchor),
            sideBar.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            sideBar.widthAnchor.constraint(equalToConstant: sideBarWidth),
            
        ])
    }
    
    private func handleTabBar() {
        if showSideBar {
            xOffsetConstraint.constant +=  sideBarWidth
            UIView.animate(withDuration: 0.2) {
                self.darkLayer.layer.opacity = 0.5
                self.view.layoutIfNeeded()
            }
            return
        }
        xOffsetConstraint.constant = 0
        UIView.animate(withDuration: 0.2) {
            self.darkLayer.layer.opacity = 0
            self.view.layoutIfNeeded()
        }
        
    }
    
    @objc private func toggleTabBar(_ notification: Notification) {
        self.showSideBar.toggle()
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.showSideBar = false
    }
    
    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        self.showSideBar = false
    }
    
    @objc func setBackground(_ notification: Notification) {
        if let hide = notification.userInfo?["hide"] as? Bool {
            self.view.backgroundColor = hide ? .black : .systemBackground
        }
    }
}

//MARK: - SideBarDelegate
extension ContainerViewController : SideBarDelegate {
    func shareMyApp() {
        coordinator?.shareMyApp()
    }
    
    func goToMyList() {
        coordinator?.goToMyList()
    }
    
    func sendEmail() {
        coordinator?.sendEmail()
    }
    
    
}

//MARK: - UIGestureRecognizerDelegate
extension ContainerViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return coordinator?.hasElments() ?? false
    }

    // This is necessary because without it, subviews of your top controller can
    // cancel out your gesture recognizer on the edge.
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
