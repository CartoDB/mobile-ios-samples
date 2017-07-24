//
//  ProgressLabel.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 26/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

class ProgressLabel : UIView {
    
    var label: UILabel!
    var progressBar: UIView!
    
    var height: CGFloat!
    
    func isVisible() -> Bool {
        return self.alpha == 1
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        backgroundColor = Colors.transparentGray
        
        label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 12)
        label.textAlignment = .center
        addSubview(label)
        
        progressBar = UIView()
        progressBar.backgroundColor = Colors.appleBlue
        addSubview(progressBar)
        
        alpha = 0
    }
    
    override func layoutSubviews() {
        label.frame = bounds
    }

    func update(text: String, progress: CGFloat) {
        label.text = text
        updateProgressBar(progress: progress)
    }
    
    func update(text: String) {
        label.text = text
    }
    
    func complete(message: String) {
        
        if (!isVisible()) {
            show()
        }
        
        label.text = message
        
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(onTimerCompleted), userInfo: nil, repeats: false)
    }
    
    func onTimerCompleted() {
        hide()
    }
    
    func updateProgressBar(progress: CGFloat) {
        
        let width: CGFloat = (frame.width * progress) / 100
        let height: CGFloat = 3
        let y: CGFloat = frame.height - height
        
        progressBar.frame = CGRect(x: 0, y: y, width: width, height: height)
    }

    func hide() {
        if (isVisible()) {
            animateAlpha(alpha: 0)
        }
    }
    
    func show() {
        if (!isVisible()) {
            animateAlpha(alpha: 1)
        }
    }
    
    func animateAlpha(alpha: CGFloat) {
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = alpha
        })
    }
}






