import SwiftUI

struct AccumulatorRowView: View {
    @Environment(\.managedObjectContext) private var viewContext

    var task: FetchedResults<AccumulatorTask>.Element
    
    @State var name: String = "Untitled"
    @State var progress: Double = 0
    
    var body: some View {
        HStack {
            Text("\(Utilities.formatNumber(value: self.progress))")
                .font(.largeTitle)
                .bold()
                .padding(5)
                .scaledToFit()
                .minimumScaleFactor(0.5)
                .fixedSize(horizontal: false, vertical: true)
                .dynamicTypeSize(.xxxLarge)
                .frame(minWidth: 100, maxWidth: 150, minHeight: 100, maxHeight: 100)
                .foregroundColor(Utilities.getColorFromString(string: task.color!))
                .onAppear() {
                    self.progress = task.progress
                    // self.addNumberWithRollingAnimation()
                }
                .onChange(of: task.progress, perform: { _ in
                    self.progress = task.progress
                })
            Text(name)
                .font(.title)
                .bold()
                .padding(20)
                .multilineTextAlignment(.leading)
                .foregroundColor(Utilities.getColorFromString(string: task.color!))
                .onAppear() {
                    self.name = task.name!
                }
        }
    }
    
    func addNumberWithRollingAnimation() {
        withAnimation {
            // Decide on the number of animation steps
            let animationDuration: Double = 3000 // milliseconds
            let steps: Double = min(abs(self.progress), 100)
            let stepDuration = (animationDuration / steps)
            
            // add the remainder of our entered num from the steps
            self.progress += self.progress.truncatingRemainder(dividingBy: self.progress)
            // For each step
            (0..<Int(steps)).forEach { step in
                // create the period of time when we want to update the number
                // I chose to run the animation over a second
                let updateTimeInterval = DispatchTimeInterval.milliseconds(Int(Double(step) * stepDuration))
                let deadline = DispatchTime.now() + updateTimeInterval
                
                // tell dispatch queue to run task after the deadline
                DispatchQueue.main.asyncAfter(deadline: deadline) {
                    // Add piece of the entire entered number to our total
                    self.progress += Double(Int(69 / steps))
                }
            }
        }
    }
}

struct AccumulatorRowView_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController().container.viewContext
        let task = AccumulatorTask.init(context: viewContext)
        task.name = "Lorem Ipsum"
        task.color = "purple"
        task.progress = 33
        
        return AccumulatorRowView(task: task).environment(\.managedObjectContext, viewContext)
            .previewLayout(.fixed(width: 400, height: 150))
    }
}
