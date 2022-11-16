import SwiftUI

struct AccumulatorDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var task: FetchedResults<AccumulatorTask>.Element
    
    var animation: Animation { Animation.easeInOut(duration: 1.5) }

    @State private var name: String = "Untitled"
    @State private var increment: String = "1"

    @State private var progress: Double = 0
    
    private enum Field {
        case name, increment
    }
    @FocusState private var focusedField: Field?
    
    var body: some View {
        VStack {
            Group {
                ZStack {
                    Rectangle()
                        .fill(Gradient.init(primaryColor: task.color!))
                    TextField("\(task.name!)", text: $name)
                        .font(.largeTitle)
                        .bold()
                        .scaledToFit()
                        .minimumScaleFactor(0.5)
                        .focused($focusedField, equals: .name)
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundColor(Color.white.opacity(0.5))
                        .multilineTextAlignment(.center)
                        .padding(20)
                        .onSubmit {
                            task.name = name
                            PersistenceController().save(viewContext: viewContext)
                        }
                        .onChange(of: name, perform: { _ in
                            task.name = name
                            PersistenceController().save(viewContext: self.viewContext)
                        })
                }
                    .frame(minHeight: 50, maxHeight: 100)
            }
            Text("\(Utilities.formatNumber(value: self.progress))")
                .font(.system(size: 96))
                .bold()
                .dynamicTypeSize(.xxxLarge)
                .scaledToFit()
                .minimumScaleFactor(0.25)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 20)
                .padding(.vertical, 50)
                .foregroundColor(Utilities.getColorFromString(string: task.color!))
            HStack(alignment: .center) {
                Button {
                    task.increment = Double(increment)!
                    task.progress -= task.increment
                    task.lastUpdated = Date.now
                    progress = task.progress
                    PersistenceController().save(viewContext: viewContext)
                } label: {
                    Label("Subtract", systemImage: "minus")
                        .labelStyle(.iconOnly)
                        .bold()
                }
                    .dynamicTypeSize(.xxxLarge)
                TextField("\(task.increment)", text: $increment)
                    .font(.title)
                    .bold()
                    .foregroundColor(.orange)
                    .multilineTextAlignment(.center)
                    .background(Color.gray.opacity(0.25))
                    .cornerRadius(10)
                    .focused($focusedField, equals: .increment)
                    .keyboardType(.decimalPad)
                    .onSubmit {
                        task.increment = Double(increment)!
                        PersistenceController().save(viewContext: viewContext)
                    }
                    .padding(20)
                Button {
                    task.increment = Double(increment)!
                    task.progress += task.increment
                    task.lastUpdated = Date.now
                    progress = task.progress
                    PersistenceController().save(viewContext: viewContext)
                } label: {
                    Label("Add", systemImage: "plus")
                        .labelStyle(.iconOnly)
                        .bold()
                }
                    .dynamicTypeSize(.xxxLarge)
            }
            .padding(.horizontal, 50)
            Spacer()
            Text("Started \(Utilities.timeFormatter(time: task.birth!))")
                .font(.headline)
                .foregroundColor(.gray)
                .padding(20)
        }
            .onAppear() {
                self.name = task.name!
                self.progress = task.progress
                self.increment = String(task.increment)
            }
    }
    
}

struct AccumulatorDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController().container.viewContext
        let task = AccumulatorTask.init(context: viewContext)
        task.name = "Lorem Ipsum"
        task.birth = Date.now
        task.progress = 33
        task.color = "blue"
        
        return AccumulatorDetailView(task: task).environment(\.managedObjectContext, viewContext)
    }
}
