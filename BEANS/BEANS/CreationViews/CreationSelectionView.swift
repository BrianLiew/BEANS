//
//  CreationSelectionView.swift
//  BEANS
//
//  Created by Brian Liew on 10/14/22.
//

import SwiftUI

struct CreationSelectionView: View {
    var body: some View {
        NavigationView {
            VStack {
                RoundedRectangle(cornerRadius: 100)
                    .frame(maxWidth: 50, maxHeight: 5)
                    .foregroundColor(Color.gray)
                    .padding(.top, 20)
                Text("I'd like to...")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(Color.gray)
                    .background(Color.clear)
                    .padding(20)
                List {
                    NavigationLink {
                        CounterCreationView()
                    } label: {
                        PercentageSelectionRowView()
                    }
                    NavigationLink {
                        CounterCreationView()
                    } label: {
                        AccumulatorSelectionRowView()
                    }
                    NavigationLink {
                        TimerCreationView()
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
        CreationSelectionView()
    }
}
