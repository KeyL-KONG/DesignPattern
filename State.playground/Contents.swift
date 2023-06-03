import UIKit


public class TrafficLight: UIView {
    
    public private(set) var canisterLayers: [CAShapeLayer] = []
    
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    public init(canisterCount: Int = 3, frame: CGRect = CGRect(x: 0, y: 0, width: 160, height: 420)) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 0.86, green: 0.64, blue: 0.25, alpha: 1)
        createCanisterLayers(count: canisterCount)
    }
    
    private func createCanisterLayers(count: Int) {
        let paddingPercentage: CGFloat = 0.2
        let yTotalPadding = paddingPercentage * bounds.height
        let yPadding = yTotalPadding / CGFloat(count + 1)
        
        let canisterHeight = (bounds.height - yTotalPadding) / CGFloat(count)
        let xPadding = (bounds.width - canisterHeight) / 2.0
        var canisterFrame = CGRect(x: xPadding, y: yPadding, width: canisterHeight, height: canisterHeight)
        
        for _ in 0 ..< count {
            let canisterShape = CAShapeLayer()
            canisterShape.path = UIBezierPath(ovalIn: canisterFrame).cgPath
            canisterShape.fillColor = UIColor.black.cgColor
            
            layer.addSublayer(canisterShape)
            canisterLayers.append(canisterShape)
            
            canisterFrame.origin.y += (canisterFrame.height + yPadding)
        }
    }
    
}

let trafficLight = TrafficLight()
