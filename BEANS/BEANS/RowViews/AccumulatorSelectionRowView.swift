import SwiftUI

struct AccumulatorSelectionRowView: View {
    @State var progress: Int = 0
    @State var title: String = "Count infinitely"
    @State var presented: Bool = false
    
    var body: some View {
        HStack {
            Text("\(progress)")
                .font(.largeTitle)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
                .bold()
                .multilineTextAlignment(.leading)
                .foregroundColor(Color.gray)
                .padding(20)
                .frame(minWidth: 100, maxWidth: 100, minHeight: 100, maxHeight: 100)
                .onAppear() {
                    if (presented == false) {
                        self.addNumberWithRollingAnimation()
                        presented = true
                    }
                }
            Text(title)
                .font(.largeTitle)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
                .bold()
                .multilineTextAlignment(.leading)
                .foregroundColor(Color.gray)
                .padding(20)
        }
    }
    
    func addNumberWithRollingAnimation() {
        withAnimation {
            self.progress = 0
            // Decide on the number of animation steps
            let animationDuration = 3000 // milliseconds
            let steps = min(abs(69), 100)
            let stepDuration = (animationDuration / steps)
            
            // add the remainder of our entered num from the steps
            progress += 69 % steps
            // For each step
            (0..<steps).forEach { step in
                // create the period of time when we want to update the number
                // I chose to run the animation over a second
                let updateTimeInterval = DispatchTimeInterval.milliseconds(step * stepDuration)
                let deadline = DispatchTime.now() + updateTimeInterval
                
                // tell dispatch queue to run task after the deadline
                DispatchQueue.main.asyncAfter(deadline: deadline) {
                    // Add piece of the entire entered number to our total
                    self.progress += Int(69 / steps)
                }
            }
        }
    }
}

struct AccumulatorSelectionRowView_Previews: PreviewProvider {
    static var previews: some View {
        AccumulatorSelectionRowView()
            .previewLayout(.fixed(width: 400, height: 150))
    }
}
