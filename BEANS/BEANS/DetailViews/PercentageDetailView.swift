import SwiftUI

struct PercentageDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var task: FetchedResults<PercentageTask>.Element
    
    var animation: Animation { Animation.easeInOut(duration: 1.5) }

    @State private var name: String = "Untitled"
    @State private var increment: String = "1"

    @State private var percentage: Double = 0
    @State private var progress: Double = 0
    @State private var goal: Double = 0
    
    private enum Field {
        case name, increment
    }
    
    @FocusState private var focusedField: Field?
    
    var body: some View {
        ScrollView {
            VStack {
                Group {
                    ZStack {
                        Rectangle()
                            .fill(Gradient(primaryColor: task.color!))
                        TextField("\(task.name!)", text: $name)
                            .font(.largeTitle)
                            .bold()
                            .focused($focusedField, equals: .name)
                            .scaledToFit()
                            .minimumScaleFactor(0.5)
                            .fixedSize(horizontal: false, vertical: true)
                            .foregroundColor(Color.white.opacity(0.5))
                            .multilineTextAlignment(.center)
                            .padding(20)
                            .onSubmit {
                                task.name = name
                                PersistenceController( ).save(viewContext: viewContext)
                            }
                            .onChange(of: name, perform: { _ in
                                task.name = name
                                PersistenceController().save(viewContext: self.viewContext)
                            })
                    }
                        .frame(minHeight: 50, maxHeight: 100)
                }
                Group {
                    RingView(
                        progress: $percentage,
                        font: .system(size: 48),
                        gradient: Gradient.init(primaryColor: task.color!),
                        line_width: 30,
                        size: CGSize(width: 200, height: 200)
                    )
                        .padding(.top, 50)
                        .onAppear() {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                withAnimation(self.animation) {
                                    self.percentage = task.progress / task.goal
                                }
                            }
                        }
                    ProgressView(progress: $progress, goal: $goal, gradient: Gradient.init(primaryColor: task.color!) )
                        .padding(.bottom, 100)
                        .onAppear() {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    self.progress = task.progress
                                    self.goal = task.goal
                            }
                        }
                        .onChange(of: task.progress, perform: { _ in
                            DispatchQueue.main.async {
                                withAnimation(self.animation) {
                                    self.progress = task.progress
                                }
                            }
                        })
                }
                HStack(alignment: .center) {
                    Button {
                        task.increment = Double(increment)!
                        task.progress -= task.increment
                        task.lastUpdated = Date.now
                        percentage = task.progress / task.goal
                        progress = task.progress
                        PersistenceController().save(viewContext: viewContext)
                    } label: {
                        Label("Subtract", systemImage: "minus")
                            .labelStyle(.iconOnly)
                            .bold()
                    }
                        .dynamicTypeSize(.xxxLarge)
                    // potential failsure if task.increment
                    TextField("\(Utilities.formatNumber(value: task.increment))", text: $increment)
                        .font(.title)
                        .foregroundColor(.orange)
                        .bold()
                        .multilineTextAlignment(.center)
                        .background(Color.gray.opacity(0.25))
                        .focused($focusedField, equals: .increment)
                        .cornerRadius(10)
                        .keyboardType(.decimalPad)
                        .onSubmit {
                            task.increment = Double(increment)!
                            PersistenceController().save(viewContext: viewContext)
                        }
                        .padding(.horizontal, 20)
                    Button {
                        task.increment = Double(increment)!
                        task.progress += task.increment
                        task.lastUpdated = Date.now
                        percentage = task.progress / task.goal
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
                    .padding(.bottom, 50)
                Spacer()
            }
                .onAppear() {
                    self.name = task.name!
                    self.increment = String(task.increment)
                    self.goal = task.goal
                }
            Spacer()
            Text("Started \(Utilities.timeFormatter(time: task.birth!))")
                .font(.headline)
                .foregroundColor(.gray)
                .padding(20)
        }
    }
    
}

struct PercentageDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController().container.viewContext
        let task = PercentageTask.init(context: viewContext)
        task.name = "Lorem Ipsum"
        task.birth = Date.now
        task.progress = 33.5
        task.goal = 100
        
        return PercentageDetailView(task: task).environment(\.managedObjectContext, viewContext)
    }
}
