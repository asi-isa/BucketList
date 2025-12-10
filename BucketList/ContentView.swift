//
//  ContentView.swift
//  BucketList
//
//  Created by Ali Soner Inceoglu on 07.12.25.
//

import MapKit
import SwiftUI

struct ContentView: View {
    let startPoint = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 56, longitude: -3),
            span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        )
    )
    
    @State private var viewModel = ViewModel()
    
    var body: some View {
        if viewModel.isUnlocked {
            MapReader { proxy in
                Map(initialPosition: startPoint) {
                    ForEach(viewModel.locations) { location in
                        Annotation(location.name, coordinate: location.coordinate) {
                            Image(systemName: "star.circle")
                                .resizable()
                                .foregroundStyle(.red)
                                .frame(width: 44, height: 44)
                                .background(.white)
                                .clipShape(.circle)
                                .contentShape(.circle)
                                .onTapGesture(count: 2, perform: {
                                    viewModel.selectedLocation = location
                                })
                                .onLongPressGesture {
                                    viewModel.selectedLocation = location
                                }
                        }
                    }
                }
                .onTapGesture { position in
                    if let coordinate = proxy.convert(position, from: .local) {
                        viewModel.addLocation(at: coordinate)
                    }
                }
                .sheet(item: $viewModel.selectedLocation) { location in
                    EditView(location: location, onSave: viewModel.updateSelectedLocation)
                }
            }
        } else {
            Button("Unlock", action: viewModel.authenticate)
        }
    }
}

#Preview {
    ContentView()
}
