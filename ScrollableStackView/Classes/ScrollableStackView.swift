//
//  ScrollableStackView.swift
//  ScrollableStackView
//
//  Created by Gürhan Yerlikaya on 15/12/2016.
//  Copyright © 2016 GY. All rights reserved.
//

import UIKit

class ScrollableStackView: UIStackView {
    
    fileprivate var didSetupConstraints = false
    fileprivate var scrollView: UIScrollView!
    open var stackView: UIStackView!
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        setupUI()
    }
    
    func setupUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        
        // ScrollView
        scrollView = UIScrollView(frame: self.frame)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(scrollView)
        
        // StackView
        stackView = UIStackView(frame: scrollView.frame)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
        scrollView.addSubview(stackView)
        
        for _ in 1 ..< 11 {
            let random = CGFloat(arc4random_uniform(131) + 30) // between 30-130
            let rectangle = UIView(frame: CGRect(x: 0, y: 0, width: 42, height: 42))
            rectangle.backgroundColor = UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1.0)
            rectangle.heightAnchor.constraint(equalToConstant: random).isActive = true
            stackView.addArrangedSubview(rectangle)
        }
        
        self.setNeedsUpdateConstraints() // Bootstrap auto layout
    }
    
    func addItemToStack() {
        let random = CGFloat(arc4random_uniform(131) + 30) // between 30-130
        let rectangle = UIView(frame: CGRect(x: 0, y: 0, width: 42, height: 42))
        rectangle.backgroundColor = UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1.0)
        rectangle.heightAnchor.constraint(equalToConstant: random).isActive = true
        
        UIView.animate(withDuration: 0.25, animations: {
            self.stackView.addArrangedSubview(rectangle)
        }) { (isDone) in
            if(isDone) {
                self.scrollView.scrollToBottom(true)
            }
        }
    }
    
    func removeItemFromStack() {
        UIView.animate(withDuration: 0.25, animations: {
            if let last = self.stackView.arrangedSubviews.last {
                self.stackView.removeArrangedSubview(last)
            }
        }) { (isDone) in
            if(isDone) {
                self.scrollView.scrollToBottom(true)
            }
        }
    }
    
    // Auto Layout
    override func updateConstraints() {
        super.updateConstraints()
        
        if (!didSetupConstraints) {
            self.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0))
            self.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0))
            
            self.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0))
            self.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0))
            
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[stackView(==scrollView)]", options: .alignAllCenterX, metrics: nil, views: ["stackView": stackView, "scrollView": scrollView]))
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[stackView]|", options: .alignAllCenterX, metrics: nil, views: ["stackView": stackView]))
            
            didSetupConstraints = true
        }
    }
}

// Used to scroll till the end after adding new items to atack view
extension UIScrollView {
    func scrollToBottom(_ animated: Bool) {
        if self.contentSize.height < self.bounds.size.height { return }
        let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height)
        self.setContentOffset(bottomOffset, animated: animated)
    }
}