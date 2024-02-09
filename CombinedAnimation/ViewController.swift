//
//  ViewController.swift
//  CombinedAnimation
//
//  Created by Ian Baikuchukov on 9/2/24.
//

import UIKit

final class ViewController: UIViewController {
    
    private let SIDE_MARGIN: CGFloat = 16
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var rectangleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .systemBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var slider: UISlider = {
        let view = UISlider()
        view.minimumValue = 0.0
        view.maximumValue = 1.0
        view.isContinuous = true
        
        view.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        view.addTarget(self, action: #selector(sliderWasReleased), for: [.touchUpInside, .touchUpOutside])
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.addSubview(containerView)
        containerView.addSubview(rectangleView)
        containerView.addSubview(slider)
        
        containerView.layoutMargins = UIEdgeInsets(top: 0, left: SIDE_MARGIN, bottom: 0, right: SIDE_MARGIN)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            rectangleView.topAnchor.constraint(equalTo: containerView.layoutMarginsGuide.topAnchor, constant: 50),
            rectangleView.leadingAnchor.constraint(equalTo: containerView.layoutMarginsGuide.leadingAnchor),
            rectangleView.widthAnchor.constraint(equalToConstant: 100),
            rectangleView.heightAnchor.constraint(equalToConstant: 100),
            
            slider.topAnchor.constraint(equalTo: rectangleView.bottomAnchor, constant: 40),
            slider.leadingAnchor.constraint(equalTo: containerView.layoutMarginsGuide.leadingAnchor),
            slider.trailingAnchor.constraint(equalTo: containerView.layoutMarginsGuide.trailingAnchor)
        ])
    }
    
    @objc
    private func sliderValueChanged(_ sender: UISlider) {
        // scale view
        let currentTransform = CGFloat(sender.value * sender.maximumValue)
        let rotation = CGAffineTransform(rotationAngle: currentTransform * .pi / 2)
        
        let transform = rotation.scaledBy(x: currentTransform * 0.5 + 1.0, y: currentTransform * 0.5 + 1.0)
        rectangleView.transform = transform
        
        // move view
        let minX = SIDE_MARGIN + rectangleView.frame.width / 2
        let maxX = containerView.frame.width - SIDE_MARGIN - rectangleView.frame.width / 2
                
        rectangleView.center.x = minX + (maxX - minX) * CGFloat(slider.value)
    }
    
    @objc 
    private func sliderWasReleased() {
        UIView.animate(withDuration: 1.0) { [weak self] in
            guard let self else { return }
            
            self.slider.setValue(1.0, animated: true)
            self.sliderValueChanged(self.slider)
        }
    }
    
}
