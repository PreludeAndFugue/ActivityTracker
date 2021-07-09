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
            HStack {
                Text("Bike")
                Text(model.bikeDistanceString)
                Text(model.bikeElapsedTimeString)
            }
            GeometryReader { proxy in
                BarChartView(heights: [20, 0, 30, 40, 50, 10, 100], size: proxy.size)
            }
        }
    }
}


#if DEBUG
struct StatisticsView_Previews: PreviewProvider {
    private static let db = Database.init(dummy: true)
    private static let model = StatisticsViewModel(db: db)

    static var previews: some View {
        Group {
            StatisticsView(model: model)

            StatisticsView(model: model)
                .frame(width: 300, height: 100)
        }
    }
}
#endif
