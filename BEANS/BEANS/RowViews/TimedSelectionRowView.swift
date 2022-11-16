import SwiftUI

struct TimedSelectionRowView: View {
    @State var progress: Int = 0
    @State var title: String = "Daily habits"
    @State var dayStr: String = "Mon"
    @State var presented: Bool = false
    
    private var dayStrings: [String] = [
        "Mon",
        "Tue",
        "Wed",
        "Thu",
        "Fri",
        "Sat",
        "Sun"
    ]
    
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.gray.opacity(0.25))
                VStack {
                    Text(self.dayStr)
                        .font(.largeTitle)
                        .lineLimit(2)
                        .minimumScaleFactor(0.5)
                        .bold()
                        .multilineTextAlignment(.leading)
                        .foregroundColor(Color.red)
                        .onAppear() {
                            if (presented == false) {
                                self.addNumberWithRollingAnimation()
                                presented = true
                            }
                        }
                    Text("\(self.progress)")
                        .font(.largeTitle)
                        .lineLimit(2)
                        .minimumScaleFactor(0.5)
                        .bold()
                        .multilineTextAlignment(.leading)
                        .foregroundColor(Color.gray)
                }
            }
                .frame(minWidth: 100, maxWidth: 100, minHeight: 100, maxHeight: 100)
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
            progress = 0
            // Decide on the number of animation steps
            let animationDuration = 3000 // milliseconds
            let steps = min(abs(6), 100)
            let stepDuration = (animationDuration / steps)
            
            // add the remainder of our entered num from the steps
            // For each step
            (0..<steps).forEach { step in
                // create the period of time when we want to update the number
                // I chose to run the animation over a second
                let updateTimeInterval = DispatchTimeInterval.milliseconds(step * stepDuration)
                let deadline = DispatchTime.now() + updateTimeInterval
                
                // tell dispatch queue to run task after the deadline
                DispatchQueue.main.asyncAfter(deadline: deadline) {
                    // Add piece of the entire entered number to our total
                    self.progress += Int(6 / steps)
                    if (progress >= 0 && progress <= 6) {
                        self.dayStr = dayStrings[self.progress]
                    }
                }
            }
        }
    }
}

struct TimedSelectionRowView_Previews: PreviewProvider {
    static var previews: some View {
        TimedSelectionRowView()
            .previewLayout(.fixed(width: 400, height: 150))
    }
}
