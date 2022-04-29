//
//  DaysModel.swift
//  PageViewControllerTest
//
//  Created by Егор Шкарин on 06.04.2022.
//

import Foundation


class DaysModel: Hashable {
    var id = UUID()
    let daysAndDate: (String, String)

    
    init(daysAndDate: (String, String)) {
        self.daysAndDate = daysAndDate
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    // 3
    static func == (lhs: DaysModel, rhs: DaysModel) -> Bool {
        lhs.id == rhs.id
    }
    
}
