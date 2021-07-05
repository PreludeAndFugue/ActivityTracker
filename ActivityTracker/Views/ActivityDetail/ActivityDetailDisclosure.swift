//
//  ActivityDetailDisclosure.swift
//  ActivityTracker
//
//  Created by gary on 05/07/2021.
//

import SwiftUI

struct ActivityDetailDisclosure: View {
    let activity: Activity?

    var body: some View {
        DisclosureGroup("Activity information") {
            HStack {
                VStack(alignment: .leading) {
                    Text(title)
                    Text(dateString)
                    Text("Type: \(typeString)")
                    Text("Gear: \(gearString)")
                    Text("Distance: \(distanceString)")
                    Text("Duration: \(durationString)")
                }
                Spacer()
            }
        }
        .padding(8)
        .background(Color("DisclosureBackground"))
        .frame(maxWidth: 250, alignment: .leading)
        .cornerRadius(8)
        .padding(10)
    }
}


// MARK: - Private

private extension ActivityDetailDisclosure {
    var title: String {
        activity?.title ?? ""
    }


    var dateString: String {
        activity?.dateString ?? ""
    }


    var typeString: String {
        activity?.type.title ?? ""
    }


    var gearString: String {
        activity?.gear.description ?? ""
    }


    var distanceString: String {
        activity?.distanceInKilometres ?? ""
    }


    var durationString: String {
        activity?.elapsedTimeString ?? ""
    }
}


#if DEBUG
struct ActivityDetailDisclosure_Previews: PreviewProvider {
    static var previews: some View {
        ActivityDetailDisclosure(activity: .dummy1)
    }
}
#endif
