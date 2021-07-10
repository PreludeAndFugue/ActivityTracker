//
//  WeekNavigatorView.swift
//  ActivityTracker
//
//  Created by gary on 10/07/2021.
//

import SwiftUI

struct WeekNavigatorView: View {
    @StateObject var model: StatisticsViewModel

    var body: some View {
        HStack {
            Button(action: previousWeek) {
                Image(systemName: "chevron.backward")
            }
            Button(action: nextWeek) {
                Image(systemName: "chevron.forward")
            }
            Text(dateString)
                .font(.system(size: 25))
        }
        .frame(alignment: .leading)
    }
}


private extension WeekNavigatorView {
    func previousWeek() {
        model.previousWeek()
    }


    func nextWeek() {
        model.nextWeek()
    }


    var dateString: String {
        let start = model.weekInterval.start
        let end = Calendar.current.date(byAdding: .minute, value: -10, to: model.weekInterval.end)!
        return dateIntervalFormatter.string(from: start, to: end)
    }
}


#if DEBUG
struct WeekNavigatorView_Previews: PreviewProvider {
    private static let db = Database.dummy
    private static let model = StatisticsViewModel(db: db)
    static var previews: some View {
        WeekNavigatorView(model: model)
    }
}
#endif
