//
//  CreationView.swift
//  BEANS
//
//  Created by Brian Liew on 9/26/22.
//

import SwiftUI

struct CreationView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    private var animation: Animation {
        return Animation.easeInOut(duration: 1.5)
    }
    
    @State private var hasGoal: Bool = false
    @State private var hasDeadline: Bool = false
    @State private var hasDaily: Bool = false
    
    @State private var backgroundColor: Color = .clear
    
    @State private var goal: Double? = nil
    @State private var progress: Double = 0
    
    @State private var name: String = "Untitled"
    @State private var birth: Date = Date.now
    @State private var color: String = "red"
    @State private var progressStr: String = "0"
    @State private var goalStr: String = "0"
    @State private var deadline: Date = Date.now
    // @State private var dailyReminderTime: Date?
    
    private enum Field: Int, CaseIterable {
        case progress, goal
    }
    
    @FocusState private var focusedField: Field?
    
    var body: some View {
            VStack {
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
                        dismiss()
                    } label: {
                        Image(systemName: "note.text.badge.plus")
                            .foregroundColor(Color.white.opacity(0.5))
                    }
                        .font(.largeTitle)
                        .dynamicTypeSize(.xxxLarge)
                }
                    .frame(minHeight: 50, maxHeight: 100)
                Spacer(minLength: 30)
                ColorPickerView(color: $color)
                Form {
                    Section(header: Text("Task Details")) {
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
                    // MARK: - PROGRESS & GOAL?
                    Section(header: Text("Task Values")) {
                        Text("Starting Count")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.headline)
                        TextField(self.progressStr, text: $progressStr)
                            .keyboardType(.decimalPad)
                            .background(Color.gray.opacity(0.2))
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
                        VStack {
                            Toggle("Has Goal", isOn: $hasGoal)
                                .font(.headline)
                            TextField(self.goalStr, text: $goalStr)
                                .keyboardType(.decimalPad)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .frame(minHeight: 50)
                                .disabled(hasGoal ? false : true)
                                .opacity(hasGoal ? 1 : 0.25)
                                .focused($focusedField, equals: .goal)
                        }
                            .onChange(of: self.goalStr, perform: { _ in
                                self.goal = Double(self.goalStr)
                            })
                    }
                        .multilineTextAlignment(.center)
                }
            }
    }
    
}

struct CreationView_Previews: PreviewProvider {
    static var previews: some View {
        CreationView()
    }
}
