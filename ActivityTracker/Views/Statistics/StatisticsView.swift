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
                WeekNavigatorView(model: model)
                    .frame(height: 0.1 * proxy.size.height)
                
                WeekStatsView(model: model)
                    .padding([.top, .bottom], 10)
                    .frame(height: 0.3 * proxy.size.height)

                MonthStatsView(model: model)
                    .padding([.top, .bottom], 10)
                    .frame(height: 0.35 * proxy.size.height)

                YearStatsView(model: model)
                    .padding([.top, .bottom], 10)
                    .frame(height: 0.25 * proxy.size.height)
            }
            .padding([.leading, .trailing], 10)
            .frame(maxWidth: .infinity)
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
