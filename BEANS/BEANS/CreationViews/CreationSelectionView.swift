import SwiftUI

struct CreationSelectionView: View {
    @Binding var showCreationSelectorView: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                RoundedRectangle(cornerRadius: 100)
                    .frame(maxWidth: 50, maxHeight: 5)
                    .foregroundColor(Color.gray.opacity(0.5))
                    .padding(.top, 20)
                Text("I'd like to...")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(Color.gray)
                    .background(Color.clear)
                    .padding(20)
                List {
                    NavigationLink {
                        PercentageCreationView(showCreationSelectorView: $showCreationSelectorView)
                    } label: {
                        PercentageSelectionRowView()
                    }
                    NavigationLink {
                        AccumulatorCreationView(showCreationSelectorView: $showCreationSelectorView)
                    } label: {
                        AccumulatorSelectionRowView()
                    }
                    NavigationLink {
                        TimerCreationView(showCreationSelectorView: $showCreationSelectorView)
                    } label: {
                        TimedSelectionRowView()
                    }
                }
            }
        }
    }
}

struct CreationSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        CreationSelectionView(showCreationSelectorView: .constant(true))
    }
}
