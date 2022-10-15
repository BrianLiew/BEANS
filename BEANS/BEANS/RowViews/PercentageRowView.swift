import SwiftUI

struct PercentageRowView: View {
    @Environment(\.managedObjectContext) private var viewContext

    var task: FetchedResults<PercentageTask>.Element
    
    @State var percentage: Double = 0
    @State var name: String = "Untitled"
    @State var progress: Double = 0
    @State var goal: Double = 0
    
    var body: some View {
        HStack {
            RingView(
                progress: $percentage,
                font: .headline,
                gradient: Gradient.init(primaryColor: task.color!),
                line_width: 15,
                size: CGSize(width: 80, height: 80)
            )
                .frame(minWidth: 100, maxWidth: 100, minHeight: 100, maxHeight: 100)
                .onAppear() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation(Animation.easeInOut(duration: 1.5)) {
                            self.percentage = task.progress / task.goal
                        }
                    }
                }
            VStack(alignment: .leading) {
                Text(name)
                    .font(.largeTitle)
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
                    .padding(.bottom, 10)
                    .onAppear() {
                        self.name = task.name!
                    }
                ProgressView(progress: $progress, goal: $goal, gradient: Gradient.init(primaryColor: task.color!) )
                    .font(.title)
                    .onAppear() {
                        self.progress = task.progress
                        self.goal = task.goal
                    }
                    .onChange(of: task.progress, perform: { _ in
                        self.progress = task.progress
                    })
            }
                .bold()
                .multilineTextAlignment(.leading)
                .foregroundColor(Utilities.getColorFromString(string: task.color!))
                .padding(20)
        }
    }
}

struct PercentageRowView_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController().container.viewContext
        let task = PercentageTask.init(context: viewContext)
        task.name = "Lorem Ipsum"
        task.color = "purple"
        task.progress = 33.5
        task.goal = 100
        
        return PercentageRowView(task: task).environment(\.managedObjectContext, viewContext)
            .previewLayout(.fixed(width: 1000, height: 300))
    }
}
