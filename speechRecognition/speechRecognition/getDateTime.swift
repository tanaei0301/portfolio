//
//  getDateTime.swift
//  speechRecognition
//
//  Created by Taichi Tanaka on 2022/12/16.
//

import Foundation

class GetDateTime{
    let dt = Date()
    
    func getDateData()-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMMdd", options: 0, locale: Locale(identifier: "ja_JP"))
        let date = dateFormatter.string(from: dt)
        return date
    }
    
    func getTimeData()-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "HHmm", options: 0, locale: Locale(identifier: "ja_JP"))
        let date = dateFormatter.string(from: dt)
        return date
    }

    func day_of_week(setting : String?) -> String{
        let dateFormatter = DateFormatter()
        var jdayWeek : String
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "E", options: 0, locale: Locale(identifier: "ja_JP"))
        let dayWeek = dateFormatter.string(from: dt)
        if setting == "ja_JP" {
            switch dayWeek{
                case "Sun" : jdayWeek = "日"
                case "Mon" : jdayWeek = "月"
                case "Tue" : jdayWeek = "火"
                case "Wed" : jdayWeek = "水"
                case "Thu" : jdayWeek = "木"
                case "Fri" : jdayWeek = "金"
                case "Sat" : jdayWeek = "土"
                
                default : jdayWeek = "エラー"
            }
            return jdayWeek
        }
        else{
            return dayWeek
        }
    }
    func formateJPtime(UDT : Any?) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMMddHHmm", options: 0, locale: Locale(identifier: "ja_JP"))
        if let a = UDT as? Date {
            return dateFormatter.string(from: a)
        }
        return "error"
    }
}
