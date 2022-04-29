//
//  DateManager.swift
//  PageViewControllerTest
//
//  Created by Егор Шкарин on 04.04.2022.
//

import Foundation
final class DateManager {
    private(set) var startDate: Date
    private(set) var finishDate: Date
    
    private(set) var formatter: DateFormatter
    
    init(formatter: DateFormatter, startDate: String, finishDate: String) {
        self.formatter = formatter
        self.startDate = formatter.date(from: startDate) ?? Date()
        self.finishDate = formatter.date(from: finishDate) ?? Date()
    }
    
    func datesRange() -> [Date] {
        var fromInterval = startDate.timeIntervalSince1970
        let toInterval = finishDate.timeIntervalSince1970
        var dates = [Date]()
        while fromInterval < toInterval {
            fromInterval += 60 * 60 * 24
            let date = Date(timeIntervalSince1970: fromInterval)
            dates.append(date)
        }
        return dates
    }
    func getCurrentWeek() -> Int {
        let currDate =  Date()
        let dateNow = currDate.timeIntervalSince1970
        var startDate = startDate.timeIntervalSince1970
        var dayCount = 0
        while dateNow > startDate {
            startDate += 60 * 60 * 24
            dayCount += 1
        }
        let currWeek = dayCount / 7
//        horizontalCollection.collectionView.scrollToItem(at: IndexPath(item: currWeek, section: 0),
//                                                         at: .centeredVertically,
//                                    animated: true)
        return currWeek
    }
    func getCurrDayAndDate() -> (String, String) {
        var result = ("", "")
        let currDate =  Date()
        let dateNow = currDate.timeIntervalSince1970
        var startDate = startDate.timeIntervalSince1970
        let newFormatter = DateFormatter()
        let comparingDateFormatter = DateFormatter()
        comparingDateFormatter.dateFormat = "MM-dd-yyyy"
        newFormatter.dateFormat = "d"
        while dateNow > startDate {
            startDate += 60 * 60 * 24
            let nowDate = comparingDateFormatter.string(from: Date(timeIntervalSince1970: dateNow))
            let start = comparingDateFormatter.string(from: Date(timeIntervalSince1970: startDate))
            if nowDate == start {
                let now = Date(timeIntervalSince1970: startDate)
                let dayDate = newFormatter.string(from: now)
                let day = now.dayOfWeek()
                if let day = day, day != "Воскресенье", let dayFormatter = DayFormatter(rawValue: day) {
                    let dayForm = dayFormatter.getDayForm()
                    result.0 = dayDate
                    result.1 = dayForm
                }
                break
            }
        }
        return result
    }
    func datesWithDays() -> [(String, String)] {
        var fromInterval = startDate.timeIntervalSince1970
        let toInterval = finishDate.timeIntervalSince1970
        var result = [(String, String)]()
        let newFormatter = DateFormatter()
        newFormatter.dateFormat = "d"
        while fromInterval < toInterval {
            fromInterval += 60 * 60 * 24
            let date = Date(timeIntervalSince1970: fromInterval)
            let dayDate = newFormatter.string(from: date)
            let day = date.dayOfWeek()
            if let day = day, day != "Воскресенье", let dayFormatter = DayFormatter(rawValue: day) {
                let dayForm = dayFormatter.getDayForm()
                let dayTuple = (dayDate, dayForm)
                result.append(dayTuple)
            }
        }
        return result
    }
    enum DayFormatter: String {
        case monday = "Понедельник"
        case tuesday = "Вторник"
        case wednsday = "Среда"
        case thursday = "Четверг"
        case friday = "Пятница"
        case saturday = "Суббота"
        
        func getDayForm() -> String{
            switch self {
            case .monday:
                return "Пн"
            case .tuesday:
                return "Вт"
            case .wednsday:
                return "Ср"
            case .thursday:
                return "Чт"
            case .friday:
                return "Пт"
            case .saturday:
                return "Сб"
            }
        }
    }
}


extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
}
