//
//  TimedRowView.swift
//  BEANS
//
//  Created by Brian Liew on 10/3/22.
//

import SwiftUI

struct TimedRowView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var task: FetchedResults<TimedTask>.Element
    
    private var animation: Animation {
        Animation.easeInOut(duration: 1.5)
    }
    
    @State var name: String = "Untitled"
    @State var progress: Int = 0
    @State var completionPercentage: Double = 0
    @State var age: Int = 0
    
    var body: some View {
        HStack {
            RingView(progress: $completionPercentage, font: .headline, gradient: Gradient.init(primaryColor: task.color!), line_width: 15, size: CGSize(width: 80, height: 80))
                .frame(minWidth: 100, maxWidth: 100, minHeight: 100, maxHeight: 100)
                .onAppear() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation(self.animation) {
                            self.completionPercentage = Double(task.progress) / Double(self.age)
                        }
                    }
                }
                .onChange(of: task.progress, perform: { _ in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation(self.animation) {
                            self.completionPercentage = Double(task.progress) / Double(self.age)
                        }
                    }
                })
            VStack(alignment: .leading) {
                Text(name)
                    .font(.largeTitle)
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
                    .padding(.bottom, 10)
                    .onAppear() {
                        self.name = task.name!
                    }
                Text("\(self.progress) / \(self.age) days")
                    .font(.title3)
            }
                .bold()
                .padding(20)
                .foregroundColor(Utilities.getColorFromString(string: task.color!))
                .multilineTextAlignment(.leading)
        }
        .onAppear() {
            self.progress = Int(task.progress)
            self.age = Calendar.current.numberOfDaysInBetween(from: task.birth!, to: Date.now) + 1
        }
    }
}

struct TimedRowView_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController().container.viewContext
        let task = TimedTask.init(context: viewContext)
        task.name = "Lorem Ipsum long ass title blah blah"
        task.color = "purple"
        task.progress = 4
        
        return TimedRowView(task: task).environment(\.managedObjectContext, viewContext)
            .previewLayout(.fixed(width: 1000, height: 300))    }
}
