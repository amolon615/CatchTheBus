//
//  Color+Extensions.swift
//  CatchTheBus
//
//  Created by amolonus on 02/03/2025.
//
import SwiftUI

extension Color {
    init(hex: Int, alpha: Double = 1.0) {
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double((hex & 0xff) >> 0) / 255.0
        self.init(.displayP3, red: red, green: green, blue: blue, opacity: alpha)
    }
}
