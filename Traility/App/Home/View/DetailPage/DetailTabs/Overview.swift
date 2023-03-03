//
//  Overview.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 1/22/23.
//

import SwiftUI
import MapKit
import SimpleToast

struct Overview: View {
    @EnvironmentObject var place : ParkViewModel
    @EnvironmentObject var detailMV : DetailViewModel
    @Binding var showingOptions : Bool
    
    var body: some View {
        VStack(alignment : .leading) {
            HStack(alignment : .top) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(place.name)
                        .font(.poppins(size: 18, weight: .medium))
                    Text("\(place.city), \(place.state)")
                        .font(.poppins(size: 14, weight: .light))
                        .foregroundColor(.black.opacity(0.8))
                        .multilineTextAlignment(TextAlignment.leading)
                }
                
                Spacer()
            }
            
            let status = getVisitStatusAttr()
            HStack {
                Image(systemName: status.systemName)
                    .foregroundColor(status.color)
                
                
                Text(status.text)
                    .font(.poppins())
            }
            .padding(.top, 10)
            
            ParagraphView(title: "About", paragraph: place.description)
            OverviewInfoView()
                .padding(.vertical, 25)
            
            
            Text("Location information")
                .padding(.vertical, 5)
                .padding(.top)
            
            
            Map(coordinateRegion: getRegion(), annotationItems: self.getAnnotation()) {
                MapMarker(coordinate: $0.coordinate)
            }
            .frame(width: UIScreen.screenWidth - 40, height: UIScreen.screenWidth * 9/16)
            
            Button {
                showingOptions = true
            } label: {
                HStack {
                    Image(systemName: "car")
                    
                    Text("Get Directions")
                        .font(.poppins(size: 15))
                }
                .padding(.vertical)
            }
            
            ParagraphView(title : "" , paragraph : place.directionsInformation)
            
            Spacer()
        }.padding()
            .padding(.bottom, 20)
            .background(Color(.systemBackground))
    }
    
    //MARK: - Functions
    private func getRegion() -> Binding<MKCoordinateRegion> {
        var coordinate = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: self.place.latitude,
                longitude: self.place.longitude),
            span: MKCoordinateSpan(
                latitudeDelta: 0.05,
                longitudeDelta: 0.05)
        )
        
        return Binding(get: {coordinate}, set: {coordinate = $0})
    }
    
    private func getAnnotation() -> [LocationItem] {
        let annotations = [
            LocationItem(name: self.place.name, coordinate: CLLocationCoordinate2D(latitude: self.place.latitude, longitude: self.place.longitude))
        ]
        return annotations
    }
    
    private func getVisitStatusAttr() -> (color : Color, text : String, systemName : String) {
            if detailMV.addedToList && detailMV.isVisited {
                return (Color.green, "Visisted", "checkmark.circle.fill")
            } else if detailMV.addedToList {
                return  (Color.yellow, "In the visit list", "clock.badge.fill")
            }
            
            return (Color(.systemGray5), "Not in the list", "clock.fill")
    }
}

struct Overview_Previews: PreviewProvider {
    static var previews: some View {
        Overview(showingOptions: .constant(false))
    }
}

struct ParagraphView : View {
    var title : String
    var paragraph : String
    var body: some View {
        if !title.isEmpty {
            Text(title)
                .padding(.vertical, 5)
                .padding(.top)
        }

            Text(paragraph)
                .font(.poppins(size: 13, weight: .light))
                .lineSpacing(5)
    }
}

