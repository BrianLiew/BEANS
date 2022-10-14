import Foundation
import SwiftUI

struct Utilities {
    
    static func formatNumber(value: Double) -> String {
        let formatter = NumberFormatter()
        
        // if value has fractional values
        if (value.truncatingRemainder(dividingBy: 1) > 0) {
            formatter.usesSignificantDigits = true
            formatter.alwaysShowsDecimalSeparator = true
        }
        // if value is a whole number
        else {
            formatter.usesSignificantDigits = false
            formatter.alwaysShowsDecimalSeparator = false
            formatter.maximumFractionDigits = 0
        }
        
        return formatter.string(from: NSNumber.init(value: value))!
    }
    
    static func formatPercentage(value: Double) -> String {
        let formatter = NumberFormatter()
        
        // if value has fractional values
        if (value.truncatingRemainder(dividingBy: 1) > 0) {
            formatter.usesSignificantDigits = true
            formatter.alwaysShowsDecimalSeparator = true
            formatter.maximumFractionDigits = 2
            formatter.roundingIncrement = 0.01
        }
        // if value is a whole number
        else {
            formatter.usesSignificantDigits = false
            formatter.alwaysShowsDecimalSeparator = false
            formatter.maximumFractionDigits = 0
        }
        
        return "\(formatter.string(from: NSNumber.init(value: value))!)%"
    }
    
    static func timeFormatter(time: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, dd MMM yyy"
        
        return formatter.string(from: time)
    }
    
    static func getColorFromString(string: String) -> Color {
        switch (string) {
            case "red":
                return Color.red
            case "yellow":
                return Color.yellow
            case "green":
                return Color.green
            case "blue":
                return Color.blue
            case "purple":
                return Color.purple
            default:
                return Color.black
        }
    }
    
}

extension Gradient {
    
    init(primaryColor: String) {
        var colors: [Color] = []
        
        switch(primaryColor) {
            case "red":
                colors = [.pink, .red]
            case "yellow":
                colors = [.yellow, .orange]
            case "green":
                colors = [.mint, .green]
            case "blue":
                colors = [.teal, .blue]
            case "purple":
                colors = [.purple, .indigo]
            default:
                colors = [.white, .gray]
        }
        
        self.init(colors: colors)
    }
    
}
