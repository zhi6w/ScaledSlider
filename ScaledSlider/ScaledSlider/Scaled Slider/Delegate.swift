//
//  Delegate.swift
//  ScaledSlider
//
//  Created by Zhi Zhou on 2023/3/24.
//

import UIKit

open class Delegate<Input, Output> {

    private var callback: ((Input) -> Output?)?
    
    open var isDelegateSet: Bool {
        return callback != nil
    }
    
    
    public init() {}
    
    open func delegate<T: AnyObject>(on target: T, callback: ((T, Input) -> Output)?) {
        
        self.callback = {
            [weak target] (input) in
            
            guard let target = target else { return nil }
            
            return callback?(target, input)
        }
    }
    
    open func callAsFunction(_ input: Input) -> Output? {
        return callback?(input)
    }
    
}

extension Delegate {
    
    public func removeDelegate() {
        self.callback = nil
    }
    
}

extension Delegate where Input == Void {
    
    public func delegate<T: AnyObject>(on target: T, callback: ((T) -> Output)?) {
        
        self.callback = {
            [weak target] (_) in
            
            guard let target = target else { return nil }
            
            return callback?(target)
        }
    }
    
    public func callAsFunction() -> Output? {
        return callback?(())
    }
    
}




































