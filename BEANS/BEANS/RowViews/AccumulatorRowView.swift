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
                .padding(20)
                .scaledToFit()
                .minimumScaleFactor(0.5)
                .fixedSize(horizontal: false, vertical: true)
                .dynamicTypeSize(.xxxLarge)
                .frame(minWidth: 100, maxWidth: 100, minHeight: 100, maxHeight: 100)
                .foregroundColor(Utilities.getColorFromString(string: task.color!))
                .onAppear() {
                    self.progress = task.progress
                }
                .onChange(of: task.progress, perform: { _ in
                    self.progress = task.progress
                })
            Text(name)
                .font(.title)
                .bold()
                .multilineTextAlignment(.leading)
                .foregroundColor(Utilities.getColorFromString(string: task.color!))
                .onAppear() {
                    self.name = task.name!
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
    }
}
