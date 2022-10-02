import Foundation
import SwiftUI

// MARK: - SHAPES

struct RingBackground: Shape {
    var stroke_width: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.addArc(
            center: CGPoint(
                x: rect.size.width / 2,
                y: rect.size.width / 2),
            radius: rect.size.width / 2,
            startAngle: .degrees(0),
            endAngle: .degrees(360),
            clockwise: false
        )
        
        return path
            .strokedPath(.init(
                lineWidth: stroke_width
            ))
    }
}

struct RingProgress : Shape {
    var stroke_width: CGFloat
    var percentage: Double
    var animatableData: Double {
        get { return percentage }
        set { percentage = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        if (percentage >= 0) {
            path.addArc(
                center: CGPoint(
                    x: rect.size.width / 2,
                    y: rect.size.width / 2
                ),
                radius: rect.size.width / 2,
                startAngle: .degrees(0),
                endAngle: .degrees(percentage * 360),
                clockwise: false
            )
        }
        else {
            path.addArc(
                center: CGPoint(
                    x: rect.size.width / 2,
                    y: rect.size.width / 2
                ),
                radius: rect.size.width / 2,
                startAngle: .degrees(0),
                endAngle: .degrees(percentage * 360),
                clockwise: true
            )
        }


        return path
            .strokedPath(.init(
                lineWidth: stroke_width,
                lineCap: .round,
                lineJoin: .round
            ))
    }

}

struct RingTip: Shape {
    var stroke_width: CGFloat
    var percentage: Double
    
    var animatableData: Double {
        get { return percentage }
        set { percentage = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let angle = CGFloat((percentage * 360) * .pi / 180)
        let radius = rect.width / 2
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let x = center.x + radius * cos(angle) - (stroke_width / 2)
        let y = center.y + radius * sin(angle) - (stroke_width / 2)
        
        path.addEllipse(
            in: CGRect(
                x: x,
                y: y,
                width: stroke_width,
                height: stroke_width
            )
        )
        
        return path
    }
}

struct CustomRectangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.addRoundedRect(
            in: CGRect(
                x: 0,
                y: 0,
                width: rect.width,
                height: rect.height
            ),
            cornerSize: CGSize(width: 10, height: 10)
        )
        
        return path
    }
}
