    //
    //  DynamicFilteredView.swift
    //  Task Manager
    //
    //  Created by Phạm Minh Khuê on 19/11/2022.
    //

import SwiftUI
import CoreData

struct DynamicFilteredView<Content:View, T>: View where T: NSManagedObject{

        // MARK: - CoreData Request
    @FetchRequest var request: FetchedResults<T>
    let content: (T) -> Content
        // MARK: - Build custom ForEach which will give CoreData object to build View
    init(currentTab: String, @ViewBuilder content: @escaping (T) -> Content) {
            // MARK: - Predicate to Filter current date task
        let calendar = Calendar.current
        var predicate: NSPredicate!
        if currentTab == "Today" {
            let today = calendar.startOfDay(for: Date())
            let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)

                //filter key
            let filterKey = "deadline"

                //Fetch task between today and tomorrowwhich is 24 hrs
                //0 - false, 1 - true
            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@ AND isCompleted == %i", argumentArray: [today, tomorrow as Any, 0])

        } else if currentTab == "Upcoming"{
            let today = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: Date())!)
            let tomorrow = Date.distantFuture
                //filter key
            let filterKey = "deadline"
            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@ AND isCompleted == %i", argumentArray: [today, tomorrow, 0])

        } else if currentTab == "Failed"{
            let today = calendar.startOfDay(for: Date())
            let past = Date.distantPast
                //filter key
            let filterKey = "deadline"
            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@ AND isCompleted == %i", argumentArray: [past, today, 0])

        }

            //initializing request with NSPredicate
        _request = FetchRequest(entity: T.entity(), sortDescriptors: [.init(keyPath: \Task.deadline, ascending: false)], predicate: predicate)
        self.content = content
    }

    var body: some View {
        Group {
            if request.isEmpty {
                Text("No Task Found")
                    .font(.system(size: 16))
                    .fontWeight(.light)
                    .offset(y: 100)
            } else {
                ForEach(request, id: \.objectID) {object in
                    self.content(object)
                }
            }
        }
    }
}

