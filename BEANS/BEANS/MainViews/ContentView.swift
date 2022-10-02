import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \AccumulatorTask.lastUpdated, ascending: true)],
        animation: .default)
    private var accumulatorTasks: FetchedResults<AccumulatorTask>

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \PercentageTask.lastUpdated, ascending: true)],
        animation: .default)
    private var percentageTasks: FetchedResults<PercentageTask>
    
    // timed task fetch here
    
    private var animation: Animation { Animation.easeInOut(duration: 1.5) }
    
    @State var showCreationView: Bool = false
    
    var body: some View {
        NavigationView {
            TabView {
                List {
                    ForEach(percentageTasks) { task in
                        NavigationLink {
                            PercentageDetailView(task: task)
                        } label: {
                            PercentageRowView(task: task)
                        }
                    }
                    .onDelete { IndexSet in
                        PersistenceController().deletePercentageTask(
                            offsets: IndexSet,
                            tasks: percentageTasks,
                            viewContext: viewContext)
                    }
                }
                .frame(alignment: .top)
                .tabItem {
                    Image(systemName: "trophy.fill")
                    Text("Goals")
                }
                List {
                    ForEach(accumulatorTasks) { task in
                        NavigationLink {
                            AccumulatorDetailView(task: task)
                        } label: {
                            AccumulatorRowView(task: task)
                        }
                    }
                    .onDelete { IndexSet in
                        PersistenceController().deleteAccumulatorTask(
                            offsets: IndexSet,
                            tasks: accumulatorTasks,
                            viewContext: viewContext)
                    }
                }
                .frame(alignment: .top)
                .tabItem {
                    Image(systemName: "basket.fill")
                    Text("Counts")
                }
            }
                .accentColor(Color.orange)
                .tint(Color.orange)
                .navigationTitle("YOUR BEANS")
                .font(.largeTitle)
                .toolbar {
                    ToolbarItem {
                        Button {
                            showCreationView.toggle()
                        } label: {
                            Image(systemName: "note.text.badge.plus")
                        }
                            .dynamicTypeSize(.xxxLarge)
                            .foregroundColor(Color.orange)
                    }
                }
                .sheet(isPresented: $showCreationView) {
                    CreationView()
                }
        }
            .accentColor(Color.orange               )
            .tint(Color.orange)
            .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
    }
    
}

extension UIApplication {
    func addTapGestureRecognizer() {
        guard let window = (connectedScenes.first as? UIWindowScene)?.windows.first
        else { return }
        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.requiresExclusiveTouchType = false
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        window.addGestureRecognizer(tapGesture)
    }
}

extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false // set to `false` if you don't want to detect tap during other gestures
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}


