//
//  File.swift
//  
//
//  Created by Botirjon Nasridinov on 07/01/23.
//

import UIKit

public struct BNLineGraphVariable {
    public var label: String = ""
    public var value: Float
    
    public init(label: String = "", value: Float) {
        self.label = label
        self.value = value
    }
}

public struct BNLineGraphPoint {
    public var dependentVariable: BNLineGraphVariable
    public var independentVariable: BNLineGraphVariable
    
    public init(dependentVariable: BNLineGraphVariable, independentVariable: BNLineGraphVariable) {
        self.dependentVariable = dependentVariable
        self.independentVariable = independentVariable
    }
}
