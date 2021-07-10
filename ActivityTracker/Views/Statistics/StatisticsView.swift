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
        GeometryReader { proxy in
            VSplitView {
                VStack(spacing: 10) {
                    HStack(alignment: .firstTextBaseline) {
                        Text(model.bikeDistanceString)
                            .font(.system(size: 25))
                        Text("of " + model.bikeWeekString)
                    }

                    HStack {
                        ZStack(alignment: .leading) {
                            Capsule(style: .circular)
                                .foregroundColor(.gray)
                                .frame(width: 200, height: 10)
                            Capsule(style: .continuous)
                                .foregroundColor(.purple)
                                .frame(width: 200 * model.bikeWeekPercentage, height: 10)
                        }
                        Text(model.bikeWeekPercentageString)
                    }
                    .frame(width: 300)

                    HStack {
                        Text(model.bikeElapsedTimeString)

                        Text(model.elevationGainString)
                    }

                    BarChartView(data: .week(model.bikeWeekDistances), size: CGSize(width: 300, height: 200))
                }
                .frame(idealHeight: proxy.size.height / 3)

                VStack {
                    Text("Monthly stats")
                    BarChartView(data: .month(model.bikeMonthDistances), size: CGSize(width: 750, height: 200))
                }
                .frame(idealHeight: proxy.size.height / 3)

                VStack {
                    Text("annual stats")
                }
                .frame(idealHeight: proxy.size.height / 3)
            }
            .padding()
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
