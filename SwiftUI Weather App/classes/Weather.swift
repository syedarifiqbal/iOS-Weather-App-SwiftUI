//
//  Weather.swift
//  SwiftUI Weather App
//
//  Created by Arif Iqbal on 20/09/2023.
//

class Weather: Identifiable {
    var dayName: String
    var icon: String
    var tempreture: String
    
    init(dayName: String, icon: String, tempreture: String) {
        self.dayName = dayName
        self.icon = icon
        self.tempreture = tempreture
    }
}
