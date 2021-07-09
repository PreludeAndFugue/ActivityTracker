//
//  StatisticsView.swift
//  ActivityTracker
//
//  Created by gary on 09/07/2021.
//

import SwiftUI

struct StatisticsView: View {
    @StateObject var model: StatisticsViewModel


    var body: some View {
        VStack {
            GeometryReader { proxy in
                HStack {
                    Text("Bike")
                    Text(model.bikeDistanceString)
                    Text(model.bikeElapsedTimeString)
                }
                BarChartView(heights: model.bikeDayDistances, size: proxy.size)
            }
        }
        .frame(width: 500, height: 300)
    }
}


#if DEBUG
struct StatisticsView_Previews: PreviewProvider {
    private static let db = Database.init(dummy: true)
    static var previews: some View {
        StatisticsView(model: .init(db: db))
    }
}
#endif
