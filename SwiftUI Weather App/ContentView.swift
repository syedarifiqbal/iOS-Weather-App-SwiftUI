//
//  ContentView.swift
//  SwiftUI Weather App
//
//  Created by Arif Iqbal on 19/09/2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isNight:Bool = false
    @ObservedObject private var locationViewModel = LocationViewModel()
    @State var weathers: [Weather]
        
    // Function to fetch weather data from the API
    func fetchWeatherData() {
        let apiKey = "e35366d5e62a4621b58191550231909" //this is dummy api key i will revoke, please use your key from https://weatherapi.com
        
        guard let url = URL(string: "https://api.weatherapi.com/v1/forecast.json?key=\(apiKey)&q=\(locationViewModel.latitude),\(locationViewModel.longitude)&days=7&aqi=no&alerts=no") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let weatherData = try JSONDecoder().decode(WeatherResponse.self, from: data)
                    
                    DispatchQueue.main.async {
                        self.weathers = weatherData.forecast.forecastday.map { forecast in
                            
                            let weather = Weather(dayName: forecast.date, icon: forecast.day.condition.icon, tempreture: "\(forecast.day.avgtemp_c)")

                            return weather
                        }
                    }
                    
                    
                } catch {
                    print(error)
                }
            }
        }
        .resume()
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [isNight ? .black : .blue, isNight ? .gray : Color("lightBlue")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack () {
                Text(locationViewModel.cityName)
                    .font(.system(size: 36, weight: .medium, design: .default))
                    .foregroundColor(.white)
                    .padding()
                
                TodayStatusView(isNight: isNight, weathers: weathers)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack (spacing: 0) {
                        ForEach(self.weathers) { weather in
                            WeekDayView(dayOfWeek: weather.dayName, iconName:weather.icon, tempreture: weather.tempreture)
                        }
                    }
                }
                .padding(10)
                Spacer()
                
                DefaultButton(label: "Change Day Time", bgColor: .white, textColor: .blue, action: {
                    isNight.toggle()
                })
                
                Spacer()
            }
        }.onAppear {
            // Fetch weather data when the view appears
            fetchWeatherData()
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(weathers: [
                Weather(dayName: "2023-09-18", icon: "//cdn.weatherapi.com/weather/64x64/night/122.png", tempreture: "39"),
                
                Weather(dayName: "2023-09-19", icon: "//cdn.weatherapi.com/weather/64x64/night/122.png", tempreture: "39"),
            
                Weather(dayName: "2023-09-20", icon: "//cdn.weatherapi.com/weather/64x64/night/122.png", tempreture: "39"),
            
                Weather(dayName: "2023-09-21", icon: "//cdn.weatherapi.com/weather/64x64/night/122.png", tempreture: "39"),
            
                Weather(dayName: "2023-09-22", icon: "//cdn.weatherapi.com/weather/64x64/night/122.png", tempreture: "39"),
            ])
    }
}

struct TodayStatusView : View {

    var isNight: Bool
    var weathers: [Weather]

    var body: some View {
        VStack {
            if let currentWeather = weathers.first {
              
                RemoteImage(url: currentWeather.icon, width: 180, height: 180)
                
                Text("\(currentWeather.tempreture)°")
                    .font(.system(size: 72, weight: .medium, design: .default))
                    .foregroundColor(.white)
                
            }
        }
        .padding(.bottom, 40)
    }
}

struct WeekDayView : View {
    
    var dayOfWeek: String
    var iconName: String
    var tempreture: String
    
    func getThreeCharacterDayName(from dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "E"
            return dateFormatter.string(from: date)
        }
        
        return "NaN"
    }
    
    var body: some View {
        VStack(alignment: .center){
            Text(getThreeCharacterDayName(from: dayOfWeek))
                .font(.system(size: 18, weight: .medium, design: .default))
                .foregroundColor(.white)
            
            RemoteImage(url: iconName, width: 40, height: 40)
            
            
            Text("\(tempreture)°")
                .font(.system(size: 22, weight: .medium, design: .default))
                .foregroundColor(.white)
        }
        .frame(width: 80)

    }
}

struct RemoteImage : View {
    
    let url: String
    let width: CGFloat
    let height: CGFloat
    let icons: [String: String] = [
        "//cdn.weatherapi.com/weather/64x64/day/302.png": "cloud.fill",
        "//cdn.weatherapi.com/weather/64x64/day/113.png": "moon.fill",
        "//cdn.weatherapi.com/weather/64x64/day/176.png": "cloud.moon.rain.fill",
        "//cdn.weatherapi.com/weather/64x64/day/353.png": "cloud.moon.rain.fill",
        "//cdn.weatherapi.com/weather/64x64/day/116.png": "cloud.moon.fill",
        "//cdn.weatherapi.com/weather/64x64/day/119.png": "moon.stars.fill",
        "//cdn.weatherapi.com/weather/64x64/day/122.png": "cloud.fill",

        // We can map further icons i just mapped what i found the link. will update if i have time and see new weather icon link
    ]
    
    var body : some View{
        
        
        if let icon = icons[url] {
            Image(systemName: icon)
//                .renderingMode(.original)
                .symbolRenderingMode(.multicolor)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width, height: height)
        } else {
            AsyncImage(url: URL(string: "https:\(url)")) { phase in
                if let image = phase.image {
                    image
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: width, height: height)
                } else if phase.error != nil {
                    // Handle the error, e.g., display a placeholder or error message
                    Image(systemName: "photo")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: width, height: height)
                        .foregroundColor(.gray)
                } else {
                    // You can display a loading indicator here if needed
                    ProgressView()
                }
            }
        }
    }
}

/**
 Models
 */
struct WeatherResponse: Decodable {
    let location: Location
    let current: Current
    let forecast: Forecast
}

struct Location: Decodable {
    let name: String
}

struct Current: Decodable {
    let temp_c: Double
    let condition: Condition
}

struct Condition: Decodable {
    let text: String
    let icon: String
    let code: Int
}

struct Forecast: Decodable {
    let forecastday: [ForecastDay]
}

struct ForecastDay: Decodable {
    let date: String
    let day: Day
}

struct Day: Decodable {
    let maxtemp_c: Double
    let condition: Condition
    let avgtemp_c: Double
}

struct WeatherData {
    let dayName: String
    let icon: String
    let temperature: String
}
