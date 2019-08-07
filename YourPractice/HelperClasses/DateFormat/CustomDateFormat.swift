//
//  DateFormat.swift
//  YourPractice
//
//  Created by Devangi Shah on 04/03/19.
//  Copyright © 2019 YourPractice. All rights reserved..
//

import UIKit

let ken_US_POSIX = "en_US_POSIX"

let kMM_yy = "MM/yy"

let khh_mm_ss = "hh:mm:ss"
let kHH_mm_ss = "HH:mm:ss"
let kd_MMM_yyyy = "d-MMM-yyyy"
let kdd_MM_yyyy = "dd-MM-yyyy"
let kMMM_dd_yyyy_hh_mm_ss_a = "MMM dd, yyyy hh:mm a"
let kMM_dd_yyyy_HH_mm_ss = "MM/dd/yyyy HH:mm:ss"
let kMM_dd_yyyy_hh_mm_ss = "MM/dd/yyyy hh:mm:ss"
let kMM_dd_yyyy = "MM-dd-yyyy"
let kyyyy_MM_dd = "yyyy-MM-dd"
let kyyyy_MM_dd_HH_mm_ss = "yyyy-MM-dd HH:mm:ss"
let kyyyy_MM_dd_hh_mm_ss = "yyyy-MM-dd hh:mm:ss"
let kyyyy_MM_dd_hh_mm_ss_a = "yyyy-MM-dd hh:mm:ss a"
let kyyyy_MM_dd_T_HH_mm_ss = "yyyy-MM-dd'T'HH:mm:ss"
let kyyyy_MM_dd_T_HH_mm_ss_sss = "yyyy-MM-dd'T'HH:mm:ss.SSS"

let kGMT = "GMT"
let kUTC = "UTC"

/**
 Purpose of this date format class when we can get date in different format from the current format.
 get date in different different string or date format.
 */

class CustomDateFormat: NSObject {

    //MARK: set Current Date Formatter
    /**
     - Parameter strFormat: It is a String type value.
     - Returns: It returns DateFormatter value.
     */
    class func currentDateFormat(strFormat : String) -> DateFormatter{
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = strFormat
        return dateFormat
    }
    
    //MARK: set Current Time Zone
    /**
     - Parameter useUTC: It is a Bool type value.
     - Returns: It returns TimeZone value.
     */
    class func currentTimeZone(useUTC : Bool) -> TimeZone{
        if useUTC{
            var timeZone = TimeZone.current
            timeZone = TimeZone(abbreviation: kUTC)!
            return timeZone
        }else{
          //  let gmt = NSTimeZone(abbreviation: "GMT")
            let timeZone : TimeZone = TimeZone.current //gmt! as TimeZone
            return timeZone
        }
    }
    
    //MARK: get Current Date
    /**
      - Parameter dateFormatter: It is a DateFormatter type value.
      - Parameter useUTC: It is a Bool type value.
      - Returns: It returns String value.
     */
    class func getCurrentDate(dateFormatter : String,useUTC : Bool) -> String{
        let today = Date(timeIntervalSinceNow: 0)
        let dateFormat = currentDateFormat(strFormat: dateFormatter)
        dateFormat.timeZone = currentTimeZone(useUTC: useUTC)
        let dateString = dateFormat.string(from: today)
        return dateString
    }
    
    //MARK: get Current Time
    /**
     - Parameter dateFormatter: It is a DateFormatter type value.
     - Returns: It returns String value.
     */
    class func getCurrentTime(timeFormatter : String) -> String{
        let today = Date(timeIntervalSinceNow: 0)
        let dateformat =  currentDateFormat(strFormat: timeFormatter)
        let dateString = dateformat.string(from: today)
        return dateString
    }
    
    //MARK: get Past Time
    /**
     - Parameter numberOfDays: It is a Int type value.
     - Parameter dateFormatter: It is a DateFormatter type value.
     - Parameter useUTC: It is a Bool type value.
     - Returns: It returns String value.
     */
    class func getPastDate(numberOfDays : Int,dateFormatter : String,useUTC : Bool) -> String{
        let now = Date()
        let daysToDeduct: Int = -numberOfDays
        let newDate = now.addingTimeInterval(TimeInterval(60 * 60 * 24 * daysToDeduct))
        let dateFormat =  currentDateFormat(strFormat: dateFormatter)
        
        if useUTC{
            dateFormat.timeZone = currentTimeZone(useUTC: useUTC)
        }
        let dateString = dateFormat.string(from: newDate)
        return dateString
    }
    
    //MARK: get Future Time
    /**
     - Parameter numberOfDays: It is a Int type value.
     - Parameter dateFormatter: It is a DateFormatter type value.
     - Parameter useUTC: It is a Bool type value.
     - Returns: It returns String value.
     */
    class func getFutureDate(numberOfDays : Int,dateFormatter : String,useUTC : Bool) -> String{
        let now = Date()
        let daysToAdd: Int = numberOfDays
        let newDate = now.addingTimeInterval(TimeInterval(60 * 60 * 24 * daysToAdd))
        let dateFormat = currentDateFormat(strFormat: dateFormatter)
        if useUTC{
            dateFormat.timeZone = currentTimeZone(useUTC: useUTC)
        }
        let dateString = dateFormat.string(from: newDate)
        return dateString
    }
    
    //MARK: change to 24 or 12 hours Date Format
    /**
     - Parameter date: It is a String type value.
     - Parameter inputDateFormatter: It is a DateFormatter type value.
     - Parameter outputDateFormatter: It is a DateFormatter type value.
     - Parameter useUTC: It is a Bool type value.
     - Returns: It returns String value.
     */
    class func changetoHourDateFormat(_ date: String,inputDateFormatter : String,outputDateFormatter : String,useUTC : Bool) -> String {
        do {
            var myStr: String? = ""
            let formatter = currentDateFormat(strFormat: inputDateFormatter)
            formatter.timeZone = currentTimeZone(useUTC: false)
            if let datefrmStr: Date = formatter.date(from: date){
                let dateFormatterNew = currentDateFormat(strFormat: outputDateFormatter)
                dateFormatterNew.timeZone = currentTimeZone(useUTC: useUTC)
                myStr = dateFormatterNew.string(from: datefrmStr)
            }
            return myStr!
        }
    }
    
    
    //MARK: merge Date and Time and change its format
    /**
     - Parameter strdate: It is a String type value.
     - Parameter strTime: It is a String type value.
     - Parameter inputDateFormatter: It is a DateFormatter type value.
     - Parameter outputDateFormatter: It is a DateFormatter type value.
     - Parameter useUTC: It is a Bool type value.
     - Returns: It returns String value.
     */
    class func mergeAndChangetoDateTimeFormat(_ strdate: String, withTime strTime: String, inputDateFormatter : String,outputDateFormatter : String,useUTC : Bool) -> String {
        do {
            var stringFromDate: String = ""
            
            let string = strdate + (" ")
            let newString = string + strTime
           
            let dateFormatter = currentDateFormat(strFormat: inputDateFormatter)
            dateFormatter.timeZone = currentTimeZone(useUTC: false)
            
            if let myDate: Date = dateFormatter.date(from: newString) {
                let formatter = currentDateFormat(strFormat: outputDateFormatter)
                formatter.timeZone = currentTimeZone(useUTC: useUTC)
                stringFromDate = formatter.string(from: myDate)
            }
            return stringFromDate
        }
    }
    
    //MARK: merge Date and Time and get in Date Value
    /**
     - Parameter strdate: It is a String type value.
     - Parameter strTime: It is a String type value.
     - Parameter inoutDateFormatter: It is a DateFormatter type value.
     - Parameter useUTC: It is a Bool type value.
     - Returns: It returns Date value.
     */
    class func mergeDateAndTime(_ strdate: String, withTime strTime: String, inoutDateFormatter: String,useUTC : Bool) -> Date {
        do {
            var getDate = Date()
            let string = strdate + (" ")
            let newString = string + strTime
            let dateFormatter = currentDateFormat(strFormat: inoutDateFormatter)
            dateFormatter.timeZone = currentTimeZone(useUTC: useUTC)
            if let myDate: Date = dateFormatter.date(from: newString){
               getDate = myDate
            }
            return getDate
        }
    }
    
    //MARK: Convert Date To String
    /**
     - Parameter date: It is a Date type value.
     - Parameter inoutDateFormatter: It is a DateFormatter type value.
     - Parameter useUTC: It is a Bool type value.
     - Returns: It returns String value.
     */
    class func convertDateToString(_ date : Date,inoutDateFormatter : String,useUTC : Bool) -> String{
        do {
            var myStr: String = ""
            let dateFormatterNew = currentDateFormat(strFormat: inoutDateFormatter)
            dateFormatterNew.timeZone = currentTimeZone(useUTC: useUTC)
            myStr = dateFormatterNew.string(from: date)
            return myStr
        }
    }
    
    //MARK: Convert String To Date
    /**
     - Parameter strDate: It is a String type value.
     - Parameter inoutDateFormatter: It is a DateFormatter type value.
     - Parameter useUTC: It is a Bool type value.
     - Returns: It returns Date value.
     */
    class func convertStringToDate(_ strDate : String,inoutDateFormatter : String,useUTC : Bool) -> Date
    {
        do {
            var getDate = Date()
            let newString = strDate
            let dateFormatter = currentDateFormat(strFormat: inoutDateFormatter)
            dateFormatter.timeZone = currentTimeZone(useUTC: useUTC)
            if let myDate: Date = dateFormatter.date(from: newString){
                getDate = myDate
            }
            return getDate
        }
    }
    
    //MARK: Convert Time Zone UTC To GMT
    /**
     - Parameter strDate: It is a Date type value.
     - Parameter inDateFormatter: It is a DateFormatter type value.
     - Parameter outDateFormatter: It is a DateFormatter type value.
     - Returns: It returns String value.
     */
    
    class func ConvertStrDateUTCtoGMT(strDate : String,inDateFormatter : String,outDateFormatter : String) -> String{
        
        var myStr: String = ""
        let formatter = currentDateFormat(strFormat: inDateFormatter)
        formatter.timeZone = currentTimeZone(useUTC: true)
        
        if let datefrmStr: Date = formatter.date(from: strDate){
            let dateFormatterNew = currentDateFormat(strFormat: outDateFormatter)
            dateFormatterNew.timeZone = currentTimeZone(useUTC: false)
            myStr = dateFormatterNew.string(from: datefrmStr)
        }
        return myStr
    }
    
    //MARK: Convert Time Zone GMT To UTC
    /**
     - Parameter strDate: It is a Date type value.
     - Parameter inDateFormatter: It is a DateFormatter type value.
     - Parameter outDateFormatter: It is a DateFormatter type value.
     - Returns: It returns String value.
     */
    class func ConvertStrDateGMTtoUTC(strDate : String,inDateFormatter : String,outDateFormatter : String) -> String{
        var myStr: String = ""
        
        let formatter = currentDateFormat(strFormat: inDateFormatter)
        formatter.timeZone = currentTimeZone(useUTC: false)
        
        if let datefrmStr: Date = formatter.date(from: strDate){
            let dateFormatterNew = currentDateFormat(strFormat: inDateFormatter)
            dateFormatterNew.timeZone = currentTimeZone(useUTC: true)
            myStr = dateFormatterNew.string(from: datefrmStr)
        }
        return myStr
    }
    
    //MARK: Check Time is 24 hours format
    /**
     - Returns: It returns Bool value.
     */
    class func timeIs24HourFormat() -> Bool {
        do {
            let formatter = DateFormatter()
            formatter.dateStyle = .none
            formatter.timeStyle = .short
            let dateString = formatter.string(from: Date())
            let amRange: NSRange = (dateString as NSString).range(of: formatter.amSymbol)
            let pmRange: NSRange = (dateString as NSString).range(of: formatter.pmSymbol)
            let is24Hour: Bool = amRange.location == NSNotFound && pmRange.location == NSNotFound
            return is24Hour
        }
    }
    
    //MARK: get seconds for current Date
    /**
     - Parameter date: It is a Date type value.
     - Parameter strDateFormat: It is a DateFormatter type value.
      - Parameter isDateOnly: It is a Bool type value.
     - Returns: It returns Bool value.
     */
    class func getCurrentSeconds(strDate : String,strDateFormat : String,isDateOnly : Bool) -> Double
    {
        let dateFormatter : DateFormatter = currentDateFormat(strFormat: strDateFormat)

        if isDateOnly{
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        }
        dateFormatter.locale = Locale(identifier: ken_US_POSIX)

        let date = dateFormatter.date(from: strDate)
        var differenceSeconds : Double = 0.0
        differenceSeconds = (date?.timeIntervalSince1970)!
        return differenceSeconds.rounded()
    }
    
    //MARK: get string for fix format of Date
    /**
     - Parameter date: It is a Date type value.
     - Returns: It returns String value.
     */
    
    class func getStringFromDate(date : Date) -> String{
        // Day
        let calendar = Calendar.current
        let anchorComponents = calendar.dateComponents([.day, .month, .year], from: date)
        
        // Formate
        let dateFormateMonth = DateFormatter()
        dateFormateMonth.dateFormat = "MMM"
        let month = dateFormateMonth.string(from: date)
        
        let dateFormateYear = DateFormatter()
        dateFormateYear.dateFormat = "yy"
        let year = dateFormateYear.string(from: date)
        
        var day  = "\(anchorComponents.day!)"
        switch (day) {
        case "1" , "21" , "31":
            day.append("st")
        case "2" , "22":
            day.append("nd")
        case "3" ,"23":
            day.append("rd")
        default:
            day.append("th")
        }
        return month + " " + day + " '\(year)"
    }
    
    //MARK: set date formater and convert date
    /**
     - Parameter date: It is a Date type value.
     - Parameter inoutDateFormatter: It is a DateFormatter type value.
     - Returns: It returns String value.
     */
    class func convertMonthYearFormater(_ strDate: String,inoutDateFormatter : String) -> String {
        var myStr: String = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inoutDateFormatter
        if let datefrmStr: Date = dateFormatter.date(from: strDate){
            dateFormatter.dateFormat = kMM_yy
            myStr =  dateFormatter.string(from: datefrmStr)
        }
        return myStr
        
    }
    
    //MARK: Date 1 is Less than Date 2
    
    /**
     - Parameter date1: It is a Date type value.
     - Parameter date1: It is a Date type value.
     - Returns: It returns Bool value.
     */
    
    class func isLessThan(date1: Date ,date2: Date) -> Bool {
        
        let success : Bool = date1 < date2 ? true : false
        return success
    }
    
    //MARK: Date 1 is Grater than Date 2
    
    /**
     - Parameter date1: It is a Date type value.
     - Parameter date1: It is a Date type value.
     - Returns: It returns Bool value.
     */
    
    class func isGraterThan(date1: Date ,date2: Date) -> Bool {
        let success : Bool = date1 > date2 ? true : false
        return success
    }
    
    //MARK: Date 1 is Equal To Date 2
    
    /**
     - Parameter date1: It is a Date type value.
     - Parameter date1: It is a Date type value.
     - Returns: It returns Bool value.
     */
    class func isEqual(date1: Date ,date2: Date) -> Bool {
        let success : Bool = date1 == date2 ? true : false
        return success
    }
    
    
    //MARK: get age from date
    
    /**
     - Parameter birthday: It is a Date type value.
     - Returns: It returns Int value.
     */
    
    class func getAge(_ birthday: Date) -> Int {
        
        let todayDate = Date()
        let gregorian = Calendar(identifier: .gregorian)
        let todayComps: DateComponents = gregorian.dateComponents([.day, .month, .year], from: todayDate)
        var birthDayComps: DateComponents? = nil
        
        birthDayComps = gregorian.dateComponents([.day, .month, .year], from: birthday)
       
        let year1: Int? = todayComps.year
        let year2: Int? = birthDayComps?.year
        var age: Int = (year1 ?? 0) - (year2 ?? 0)
        let month1: Int? = todayComps.month
        let month2: Int? = birthDayComps?.month
        if (month2 ?? 0) > (month1 ?? 0) {
            age -= 1
        } else if month1 == month2 {
            let day1: Int? = todayComps.day
            let day2: Int? = birthDayComps?.day
            if (day2 ?? 0) > (day1 ?? 0) {
                age -= 1
            }
        }
        return age
    }
}
