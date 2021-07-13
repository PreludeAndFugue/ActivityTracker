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
            Text(month)
                .font(.system(size: 20))

            Text(model.bikeMonthDistanceString)
                .font(.system(size: 25))

            BarChartView(data: .month(model.bikeMonthDistances), size: CGSize(width: 750, height: 200))
        }
    }
}


// MARK: - Private

private extension MonthStatsView {
    var month: String {
        let month = Calendar.current.dateComponents([.month], from: model.date).month ?? 0
        return Calendar.current.monthSymbols[month - 1]
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
