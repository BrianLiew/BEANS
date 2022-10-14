import SwiftUI

struct TimerCreationView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    private var animation: Animation {
        return Animation.easeInOut(duration: 1.5)
    }
    
    @State private var hasDeadline: Bool = false
    
    @State private var backgroundColor: Color = .clear
    
    @State private var goal: Double? = nil
    @State private var progress: Double = 0
    
    @State private var name: String = "Untitled"
    @State private var birth: Date = Date.now
    @State private var color: String = "red"
    @State private var deadline: Date = Date.now
    @State private var interval: String = "daily"
    @State private var reminderTime: Date = Date.now
    
    @State private var isTimedReminder: Bool = true
    @State private var isCountReminder: Bool = false
    
    private let dateRange: ClosedRange<Date> = {
        let startDate = DateComponents(
                        year: Calendar.current.component(.year, from: Date.now),
                        month: Calendar.current.component(.month, from: Date.now),
                        day: Calendar.current.component(.day, from: Date.now),
                        hour: Calendar.current.component(.hour, from: Date.now),
                        minute: Calendar.current.component(.minute, from: Date.now)
                    )
        let endDate = DateComponents(
                        year: 9999,
                        month: 12,
                        day: 31,
                        hour: 23,
                        minute: 59
                    )
        
        return Calendar.current.date(from: startDate)!...Calendar.current.date(from: endDate)!
    }()
    
    private enum Field {
        case deadline
    }
    
    @FocusState private var focusedField: Field?
    
    var body: some View {
        VStack {
            ColorPickerView(color: $color)
                .padding(20)
            Form {
                Section(header: Text("Name")) {
                    // MARK: - NAME
                    TextField("Untitled", text: $name)
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .scaledToFit()
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity)
                        .minimumScaleFactor(0.5)
                        .bold()
                        .padding(.vertical, 20)
                        .foregroundColor(Utilities.getColorFromString(string: self.color))
                }
                // MARK: -
                Section(header: Text("Notifications")) {
                    VStack {
                        DatePicker("Reminder Time",
                                   selection: $reminderTime,
                                   displayedComponents: .hourAndMinute)
                            .opacity(isTimedReminder ? 1 : 0)
                            .disabled(isTimedReminder ? false : true)
                            .datePickerStyle(.graphical)
                    }
                    VStack {
                        Toggle("Has Deadline", isOn: $hasDeadline)
                            .font(.headline)
                        DatePicker("Deadline",
                                   selection: $deadline,
                                   in: dateRange)
                            .labelsHidden()
                            .opacity(hasDeadline ? 1 : 0.25)
                            .disabled(hasDeadline ? false : true)
                            .datePickerStyle(.graphical)
                            .tint(Color.orange)
                            .accentColor(Color.orange)
                            .focused($focusedField, equals: .deadline)
                    }
                }
            }
                .multilineTextAlignment(.center)
            ZStack {
                Rectangle()
                    .fill(Gradient(primaryColor: color))
                Button {
                    PersistenceController().addTimedTask(name: self.name, color: self.color, viewContext: self.viewContext)
                    LocalNotificationsManager.generateLocalNotification(name: self.name, reminderTime: self.reminderTime)
                    dismiss()
                } label: {
                    Text("Create")
                        .bold()
                        .foregroundColor(Color.white.opacity(0.5))
                }
                    .font(.largeTitle)
                    .dynamicTypeSize(.xxxLarge)
            }
                .frame(minHeight: 50, maxHeight: 100)
        }
    }
    
}

struct TimerCreationView_Preview: PreviewProvider {
    static var previews: some View {
        TimerCreationView()
    }
}
