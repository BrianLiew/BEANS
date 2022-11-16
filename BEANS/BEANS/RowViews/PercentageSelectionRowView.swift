import SwiftUI

struct PercentageSelectionRowView: View {
    @State var percentage: Double = 0
    @State var title: String = "Count up to a goal"
    
    var body: some View {
        HStack {
            RingView(
                progress: $percentage,
                font: .headline,
                gradient: Gradient.init(colors: [Color.gray, Color.gray]),
                line_width: 15,
                size: CGSize(width: 80, height: 80)
            )
                .frame(minWidth: 100, maxWidth: 100, minHeight: 100, maxHeight: 100)
                .opacity(0.5)
                    .onAppear() {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation(Animation.easeInOut(duration: 1.5)) {
                                self.percentage = 0.69
                            }
                        }
                    }
            Text(title)
                .font(.largeTitle)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
                .bold()
                .multilineTextAlignment(.leading)
                .foregroundColor(Color.gray)
                .padding(20)
        }
    }
}

struct PercentageSelectionRowView_Previews: PreviewProvider {
    static var previews: some View {
        PercentageSelectionRowView()
            .previewLayout(.fixed(width: 400, height: 150))
    }
}
