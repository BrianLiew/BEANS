import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \AccumulatorTask.lastUpdated, ascending: false)],
        animation: .default)
    private var accumulatorTasks: FetchedResults<AccumulatorTask>

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \PercentageTask.lastUpdated, ascending: false)],
        animation: .default)
    private var percentageTasks: FetchedResults<PercentageTask>
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \TimedTask.lastUpdated, ascending: false)], animation: .default)
    private var timedTasks: FetchedResults<TimedTask>
    
    private var animation: Animation { Animation.easeInOut(duration: 1.5) }
    
    @State private var showCreationSelectorView: Bool = false
    
    init() {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().tintColor = .clear
        UINavigationBar.appearance().backgroundColor = .clear
    }
        
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
                List {
                    ForEach(timedTasks) { task in
                        NavigationLink {
                            TimedDetailView(task: task)
                        } label: {
                            TimedRowView(task: task)
                        }
                    }
                    .onDelete { IndexSet in
                        PersistenceController().deleteTimedTask(offsets: IndexSet, tasks: timedTasks, viewContext: self.viewContext)
                    }
                }
                    .frame(alignment: .top)
                    .tabItem {
                        Image(systemName: "timer")
                        Text("Timed")
                    }
            }
                .accentColor(Color.orange)
                .tint(Color.orange)
                .navigationTitle("YOUR BEANS")
                .navigationBarTitleDisplayMode(.inline)
                .font(.largeTitle)
                .toolbar {
                    ToolbarItem {
                        Button {
                            showCreationSelectorView.toggle()
                        } label: {
                            Image(systemName: "plus")
                        }
                            .dynamicTypeSize(.xxxLarge)
                            .foregroundColor(Color.orange)
                    }
                }
                .sheet(isPresented: $showCreationSelectorView) {
                    CreationSelectionView(showCreationSelectorView: $showCreationSelectorView)
                }
        }
            .accentColor(Color.orange)
            .tint(Color.orange)
    }
    
}

/*
class TimedTaskModel: ObservableObject {
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \TimedTask.lastUpdated, ascending: false)], animation: .default)
    var timedTasks: FetchedResults<TimedTask>
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.test), name: .NSCalendarDayChanged, object: false)
    }
    
    @objc func test() -> Void {
        return
    }
    
}

class PercentageTaskModel: ObservableObject {
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \PercentageTask.lastUpdated, ascending: false)], animation: .default)
    var percentageTasks: FetchedResults<PercentageTask>
    
    @Published var chicken
} */

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}


