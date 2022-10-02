import SwiftUI

struct RingView: View {
    @Binding var progress: Double

    @State var percentage: Double = 0

    var animation: Animation { Animation.easeInOut(duration: 1.5) }
    var font: Font
    var gradient: Gradient
    var line_width: CGFloat
    var size: CGSize
    
    var body: some View {
        ZStack {
            RingBackground(
                stroke_width: self.line_width
            )
                .fill(.gray)
                .rotationEffect(.degrees(-90))
            RingProgress(
                stroke_width: self.line_width,
                percentage: self.percentage
            )
                .fill(
                    AngularGradient(
                        gradient: self.gradient,
                        center: .center,
                        startAngle: .degrees(0),
                        endAngle: .degrees(self.percentage * 360)
                    )
                )
                .rotationEffect(.degrees(-90))
            RingTip(
                stroke_width: self.line_width,
                percentage: self.percentage
            )
                .fill(self.gradient.stops[1].color)
                .rotationEffect(.degrees(-90))
                .shadow(radius: 10)
            Text("\(Utilities.formatNumber(value: self.percentage * 100))%")
                .font(self.font)
                .bold()
                .foregroundColor(self.gradient.stops[1].color)
                .scaledToFit()
                .fixedSize(horizontal: false, vertical: true)
                .minimumScaleFactor(0.1)
        }
        .frame(width: size.width, height: size.width, alignment: .center)
        .padding(20)
        .onAppear() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation(self.animation) {
                    self.percentage = progress

                }
            }
        }
        .onChange(of: progress, perform: { _ in
            DispatchQueue.main.async {
                withAnimation(self.animation) {
                    self.percentage = progress
                }
            }
        })
    }
    
}

struct RingView_Previews: PreviewProvider {
    static var previews: some View {
        
        return RingView(
            progress: .constant(0.000000005),
            font: .headline,
            gradient: Gradient(colors: [.blue, .indigo]),
            line_width: 20,
            size: CGSize(width: 100, height: 100)
        )
    }
}
