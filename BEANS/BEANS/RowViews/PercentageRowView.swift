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
            .onAppear() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation(Animation.easeInOut(duration: 1.5)) {
                        self.percentage = task.progress / task.goal
                    }
                }
            }
            VStack(alignment: .leading) {
                Text(name)
                    .font(.title)
                    .bold()
                    .scaledToFit()
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxHeight: .infinity)
                    .padding(.bottom, 10)
                    .minimumScaleFactor(0.5)
                    .onAppear() {
                        self.name = task.name!
                    }
                ProgressView(progress: $progress, goal: $goal, gradient: Gradient.init(primaryColor: task.color!) )
                    .onAppear() {
                        self.progress = task.progress
                        self.goal = task.goal
                    }
                    .onChange(of: task.progress, perform: { _ in
                        self.progress = task.progress
                    })
            }
                .padding(10)
        }
    }
}

struct PercentageRowView_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController().container.viewContext
        let task = PercentageTask.init(context: viewContext)
        task.name = "Lorem Ipsum long ass fucking name"
        task.color = "purple"
        task.progress = 33
        task.goal = 100
        
        return PercentageRowView(task: task).environment(\.managedObjectContext, viewContext)
    }
}
