//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by Ali Soner Inceoglu on 10.12.25.
//

import CoreLocation
import Foundation
import LocalAuthentication
import MapKit

extension ContentView {
    @Observable
    class ViewModel {
        private(set) var locations: [Location]
        var selectedLocation: Location?
        var isUnlocked = false
        
        let savePath = URL.documentsDirectory.appending(path: "SavedPlaces")
        
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
                print(error.localizedDescription)
            }
        }
        
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch {
                print(error.localizedDescription)
            }
        }
        
        func addLocation(at location: CLLocationCoordinate2D) {
            let newLocation = Location(id: UUID(), name: "New location", description: "", latitude: location.latitude, longitude: location.longitude)
            
            locations.append(newLocation)
            
            save()
        }
        
        func updateSelectedLocation(with newLocation: Location) {
            guard let selectedLocation else { return }
            
            guard let index = locations.firstIndex(of: selectedLocation) else { return }
            
            locations[index] = newLocation
            
            save()
        }
        
        func authenticate() {
            Task {
                let context = LAContext()
                var error: NSError?
                
                guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
                else {
                    // no biometrics
                    return
                }
                
                guard let _ = try? await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Please authenticate yourself to unlock your places.")
                else {
                    // error
                    return
                }
                
                isUnlocked = true
            }
        }
    }
}
