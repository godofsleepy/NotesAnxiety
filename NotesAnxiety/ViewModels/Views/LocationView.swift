//
//  LocationView.swift
//  NotesAnxiety
//
//  Created by Sena Kristiawan on 13/07/24.
//

import SwiftUI
import CoreLocation
import CoreLocationUI

struct LocationView: View {
    @StateObject var locationManager = LocationManager()
    
    var body: some View {
        VStack{
            if let location = locationManager.location{
                Text("Your location: \(location.latitude), \(location.longitude)")
            }
            
            LocationButton{
                locationManager.requestLocation()
            }
            .frame(height: 44)
            .padding()
        }
    }
}

#Preview {
    LocationView()
}
