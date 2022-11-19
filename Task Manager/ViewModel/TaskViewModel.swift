//
//  TaskViewModel.swift
//  Task Manager
//
//  Created by Phạm Minh Khuê on 19/11/2022.
//

import Foundation
import CoreData

class TaskViewModel: ObservableObject {
    @Published var currentTab: String = "Today"

    @Published var openEditTask: Bool = false
    @Published var taskTitle: String = ""
    @Published var taskColor: String = "Red"
    @Published var taskDeadline: Date = Date()
    @Published var taskType: String = "Basic"
    @Published var showDatePicker: Bool = false
    @Published var exitTask: Task?

    func addTask(context: NSManagedObjectContext) -> Bool {
        var task: Task!
        if let exitTask = exitTask {
            task = exitTask
        } else{
            task  = Task(context: context)
        }
        task.title = taskTitle
        task.color = taskColor
        task.deadline = taskDeadline
        task.type = taskType
        task.isCompleted = false

        if let _ = try? context.save() {
            return true
        } else {
            return false
        }
    }

    func resetTaskData() {
        taskType = "Basic"
        taskColor = "Red"
        taskTitle = ""
        taskDeadline = Date()
    }

    func setupTask() {
        if let exitTask = exitTask {
            taskType = exitTask.type ?? ""
            taskColor = exitTask.color ?? "Red"
            taskDeadline = exitTask.deadline ?? Date()
            taskTitle = exitTask.title ?? ""
        }
    }
}
