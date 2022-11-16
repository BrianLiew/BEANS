import SwiftUI

struct AccumulatorCreationView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @Binding var showCreationSelectorView: Bool
    
    private var animation: Animation {
        return Animation.easeInOut(duration: 1.5)
    }
    
    @State private var hasGoal: Bool = false
    
    @State private var backgroundColor: Color = .clear
    
    @State private var goal: Double? = nil
    @State private var progress: Double = 0
    
    @State private var name: String = "Untitled"
    @State private var birth: Date = Date.now
    @State private var color: String = "red"
    @State private var progressStr: String = "0"
    @State private var goalStr: String = "0"
                
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
                }
                    .multilineTextAlignment(.center)
            }
            ZStack {
                Rectangle()
                    .fill(Gradient(primaryColor: color))
                Button {
                    if (hasGoal == false) {
                        PersistenceController().addAccumulatorTask(
                            name: self.name,
                            color: self.color,
                            progress: self.progress,
                            viewContext: self.viewContext)
                    }
                    else {
                        if let goal = self.goal {
                            PersistenceController().addPercentageTask(
                                name: self.name,
                                color: self.color,
                                progress: self.progress,
                                goal: goal,
                                viewContext: self.viewContext)
                        }
                    }
                    showCreationSelectorView = false
                } label: {
                    Text("Create")
                        .foregroundColor(Color.white)
                        .bold()
                }
                    .font(.largeTitle)
                    .dynamicTypeSize(.xxxLarge)
                    .padding(20)
            }
                .frame(minHeight: 50, maxHeight: 100)
        }
    }
    
}

struct AccumulatorCreationView_Previews: PreviewProvider {
    static var previews: some View {
        AccumulatorCreationView(showCreationSelectorView: .constant(true))
    }
}
