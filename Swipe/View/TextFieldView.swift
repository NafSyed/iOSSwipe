//
//  TextFieldView.swift
//  Swipe
//
//  Created by Nafeez Ahmed on 15/11/24.
//

import SwiftUI

import SwiftUI

struct TextFieldView: View {
    @Binding var text: String
    @Binding var value: Double
    var isNumeric: Bool

    var body: some View {
        HStack {
            if isNumeric {
                // Numeric TextField
                HStack {
                    Image(systemName: "number")
                        .foregroundColor(.gray)
                    TextField("Enter value", value: $value, format: .number)
                        .keyboardType(.decimalPad)
                        .foregroundColor(.white)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.white.opacity(0.1))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 3)
                .padding(.horizontal, 15)
            } else {
                // Text TextField
                HStack {
                    Image(systemName: "text.cursor")
                        .foregroundColor(.gray)
                    TextField("Enter text", text: $text)
                        .foregroundColor(.white)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.white.opacity(0.1))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 3)
                .padding(.horizontal, 15)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
    }
}





#Preview {
    TextFieldView(text: .constant("hey"), value: .constant(0), isNumeric: false)
}
