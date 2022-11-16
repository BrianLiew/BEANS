import SwiftUI

struct TimedDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var task: FetchedResults<TimedTask>.Element
    
    var animation: Animation { Animation.easeInOut(duration: 1.5) }
    
    @State private var name: String = "Untitled"
    @State private var progress: Int = 0
    @State private var completionPercentage: Double = 0
    @State private var age: Int = 0
    @State private var progressStr: String = "Days"
    @State private var ageStr: String = "Days"
    
    @State private var buttonEnabled: Bool = true
        
    private enum Field {
        case name, increment
    }
    
    @FocusState private var focusedField: Field?
    
    var body: some View {
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
                    progress: $completionPercentage,
                    font: .largeTitle,
                    gradient: Gradient.init(primaryColor: task.color!),
                    line_width: 30,
                    size: CGSize(width: 200, height: 200))
                    .onAppear() {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation(self.animation) {
                                self.completionPercentage = Double(task.progress) / Double(age)
                                /*
                                if (Calendar.current.numberOfDaysInBetween(from: task.birth!, to: Date.now) > 0) {
                                    self.completionPercentage = Double(task.progress) / Double(age)
                                } */
                            }
                        }
                    }
                    .padding(.top, 50)
                    .onChange(of: task.progress, perform: { _ in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation(self.animation) {
                                self.completionPercentage = Double(task.progress) / Double(age)
                            }
                        }
                    })
                    .onChange(of: task.progress, perform: { _ in
                        self.progress = Int(task.progress)
                    })
                HStack(spacing: 50) {
                    VStack(alignment: .center) {
                        HStack {
                            Text("\(self.age)")
                                .foregroundColor(Gradient(primaryColor: task.color!).stops[1].color)
                                .font(.largeTitle)
                                .bold()
                            Text(self.ageStr)
                                .foregroundColor(Color.gray)
                                .font(.headline)
                                .onChange(of: self.age, perform: { _ in
                                    if (self.age == 1) {
                                        self.ageStr = "Day"
                                    }
                                    else {
                                        self.ageStr = "Days"
                                    }
                                })
                        }

                        Text("Old")
                            .foregroundColor(Color.gray)
                            .font(.headline)
                    }
                    VStack(alignment: .center) {
                        HStack {
                            Text("\(self.progress)")
                                .foregroundColor(Gradient(primaryColor: task.color!).stops[1].color)
                                .font(.largeTitle)
                                .bold()
                            Text(self.progressStr)
                                .foregroundColor(Color.gray)
                                .font(.headline)
                                .onChange(of: self.progress, perform: { _ in
                                    if (self.progress == 1) {
                                        self.progressStr = "Day"
                                    }
                                    else {
                                        self.progressStr = "Days"
                                    }
                                })

                        }
                        Text("Completed")
                            .foregroundColor(Color.gray)
                            .font(.headline)
                    }
                }
                    .scaledToFill()
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 50)
            }
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(buttonEnabled ? Gradient(primaryColor: task.color!) : Gradient(primaryColor: ""))
                    .padding(.horizontal, 50)
                    .shadow(radius: 5)
                Button {
                    task.progress += 1
                    task.lastUpdated = Date.now
                    self.buttonEnabled = false
                    PersistenceController().save(viewContext: self.viewContext)
                } label: {
                    Text(buttonEnabled ? "I did it!" : "Good job :)")
                        .foregroundColor(buttonEnabled ? Color.white : Utilities.getColorFromString(string: task.color!))
                        .multilineTextAlignment(.center)
                        .font(.largeTitle)
                        .bold()
                        .padding(20)
                }
                    .dynamicTypeSize(.xxxLarge)
                    .cornerRadius(10)
                    .disabled(buttonEnabled ? false : true)
            }
            Spacer()
            Text("Started \(Utilities.timeFormatter(time: task.birth!))")
                .font(.headline)
                .foregroundColor(.gray)
                .padding(20)
        }
            .onAppear() {
                self.name = task.name!
                self.progress = Int(task.progress)
                self.age = Calendar.current.numberOfDaysInBetween(from: task.birth!, to: Date.now) + 1
                if (Calendar.current.component(.day, from: Calendar.current.startOfDay(for: Date.now)) == Calendar.current.component(.day, from: Calendar.current.startOfDay(for: task.lastUpdated!))) {
                    buttonEnabled = false
                }
                else {
                    buttonEnabled = true
                }
            }
    }
}

struct TimedDetailView_Previews: PreviewProvider {
        
    static var previews: some View {
        let viewContext = PersistenceController().container.viewContext
        let task = TimedTask.init(context: viewContext)
        task.name = "Lorem Ipsum"
        task.color = "purple"
        task.birth = Calendar.current.date(from: DateComponents(
            year: 2022,
            month: 1,
            day: 1,
            hour: 1,
            minute: 0,
            second: 0))!
        task.progress = 160
        
        return TimedDetailView(task: task).environment(\.managedObjectContext, viewContext)
    }
}
