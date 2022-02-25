//
//  Copyright © 2022 INTERNEWS. All rights reserved.
//

import Foundation

enum DateFormat : String {
    case short = "dd MMM yyyy"
    case fileInfo = "dd-MM-yyyy HH:mm:ss Z"
    case fileName = "yyyy.MM.dd-HH.mm"
}

extension Date{
    
    func getFormattedDateString(format: String = DateFormat.short.rawValue , locale: Locale = Language.english.localeLanguage) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = locale
        return formatter.string(from: self) 
    }
    
}
