import SwiftUI

struct ProgressView: View {
    
    @Binding var progress: Double
    @Binding var goal: Double
    
    @State var displayedProgress: Double = 0
    
    var gradient: Gradient
    
    var body: some View {
        Text("\(Utilities.formatNumber(value: self.displayedProgress)) / \(Utilities.formatNumber(value: self.goal))")
            .foregroundColor(self.gradient.stops[1].color)
            .font(.title3)
            .bold()
            .scaledToFit()
            .minimumScaleFactor(0.5)
            .fixedSize(horizontal: false, vertical: true)
            .onAppear() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.updateProgress()
                }
            }
            .onChange(of: progress, perform: { _ in
                DispatchQueue.main.async {
                    self.updateProgress()
                }
            })
    }
    
    func updateProgress() -> Void {
        self.displayedProgress = progress
    }
}

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        return ProgressView(
            progress: .constant(5),
            goal: .constant(100),
            gradient: Gradient(primaryColor: "red"))
    }
}
