//
//  ViewController.swift
//  ScaledSlider
//
//  Created by Zhi Zhou on 2023/3/24.
//

import UIKit

class ViewController: UIViewController {
    
    private let slider = ScaledSlider()
    let dele = Delegate<Void, Void>()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupInterface()
    }

}

extension ViewController {
    
    private func setupInterface() {
        
        slider.tintColor = .purple
        slider.scales = [10, 20, 30, 40, 50, 60]
        slider.minimumValueImage = UIImage(systemName: "textformat.size.smaller")
        slider.maximumValueImage =  UIImage(systemName: "textformat.size.larger")
        slider.startValue = 0
        slider.trackColor = .orange
        
        slider.valueDidChangeHandler.delegate(on: self) { (self, scaleIndex) in
            print(">>>>>>", scaleIndex)
        }
        
        view.addSubview(slider)
        
        slider.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            slider.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            slider.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            slider.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
}




































