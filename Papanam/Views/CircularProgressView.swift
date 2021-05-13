//
//  CircularProgressView.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/12/21.
//

import UIKit

class CircularProgressView: UIView {
    // MARK: - Properties
    private var progressLayer: CAShapeLayer!
    private var trackLayer: CAShapeLayer!
    private lazy var pulsatingLayer = circleShapeLayer(pulseCircle:true, strokeColor: .clear, fillColor: .themeDarkRed)
    
    // MARK: - Lifecycle
    override init(frame: CGRect){
        super.init(frame: frame)
        setupCircleLayers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func setupCircleLayers(){
        layer.addSublayer(pulsatingLayer)
        
        trackLayer = circleShapeLayer(strokeColor: .clear, fillColor: .clear)
        layer.addSublayer(trackLayer)
        trackLayer.strokeEnd = 1
        
        progressLayer = circleShapeLayer(strokeColor: .themeRed, fillColor: .clear)
        layer.addSublayer(progressLayer)
        progressLayer.strokeEnd = 1
    }
    
    private func circleShapeLayer(pulseCircle: Bool = false, strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        
        let rad:CGFloat = pulseCircle ? self.frame.width / 2.4 : self.frame.width / 2.5
        
        let center = CGPoint(x: 0, y: 28)
        let circularPath = UIBezierPath(
            arcCenter: center,
            radius: rad,
            startAngle: -(.pi / 2),
            endAngle: 1.5 * .pi,
            clockwise: true
        )
        
        layer.path = circularPath.cgPath
        layer.strokeColor = strokeColor.cgColor
        layer.lineWidth = 12
        layer.fillColor = fillColor.cgColor
        layer.lineCap = .round
        layer.position = self.center
        
        
        return layer
    }
    
    public func animatePulsatingLayer(){
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.25
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.autoreverses = true
        animation.repeatCount = .infinity
        
        pulsatingLayer.add(animation, forKey: "pulsing")
    }
    
    public func setProgressWithAnimation(duration: TimeInterval, value: Float, completion:@escaping(()->())){
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = 1
        animation.toValue = value
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        self.progressLayer.strokeEnd = CGFloat(value)
        self.progressLayer.add(animation, forKey: "animateProgress")
        
        CATransaction.commit()
    }
}
