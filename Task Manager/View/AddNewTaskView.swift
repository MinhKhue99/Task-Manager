//
//  AddNewTaskView.swift
//  Task Manager
//
//  Created by Phạm Minh Khuê on 19/11/2022.
//

import SwiftUI
import CoreData
struct AddNewTaskView: View {
    // MARK: - property
    @EnvironmentObject private var taskViewModel: TaskViewModel
    //All EnviromentValue in one variable
    @Environment(\.self) var enviroment
    @Namespace var animation
    // MARK: - body
    var body: some View {
        VStack(spacing: 12) {
            Text("Edit Task")
                .font(.title3.bold())
                .frame(maxWidth: .infinity)
                .overlay(alignment: .leading) {
                    Button(action: {
                        enviroment.dismiss()
                    }, label: {
                        Image(systemName: "arrow.left")
                            .font(.title3)
                            .foregroundColor(.black)
                    })
                }
                .overlay(alignment: .trailing) {
                    Button(action: {
                        if let exittask = taskViewModel.exitTask {
                            enviroment.managedObjectContext.delete(exittask)
                            try? enviroment.managedObjectContext.save()
                            enviroment.dismiss()
                        }
                    }, label: {
                        Image(systemName: "trash")
                            .font(.title3)
                            .foregroundColor(.black)
                    })
                }
                .opacity(taskViewModel.exitTask == nil ? 0 : 1)
            // MARK: - Task Color
            VStack(alignment: .leading, spacing: 12) {
                Text("Task Color")
                    .font(.caption)
                    .foregroundColor(.gray)
                //Sample Card Color
                let colors: [String] = ["Red", "Blue", "Yellow", "Green", "Orange", "Purple"]
                HStack(spacing: 15) {
                    ForEach(colors, id: \.self) {color in
                        Circle()
                            .fill(Color(color))
                            .frame(width: 25, height: 25)
                            .background {
                                if taskViewModel.taskColor == color {
                                    Circle()
                                        .strokeBorder(.gray)
                                        .padding(-3)
                                }
                            }
                            .contentShape(Circle())
                            .onTapGesture {
                                taskViewModel.taskColor = color
                            }
                    }
                }
                .padding(.top, 10)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 30)

            Divider()
                .padding(.vertical, 10)
            // MARK: - Task Deadline
            VStack(alignment: .leading, spacing: 12) {
                Text("Task Deadline")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(taskViewModel.taskDeadline.formatted(date: .abbreviated, time: .omitted)
                     + ", " +
                     taskViewModel.taskDeadline.formatted(date: .omitted, time: .shortened)
                )
                .font(.callout)
                .fontWeight(.semibold)
                .padding(.top, 10)

            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .overlay(alignment: .bottomTrailing) {
                Button(action: {
                    taskViewModel.showDatePicker.toggle()
                }, label: {
                    Image(systemName: "calendar")
                        .foregroundColor(.black)
                })
            }

            Divider()
            // MARK: - Task Title
            VStack(alignment: .leading, spacing: 12) {
                Text("Task Title")
                    .font(.caption)
                    .foregroundColor(.gray)
                TextField("", text: $taskViewModel.taskTitle)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 10)

            }
            .padding(.top, 10)

            Divider()

            // MARK: - Task Type
            let taskTypes: [String] = ["Basic", "Urgent", "Important"]
            VStack(alignment: .leading, spacing: 12) {
                Text("Task Type")
                    .font(.caption)
                    .foregroundColor(.gray)
                HStack(spacing: 12) {
                    ForEach(taskTypes, id: \.self) {taskType in
                        Text(taskType)
                            .font(.callout)
                            .padding(.vertical, 10)
                            .foregroundColor(taskViewModel.taskType == taskType ? .white : .black)
                            .frame(maxWidth: .infinity)
                            .background {
                                if taskViewModel.taskType == taskType {
                                    Capsule()
                                        .fill(.black)
                                        .matchedGeometryEffect(id: "TYPE", in: animation)
                                } else {
                                    Capsule()
                                        .strokeBorder(.black)
                                }
                            }
                            .contentShape(Capsule())
                            .onTapGesture {
                                withAnimation {taskViewModel.taskType = taskType}
                            }
                    }
                }
                .padding(.top, 10)
            }
            .padding(.vertical, 10)

            Divider()

            // MARK: - Save Button
            Button(action: {
                if taskViewModel.addTask(context: enviroment.managedObjectContext) {
                    enviroment.dismiss()
                }
            }, label: {
                Text("Save Task")
                    .font(.callout)
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background {
                        Capsule()
                            .fill(.black)
                    }
            })
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, 10)
            .disabled(taskViewModel.taskTitle == "")
            .opacity(taskViewModel.taskTitle == "" ? 0.6 : 1)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding()
        .overlay {
            ZStack {
                if taskViewModel.showDatePicker {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .ignoresSafeArea()
                        .onTapGesture {
                            taskViewModel.showDatePicker = false
                        }
                    DatePicker.init("", selection: $taskViewModel.taskDeadline, in: Date.now...Date.distantFuture)
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                        .padding()
                        .background(.white, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .padding()
                }
            }
            .animation(Animation.easeOut, value: taskViewModel.showDatePicker)
        }
    }
}

struct AddNewTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewTaskView()
            .environmentObject(TaskViewModel())
    }
}
