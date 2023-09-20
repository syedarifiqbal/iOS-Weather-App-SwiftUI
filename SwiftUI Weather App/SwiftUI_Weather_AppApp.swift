//
//  SwiftUI_Weather_AppApp.swift
//  SwiftUI Weather App
//
//  Created by Arif Iqbal on 19/09/2023.
//

import SwiftUI

@main
struct SwiftUI_Weather_AppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(weathers: [
                Weather(dayName: "Wed", icon: "//cdn.weatherapi.com/weather/64x64/night/122.png", tempreture: "39"),
                
                Weather(dayName: "Thu", icon: "//cdn.weatherapi.com/weather/64x64/night/122.png", tempreture: "39"),
            
                Weather(dayName: "Fri", icon: "//cdn.weatherapi.com/weather/64x64/night/122.png", tempreture: "39"),
            
                Weather(dayName: "Sat", icon: "//cdn.weatherapi.com/weather/64x64/night/122.png", tempreture: "39"),
            
                Weather(dayName: "Sun", icon: "//cdn.weatherapi.com/weather/64x64/night/122.png", tempreture: "39"),
            ])
        }
    }
}
