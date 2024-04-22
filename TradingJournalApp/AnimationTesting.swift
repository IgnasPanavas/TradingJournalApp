import SwiftUI

struct ArrowShape1: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        // Start at the bottom left
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))

        // Draw a line towards the middle where the loop will start
        let midPointX = rect.midX
        let midPointY = rect.midY
        path.addLine(to: CGPoint(x: midPointX, y: midPointY))

        // Create a loop in the middle
        let loopRadius = rect.width * 0.1
        path.addArc(center: CGPoint(x: midPointX, y: midPointY - loopRadius), radius: loopRadius,
                    startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 450), clockwise: false)

        // Continue the line towards the top right
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))

        // Define the arrowhead shape (separate from the main path)
        let arrowHeadSize = rect.width * 0.1
        var arrowHeadPath = Path { subPath in
            subPath.move(to: CGPoint(x: 0, y: 0)) // Start at the tip of the arrowhead
            subPath.addLine(to: CGPoint(x: -arrowHeadSize * 0.5, y: arrowHeadSize))
            subPath.addLine(to: CGPoint(x: arrowHeadSize * 0.5, y: arrowHeadSize))
            subPath.closeSubpath()
        }

        // Apply a transform to position the arrowhead
        let arrowHeadTransform = CGAffineTransform(translationX: rect.maxX, y: rect.minY + arrowHeadSize)
        arrowHeadPath = arrowHeadPath.applying(arrowHeadTransform)

        // Add the transformed arrowhead path to the main path
        path.addPath(arrowHeadPath)

        return path
    }
}
struct ArrowShape2: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.minX, y: rect.midY))

        // Shaft
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY - rect.height * 0.2))

        // Arrowhead
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.1, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))

        return path
    }
}

struct AnimatedArrow: View {
    @State private var trimValue: CGFloat = 0.0
    let strokeStyle = StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round)
    @State private var trimStart: CGFloat = 0.0
    var body: some View {
        ArrowShape1()
            .trim(from: 0, to: trimValue)
            .stroke(Color.blue, style: strokeStyle)
            .frame(width: 200, height: 200)
            .onAppear {
                withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: false)) {
                    trimValue = 1.0
                }
            }
    }
}

struct AnimatedArrow_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedArrow()
    }
}
