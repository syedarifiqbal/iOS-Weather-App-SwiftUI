//
//  DefaultButton.swift
//  SwiftUI Weather App
//
//  Created by Arif Iqbal on 19/09/2023.
//

import SwiftUI


struct DefaultButton : View {
    
    var label:String
    var bgColor: Color = .blue
    var textColor: Color = .white
    var action: () -> Void
    
    var  body: some View {
        Button(action: action, label: {
            Text(label)
                .font(.system(size: 22, weight: .bold, design: .default))
                .foregroundColor(textColor)
                .frame(width: 280, height: 50)
                .background(bgColor)
                .cornerRadius(10)
        })
    }
}

struct DefaultButton_Previews: PreviewProvider {
    static var previews: some View {
        DefaultButton(label: "Hello World", action: {})
    }
}
