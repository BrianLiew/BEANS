//
//  ColorPickerView.swift
//  BEANS
//
//  Created by Brian Liew on 9/30/22.
//

import SwiftUI

struct ColorPickerView: View {
    
    @Binding var color: String
    
    var body: some View {
        HStack(spacing: 30) {
            Button {
                color = "red"
            } label : {
                Circle()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.red)
            }
            Button {
                color = "yellow"
            } label : {
                Circle()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.yellow)
            }
            Button{
                color = "green"
            } label: {
                Circle()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.green)
            }
            Button {
                color = "blue"
            } label: {
                Circle()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.blue)
            }
            Button {
                color = "purple"
            } label: {
                Circle()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.purple)
            }
        }
            .cornerRadius(10)
            .scaledToFit()
    }
}

struct ColorPickerView_Previews: PreviewProvider {
    static var previews: some View {
        ColorPickerView(color: .constant("red"))
    }
}
