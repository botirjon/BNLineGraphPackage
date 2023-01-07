//
//  File.swift
//  
//
//  Created by Botirjon Nasridinov on 07/01/23.
//

import UIKit

public class BNLineGraphView: UIView {
    
    public var values: [BNLineGraphPoint] = [] {
        didSet {
            self.graph.setValues(values)
        }
    }
    
    private lazy var graph: BNLineGraph = {
        let graph = BNLineGraph()
        return graph
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(graph)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        graph.frame = bounds.insetBy(dx: 10, dy: 10)
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var tintColor: UIColor! {
        set {
            graph.tintColor = newValue
        }
        get {
            graph.tintColor
        }
    }
    
    public func setValues(_ values: [BNLineGraphPoint]) {
        self.values = values
    }
}
