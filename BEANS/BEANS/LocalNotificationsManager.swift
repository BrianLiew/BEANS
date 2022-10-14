import Foundation
import UserNotifications

struct LocalNotificationsManager {
    
    static func removePendingLocalNotifications(id: String) -> Void {
        // UNUserNotificationCenter.current().get
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
    
    static func generateLocalNotification(name: String, reminderTime: Date) -> Void {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])  {
              success, error in
                  if success {
                      print("authorization granted")
                  } else if let error = error { }
          }
        
        let content = UNMutableNotificationContent()
        content.title = "BEANS"
        content.body = "Did you do \(name) yet?"
        content.sound = UNNotificationSound.default
        
        var calendar = Calendar.current
        
        calendar.timeZone = TimeZone.current
        var reminderDate = DateComponents()
        reminderDate.hour = calendar.component(.hour, from: reminderTime)
        reminderDate.minute = calendar.component(.minute, from: reminderTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: reminderDate, repeats: false)
        
        let id = UUID().uuidString
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
                
        UNUserNotificationCenter.current().add(request)
    }
    
}

extension Calendar {
    func numberOfDaysInBetween(from: Date, to: Date) -> Int {
        let fromDate = startOfDay(for: from)
        let endDate = startOfDay(for: to)
        let numDays = dateComponents([.day], from: fromDate, to: endDate)
        
        return numDays.day!
    }
}
