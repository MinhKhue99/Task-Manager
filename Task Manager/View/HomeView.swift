//
//  HomeView.swift
//  Task Manager
//
//  Created by Phạm Minh Khuê on 19/11/2022.
//

import SwiftUI

struct HomeView: View {
    // MARK: - property
    @StateObject private var taskViewModel: TaskViewModel = .init()
    @Namespace var animation
    @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Task.deadline, ascending: false)], predicate: nil, animation: .easeOut)
    var tasks: FetchedResults<Task>
    @Environment(\.self) var enviroment



    // MARK: - body
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Welcome Back")
                        .font(.callout)
                    Text("Here is update Today")
                        .font(.title2.bold())
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical)

                customSegmentedBar()
                    .padding(.top, 5)

                taskView()
            }
            .padding()
        }
        .overlay(alignment: .bottom) {
            Button(action: {
                taskViewModel.openEditTask.toggle()
            }, label: {
                Label {
                    Text("Add Task")
                        .font(.callout)
                        .fontWeight(.semibold)
                } icon: {
                    Image(systemName: "plus.app.fill")
                }
                .foregroundColor(.white)
                .padding(.vertical, 12)
                .padding(.horizontal)
                .background(.black, in: Capsule())
            })
            .padding(.top, 10)
            .frame(maxWidth: .infinity)
            .background {
                LinearGradient(colors: [
                    .white.opacity(0.05),
                    .white.opacity(0.4),
                    .white.opacity(0.7)
                ],
                               startPoint: .top,
                               endPoint: .bottom)
                .ignoresSafeArea()
            }
        }
        .fullScreenCover(isPresented: $taskViewModel.openEditTask) {
            taskViewModel.resetTaskData()
        } content: {
            AddNewTaskView()
                .environmentObject(taskViewModel)
        }
    }

    // MARK: - custom Segmented Bar
    @ViewBuilder
    func customSegmentedBar() -> some View {
        let tabs = ["Today" , "Upcoming", "Task Done", "Failed"]
        HStack(spacing: 10) {
            ForEach(tabs, id: \.self) {tab in
                Text(tab)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .scaleEffect(0.9)
                    .foregroundColor(taskViewModel.currentTab == tab ? .white : .black)
                    .padding(.vertical, 6 )
                    .frame(maxWidth: .infinity)
                    .background {
                        if taskViewModel.currentTab == tab {
                            Capsule()
                                .fill(.black)
                                .matchedGeometryEffect(id: "TAB", in: animation)
                        }
                    }
                    .contentShape(Capsule())
                    .onTapGesture {
                        withAnimation {
                            taskViewModel.currentTab = tab
                        }
                    }
            }
        }
    }

    // MARK: - TaskView
    @ViewBuilder
    func taskView() -> some View {
        LazyVStack(spacing: 20) {
            DynamicFilteredView(currentTab: taskViewModel.currentTab) {(task: Task) in
                taskRowView(task: task)
            }
        }
        .padding(.top, 20)
    }
    // MARK: - TaskRowView
    @ViewBuilder
    func taskRowView(task: Task) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(task.type ?? "")
                    .font(.callout)
                    .padding(.vertical, 5)
                    .padding(.horizontal)
                    .background {
                        Capsule()
                            .fill(.white.opacity(0.5))
                    }
                Spacer()
                //EditButton ony for non completed task
                if !task.isCompleted && taskViewModel.currentTab != "Failed" {
                    Button(action: {
                        taskViewModel.exitTask = task
                        taskViewModel.openEditTask = true
                        taskViewModel.setupTask()
                    }, label: {
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(.black)
                    })
                }
            }

            Text(task.title ?? "")
                .font(.callout.bold())
                .foregroundColor(.black)
                .padding(.vertical, 10)

            HStack(alignment: .bottom, spacing: 0) {
                VStack(alignment: .leading, spacing: 10) {
                    Label {
                        Text((task.deadline ?? Date()).formatted(date: .long, time: .omitted))
                    } icon: {
                        Image(systemName: "calendar")
                    }
                    .font(.caption)
                    Label {
                        Text((task.deadline ?? Date()).formatted(date: .omitted, time: .shortened))
                    } icon: {
                        Image(systemName: "clock")
                    }
                    .font(.caption)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                if !task.isCompleted && taskViewModel.currentTab != "Failed"{
                    Button(action: {
                        //update core data
                        task.isCompleted.toggle()
                        try? enviroment.managedObjectContext.save()
                    }, label: {
                        Circle()
                            .strokeBorder(.black, lineWidth: 1.5)
                            .frame(width: 25, height: 25)
                            .contentShape(Circle())
                    })
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(task.color ?? "Yellow"))
        }

    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
