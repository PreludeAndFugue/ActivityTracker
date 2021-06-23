//
//  ActivityListView.swift
//  ActivityTracker
//
//  Created by gary on 23/06/2021.
//

import SwiftUI

struct ActivityListView: View {
    var body: some View {
        List {
            VStack(alignment: .leading) {
                HStack {
                    Text("Activity Title")

                    Spacer()

                    Text("11-12-2020")
                }
                Text("Activity subtitle")
            }

            VStack(alignment: .leading) {
                HStack {
                    Text("Activity Title")

                    Spacer()

                    Text("11-12-2020")
                }
                Text("Activity subtitle")
            }
        }
        .toolbar {
            Text("hello")
            Spacer()
            Button(action: {}) {
                Image(systemName: "arrow.up.arrow.down")
            }
        }
        .frame(minWidth: 250)
    }
}


#if DEBUG
struct ActivityListView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityListView()
    }
}
#endif
