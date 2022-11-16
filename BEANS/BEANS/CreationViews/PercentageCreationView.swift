import SwiftUI

struct PercentageCreationView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @Binding var showCreationSelectorView: Bool
    
    private var animation: Animation {
        return Animation.easeInOut(duration: 1.5)
    }
        
    @State private var backgroundColor: Color = .clear
    
    @State private var goal: Double = 0
    @State private var progress: Double = 0
    
    @State private var name: String = "Untitled"
    @State private var birth: Date = Date.now
    @State private var color: String = "red"
    @State private var progressStr: String = "0"
    @State private var goalStr: String = "0"
                
    @State private var didError: Bool = false
    
    private enum Field {
        case progress, goal
    }
    
    @FocusState private var focusedField: Field?
    
    var body: some View {
        VStack {
            ColorPickerView(color: $color)
                .padding(20)
            Form {
                Section(header: Text("Details")) {
                    // MARK: - NAME
                    TextField("Untitled", text: $name)
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .scaledToFit()
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity)
                        .minimumScaleFactor(0.5)
                        .bold()
                        .padding(.vertical, 5)
                        .foregroundColor(Utilities.getColorFromString(string: self.color))
                }
                // MARK: - PROGRESS & GOAL?
                Section(header: Text("Values")) {
                    Text("Starting Count")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.headline)
                    TextField(self.progressStr, text: $progressStr)
                        .keyboardType(.decimalPad)
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(Utilities.getColorFromString(string: self.color))
                        .background(Color.clear)
                        .cornerRadius(10)
                        .frame(minHeight: 50)
                        .focused($focusedField, equals: .progress)
                        .onSubmit {
                            if (progressStr != "") {
                                if let progress = Double(self.progressStr) {
                                    self.progress = progress
                                }
                            }
                        }
                        .onChange(of: self.progressStr, perform: { _ in
                            if let progress = Double(self.progressStr) {
                                self.progress = progress
                            }
                        })
                    Text("Goal")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.headline)
                    TextField(self.goalStr, text: $goalStr)
                        .keyboardType(.decimalPad)
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(Utilities.getColorFromString(string: self.color))
                        .background(Color.clear)
                        .cornerRadius(10)
                        .frame(minHeight: 50)
                        .focused($focusedField, equals: .goal)
                        .onChange(of: self.goalStr, perform: { _ in
                            if let goal = Double(self.goalStr) {
                                self.goal = goal
                            }
                        })
                }
                    .multilineTextAlignment(.center)
            }
            ZStack {
                Rectangle()
                    .fill(Gradient(primaryColor: color))
                Button {
                    if (self.progress >= self.goal) {
                        didError = true
                    }
                    else {
                        PersistenceController().addPercentageTask(
                            name: self.name,
                            color: self.color,
                            progress: self.progress,
                            goal: goal,
                            viewContext: self.viewContext)
                        dismiss()
                        self.showCreationSelectorView = false
                    }
                } label: {
                    Text("Create")
                        .foregroundColor(Color.white)
                        .bold()
                }
                    .alert("Oopsie!",
                           isPresented: $didError,
                           actions: {
                                Button {
                                    didError = false
                                } label: {
                                    Text("Ok :(")
                                }
                            },
                           message: {
                                Text("The goal cannot be the same or less as the starting count")
                            }
                           )
                    .font(.largeTitle)
                    .dynamicTypeSize(.xxxLarge)
                    .padding(20)
            }
                .frame(minHeight: 50, maxHeight: 100)
        }
    }
    
}

struct PercentageCreationView_Previews: PreviewProvider {
    static var previews: some View {
        PercentageCreationView(showCreationSelectorView: .constant(true))
    }
}
