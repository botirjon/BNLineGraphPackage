//
//  BNLineGraph.swift
//  SQB-BUSINESS
//
//  Created by Botirjon Nasridinov on 07/01/23.
//

import UIKit

public struct BNLineGraphVariable {
    var label: String = ""
    var value: Float
}

public struct BNLineGraphPoint {
    var dependentVariable: BNLineGraphVariable
    var independentVariable: BNLineGraphVariable
}
   
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

public class BNLineGraph: UIView {
    
    private var values: [BNLineGraphPoint] = [] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public override var backgroundColor: UIColor? {
        set {
            super.backgroundColor = .clear
        }
        get {
            super.backgroundColor
        }
    }
    
    public var lineWidth: CGFloat = 2 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func initView() {
        isOpaque = false
        backgroundColor = .clear
    }
    
    
    
    public func setValues(_ values: [BNLineGraphPoint]) {
        self.values = values.sorted(by: {
            $0.independentVariable.value < $1.independentVariable.value
        })
    }
    
    private func points(for rect: CGRect) -> [CGPoint] {
        
        let maxX = values.max { $0.independentVariable.value < $1.independentVariable.value
        }?.independentVariable.value
        
        let minX = values.min { $0.independentVariable.value < $1.independentVariable.value
        }?.independentVariable.value
        
        let maxY = values.max { $0.dependentVariable.value < $1.dependentVariable.value
        }?.dependentVariable.value
        
        guard let minX = minX, let maxX = maxX, let maxY = maxY else { return [] }
        
        return values.map { point in
            var y = CGFloat(point.dependentVariable.value/maxY)*rect.maxY
            y = y*cos(.pi)+rect.maxY
            let x = CGFloat((point.independentVariable.value-minX)/(maxX-minX))*rect.maxX
            return .init(x: x, y: y)
        }
    }
    
    
    
    public override func draw(_ rect: CGRect) {
        
        guard !values.isEmpty else { return }
        
        // 1. Calculate the graph points
        let points = self.points(for: rect)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        // 3. Draw graph points
//        let line = self.drawGraphPoints(points)
        tintColor.setFill()
        tintColor.setStroke()
        let graphPath = UIBezierPath()
        graphPath.lineWidth = lineWidth
        graphPath.lineJoinStyle = .round
        
        points.enumerated().forEach { (index, point) in
            if index == 0 {
                graphPath.move(to: point)
            } else {
                graphPath.addLine(to: point)
            }
        }
        
        graphPath.stroke()
        
        
        // Add clipping path
        guard let clippingPath = graphPath.copy() as? UIBezierPath else { return }
        
        clippingPath.addLine(to: .init(x: points[points.count-1].x, y: rect.maxY))
        clippingPath.addLine(to: .init(x: points[0].x, y: rect.maxY))
        clippingPath.close()
        clippingPath.addClip()
        
        let graphStartPoint = CGPoint(x: points[0].x, y: 0)
        let graphEndPoint = CGPoint(x: points[0].x, y: rect.maxY)
        
        let colors = [tintColor.withAlphaComponent(0.2).cgColor, tintColor.withAlphaComponent(0).cgColor]
        
        // 3
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        // 4
        let colorLocations: [CGFloat] = [0.0, 1.0]
        
        // 5
        guard let gradient = CGGradient(
            colorsSpace: colorSpace,
            colors: colors as CFArray,
            locations: colorLocations
        ) else {
            return
        }
        
        context.drawLinearGradient(
            gradient,
            start: graphStartPoint,
            end: graphEndPoint,
            options: [])
        
        
        // Draw the circles on top of the graph stroke
//        points.forEach {
//            let point: CGPoint = .init(
//                x: $0.x-Constants.circleDiameter/2,
//                y: $0.y-Constants.circleDiameter/2)
//
//            let circle = UIBezierPath(
//                ovalIn: CGRect(
//                    origin: point,
//                    size: CGSize(
//                        width: Constants.circleDiameter,
//                        height: Constants.circleDiameter)
//                )
//            )
//            circle.fill()
//        }
    }
}
