//
//  ContentView.swift
//  Draw Together
//
//  Created by Thalia Woods on 08/01/2024.
//

import SwiftUI


struct TextBasic: View {
    var body: some View {
        Text("D r a w   T o g e t h e r".uppercased())
            .font(.system(.title, design: .monospaced))
            // .font(.custom("Times New Roman", size: 50, relativeTo: .title))
            .bold()
            // .fontWeight(.heavy)
            // .italic()
            // .underline()
            .foregroundColor(.black)
            .multilineTextAlignment(.center)
            // .lineLimit(10)
            // .frame(height: 400)
            // .minimumScaleFactor(/*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
            .padding()
        
        Text("Welcome to Draw Together! A collective creative art map for everyone to collaborate and create together..")
            .font(.system(.title, design: .monospaced))
            .multilineTextAlignment(.center)
            .padding()
    }
}

struct TextBasic_Preview: PreviewProvider {
    static var previews: some View {
        TextBasic()
    }
}


struct Line {
    var points = [CGPoint]()
    var color: Color = .red
    var lineWidth: Double = 1.0
}

struct ContentView: View {
    
    @State private var currentLine = Line()
    @State private var lines: [Line] = []
    @State private var selectedColor: Color = .red
    @State private var thickness : Double = 0.0
    @StateObject var viewRouter: ViewRouter
    @State var showPopUp = false
    
    var body: some View {
        
        GeometryReader { geometry in
            VStack {
                Spacer()
              
                switch viewRouter.currentPage {
                case .home:
                    Text("Home")
                case .liked:
                    Text("Liked")
                case .records:
                    Text("records")
                case .user:
                    Text("user")
                }
                Spacer()
                ZStack {
                    if showPopUp {
                        PlusMenu(widthAndHeight: geometry.size.width/7)
                            .offset(y: -geometry.size.height/6)
                    }
                    HStack {
                        TabBarIcon(viewRouter: viewRouter, assignedPage: .home, width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "homekit", tabName: "Home")
                        TabBarIcon(viewRouter: viewRouter, assignedPage: .liked, width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "heart", tabName: "Liked")
                        
                        ZStack {
                            Circle()
                                .foregroundColor(.white)
                                .frame(width: geometry.size.width/7, height: geometry.size.width/7)
                                .shadow(radius: 4)
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width/7-6, height: geometry.size.width/7-6)
                                .foregroundColor(Color("DarkRed"))
                                .rotationEffect(Angle(degrees: showPopUp ? 90 : 0))
                        }
                        .offset(y: -geometry.size.height/8/2)
                        .onTapGesture {
                            withAnimation {
                                showPopUp.toggle()
                            }
                        }
                        
                        
                        TabBarIcon(viewRouter: viewRouter, assignedPage: .records, width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "waveform", tabName: "Records")
                        TabBarIcon(viewRouter: viewRouter, assignedPage: .user, width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "person.crop.circle", tabName: "Account")
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height/8)
                .background(Color("TabBarBackground").shadow(radius: 2))
                }
            }
        }
            
            
            VStack {
                
                TextBasic()
                
                Group {
                    
                    Canvas { context, size in
                        
                        for line in lines {
                            var path = Path()
                            path.addLines(line.points)
                            context.stroke(path, with: .color(line.color), lineWidth: line.lineWidth)
                        }
                        
                    }
                    .frame(minWidth: 400, minHeight: 400)
                    .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onChanged({ value in
                            let newPoint = value.location
                            currentLine.points.append(newPoint)
                            self.lines.append(currentLine)
                        })
                            .onEnded ({value in
                                self.currentLine = Line(points: [], color: selectedColor)
                            })
                    )
                }
                
                HStack {
                    
                    Slider(value: $thickness, in: 1...20) {
                        Text("Thickness")
                    }.frame(maxWidth: 200)
                        .onChange(of: thickness) { newThickness in currentLine.lineWidth = newThickness
                        }
                    Divider()
                    ColorPickerView(selectedColor: $selectedColor)
                        .onChange(of: selectedColor) { newColor in
                            currentLine.color = newColor
                        }
                }
                
            }.padding()
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView(viewRouter: ViewRouter())
        }
    }

struct PlusMenu: View {
    
    let widthAndHeight: CGFloat
    
    var body: some View {
        HStack(spacing: 50) {
            ZStack {
                Circle()
                    .foregroundColor(Color("DarkRed"))
                    .frame(width: widthAndHeight, height: widthAndHeight)
                Image(systemName: "record.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(15)
                    .frame(width: widthAndHeight, height: widthAndHeight)
                    .foregroundColor(.white)
            }
            ZStack {
                Circle()
                    .foregroundColor(Color("DarkRed"))
                    .frame(width: widthAndHeight, height: widthAndHeight)
                Image(systemName: "folder")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(15)
                    .frame(width: widthAndHeight, height: widthAndHeight)
                    .foregroundColor(.white)
            }
        }
        .transition(.scale)
    }
}

struct TabBarIcon: View {
    
    @StateObject var viewRouter: ViewRouter
    let assignedPage: Page
    
    let width, height: CGFloat
    let systemIconName, tabName: String
    
    var body: some View {
        VStack {
            Image(systemName: systemIconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width, height: height)
                .padding(.top, 10)
            Text("Home")
                .font(.footnote)
            Spacer()
        }
        .padding(.horizontal, -4)
        .onTapGesture {
            viewRouter.currentPage = assignedPage
        }
        .foregroundColor(viewRouter.currentPage == assignedPage ? Color("TabBarHighlight") : .gray)
    }
}


