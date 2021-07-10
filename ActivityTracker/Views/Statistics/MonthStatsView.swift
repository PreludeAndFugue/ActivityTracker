//
//  MonthStatsView.swift
//  ActivityTracker
//
//  Created by gary on 10/07/2021.
//

import SwiftUI

struct MonthStatsView: View {
    @StateObject var model: StatisticsViewModel

    var body: some View {
        VStack {
            Text("Monthly stats")
            BarChartView(data: .month(model.bikeMonthDistances), size: CGSize(width: 750, height: 200))
        }
    }
}


#if DEBUG
struct MonthStatsView_Previews: PreviewProvider {
    private static let db = Database.dummy
    private static let model = StatisticsViewModel(db: db)
    static var previews: some View {
        MonthStatsView(model: model)
    }
}
#endif
