//
//  HapticFeedback.swift
//  ScaledSlider
//
//  Created by Zhi Zhou on 2023/3/24.
//

import UIKit
import AVFoundation

/// 震动反馈
open class HapticFeedback {
    
    @available(iOS 10.0, *)
    public enum Notification {
        
        private static var generator: UINotificationFeedbackGenerator = {
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            
            return generator
        }()
        
        
        public static func success() {
            occurred(.success)
        }
        
        public static func warning() {
            occurred(.warning)
        }
        
        public static func error() {
            occurred(.error)
        }
        
        private static func occurred(_ notificationType: UINotificationFeedbackGenerator.FeedbackType) {
            generator.notificationOccurred(notificationType)
            generator.prepare()
        }
        
    }
    
    @available(iOS 10.0, *)
    public enum Impact {
        
        private static var generator: UIImpactFeedbackGenerator?
        
        public static func light() {
            impactOccurred(.light)
        }
        
        public static func medium() {
            impactOccurred(.medium)
        }
        
        public static func heavy() {
            impactOccurred(.heavy)
        }
        
        private static func impactOccurred(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
            generator = UIImpactFeedbackGenerator(style: style)
            generator?.prepare()
            generator?.impactOccurred()
        }
        
    }
    
    @available(iOS 10.0, *)
    public enum Selection {
        
        private static var generator: UISelectionFeedbackGenerator = {
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            
            return generator
        }()
        
        public static func selection() {
            generator.selectionChanged()
            generator.prepare()
        }
        
    }
    
    @available(iOS 9.0, *)
    open class func peek() {
        AudioServicesPlaySystemSound(1519)
    }
    
    @available(iOS 9.0, *)
    open class func pop() {
        AudioServicesPlaySystemSound(1520)
    }
    
    @available(iOS 9.0, *)
    open class func error() {
        AudioServicesPlaySystemSound(1521)
    }
    
    open class func vibration() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
}






































