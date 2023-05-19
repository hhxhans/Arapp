//
//  OnlineTaskView.swift
//  Ar trial
//
//  Created by niudan on 2023/5/12.
//

import SwiftUI
import RealityKit
import Combine

struct OnlineTaskView: View {
    @EnvironmentObject var Usermodel:Appusermodel
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @StateObject var OnlineTaskmodel:OnlineTaskModel=OnlineTaskModel()
    @State var currentDay:Date = .init()
    var body: some View {
        GeometryReader{geometry in
            ZStack{
                ScrollView(.vertical, showsIndicators: false){
                    ScrollViewReader { proxy in
                        LazyVStack{
                            HStack{
                                Text(Date().DatetoString("YYYY MMM dd hh:mm:ss")).font(.title)
                                Spacer()
                            }.padding(.leading,5)
                            ForEach(OnlineTaskmodel.Tasks.indices,id:\.self){index in
                                HStack{
                                    VStack(alignment: .leading,spacing: .zero){
                                        //Text(OnlineTaskmodel.Tasks[index].id)
                                        HStack{
                                            Text(OnlineTaskmodel.Tasks[index].title)
                                            Image(systemName: "arrow.right.circle")
                                        }.font(.title)
                                            .padding(.horizontal)
                                            .foregroundColor(Color.accentColor)
                                        Divider()
                                        HStack{
                                            Text("Remaining: ").font(.title2)
                                            if OnlineTaskmodel.Remaining[index].4{
                                                Text("\(OnlineTaskmodel.Remaining[index].0)d:\(OnlineTaskmodel.Remaining[index].1)h:\(OnlineTaskmodel.Remaining[index].2)m").font(.title2)
                                            }else{
                                                Text("0d:0h:0m Ended").font(.title2)
                                                    .foregroundColor(OnlineTaskmodel.Remaining[index].4 ? Color.primary : Color.red)
                                            }
                                        }
                                            .padding(.horizontal)
                                    }
                                    .frame(width:geometry.size.width*0.5)
                                        .background(RoundedRectangle(cornerRadius: 5)
                                                        .stroke(Color.secondary)
                                        )
                                        .padding(.horizontal,5)
                                        .onTapGesture {
                                            OnlineTaskmodel.TaskDetaildisplay[index].toggle()
                                        }
                                        .blurredSheet(Usermodel.blurredShapestyle, show: $OnlineTaskmodel.TaskDetaildisplay[index]) {
                                            
                                        } content: {
                                            TaskDetailView(OnlineTaskmodel: OnlineTaskmodel, Taskindex: index)
                                        }
                                    Spacer()
                                }

                            }
                        }
                    }
                }
            }.frame(maxWidth: .infinity,maxHeight: .infinity)
                .overlay(alignment: .bottomTrailing){
                    if Usermodel.user.authority>0{
                        Button{
                            OnlineTaskmodel.TaskAddingdisplay.toggle()
                        }label:{
                            HStack{
                                Image(systemName:"plus").foregroundColor(.BackgroundprimaryColor)
                                    .font(.title2)
                                Text("Add task").foregroundColor(.BackgroundprimaryColor)
                                    .font(.title2)
                            }
                        }.padding()
                            .background(Capsule().fill(Color.accentColor))

                    }
                }
                .blurredSheet(.init(.ultraThinMaterial), show: $OnlineTaskmodel.TaskAddingdisplay) {
                    
                } content: {
                    OnlineTaskAddingView(OnlineTaskmodel: OnlineTaskmodel)
                }
                //.background(RoundedRectangle(cornerRadius: 5).stroke(Color.primary))
        }
        .navigationBarItems(trailing:
                                Button{
            OnlineTaskmodel.Gettasks(Url: Usermodel.user.simulationurl)
        }label:{
            Image(systemName: "arrow.clockwise").font(.title2)
        }
                            )

        .onAppear{
            OnlineTaskmodel.Gettasks(Url: Usermodel.user.simulationurl)
            OnlineTaskmodel.UpdateTasksremaining()
        }
        .onReceive(timer) { date in
            if !OnlineTaskmodel.TaskAddingdisplay{
                OnlineTaskmodel.UpdateTasksremaining()
            }
        }

            

        
        //.ignoresSafeArea(.all, edges: .top)
    }
    
    
    
}
    
//    @ViewBuilder
//    func ScrollViewHeader()->some View{
//        VStack{
//            HStack{
//                Text(Date().DatetoString("MMM YYYY")).padding(.leading,5)
//                Spacer()
//            }
//            HStack(spacing: .zero){
//                ForEach(Calendar.current.currentWeek) {day in
//                    Spacer()
//                    VStack(spacing:5){
//                        Text(day.string.prefix(3)).font(.system(size: 12))
//                        Text(day.date.DatetoString("dd")).font(.system(size: 16))
//                    }
//                    .foregroundColor(Calendar.current.isDate(day.date, inSameDayAs: currentDay) ? Color.accentColor : .secondary)
//                    .contentShape(Rectangle())
//                    Spacer()
//                }
//            }
//        }
//    }
