//
//  ContentView.swift
//  StackOverflowAnswer
//
//  Created by localadmin on 31.05.20.
//  Copyright © 2020 Mark Lucking. All rights reserved.
//

import SwiftUI
import Combine

var reporter = PassthroughSubject<String, Never>()

struct newView: UIViewRepresentable {
  @State var direction = ""

  typealias UIViewType = UIView
  var v = UIView()

  func updateUIView(_ uiView: UIView, context: Context) {
    v.backgroundColor = UIColor.yellow
  }
  
  func makeUIView(context: Context) -> UIView {
    let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(sender:)))
//    let panGesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePan(sender:)))
    let pinchGesture = UIPinchGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePinch(sender:)))
    let leftSwipe = UISwipeGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleSwipe(sender:)))
    leftSwipe.direction = .left
    let rightSwipe = UISwipeGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleSwipe(sender:)))
    rightSwipe.direction = .right
    
    
//    v.addGestureRecognizer(panGesture)
    v.addGestureRecognizer(pinchGesture)
    v.addGestureRecognizer(tapGesture)
    v.addGestureRecognizer(leftSwipe)
    v.addGestureRecognizer(rightSwipe)
    return v
    }
    
  func makeCoordinator() -> newView.Coordinator {
    Coordinator(v)
  }
  
  final class Coordinator: NSObject {
    private let view: UIView
  
    init(_ view: UIView) {
        self.view = view
        super.init()
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handlePinch(sender: UIPinchGestureRecognizer) {
      let scale = sender.scale
      reporter.send("scale \(scale)")
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
      let location = sender.location(in: view)
      reporter.send("tap \(location)")
    }
    
    @objc func handlePan(sender: UIPanGestureRecognizer) {

      let translation = sender.translation(in: view)
      let location = sender.location(in: view)
      
      sender.setTranslation(.zero, in: view)
      reporter.send("pan \(location) \(translation)")
    }
    
    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
      if sender.direction == .left {
        let location = sender.location(in: view)
        reporter.send("left \(location)")
      } else {
        if sender.direction == .right {
          let location = sender.location(in: view)
          reporter.send("right \(location)")
        }
      }
    }
  }
}

struct ContentView: View {
  @State var direction = ""
  
    var body: some View {
     return ZStack {
      newView()
      Rectangle()
        .stroke(lineWidth: 5)
        .frame(width: 256, height: 128, alignment: .center)
      Text(direction)
        .onReceive(reporter) { ( data ) in
          self.direction = data
        }
    }
}

//struct newViewController: UIViewControllerRepresentable {
//
//  var v = UIView()
//  var c = UIViewController()
//
//  func makeUIViewController(context: Context) -> UIViewController {
//    v.backgroundColor = UIColor.yellow
//    c.view.addSubview(v)
//    return c
//  }
//
//  func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
//    // do nothing
//  }
//
//  typealias UIViewControllerType = UIViewController
//
//
//
////  func makeUIView(context: Context) -> UIView {
////
////  }
////
////  func updateUIView(_ uiView: UIView, context: Context) {
////
////  }
//
////  typealias UIViewType = UIView
//
//  func makeCoordinator() -> Coordinator {
//    Coordinator(c)
//  }
//
//  class Coordinator: UIViewController, UIGestureRecognizerDelegate {
//    var viewVariable: UIView!
//    var lastLocation: CGPoint!
//
////    var parent: UIViewController
//
//    init(_ viewController: UIViewController) {
//      super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//      fatalError("init(coder:) has not been implemented")
//    }
//
//    @IBAction func handlePan(_ gesture: UIPanGestureRecognizer) {
//      let translation = gesture.translation(in: viewVariable)
//
//  // 2
//    guard let gestureView = gesture.view else {
//      return
//    }
//
//    gestureView.center = CGPoint(
//      x: gestureView.center.x + translation.x,
//      y: gestureView.center.y + translation.y
//    )
//
//    // 3
//    gesture.setTranslation(.zero, in: viewVariable)
//    }
//
////    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
////      // Promote the touched view
////      self.superview?.bringSubviewToFront(self)
////
////      // Remember original location
////      lastLocation = self.center
////    }
////
////    @objc func detectPan(_ recognizer:UIPanGestureRecognizer) {
////      let translation  = recognizer.translation(in: viewVariable)
////      self.center = CGPoint(x: lastLocation.x + translation.x, y: lastLocation.y + translation.y)
////    }
//  }
//}




struct fileforNow: View {
  var body: some View {
  ForEach(1..<6) {colY in
        HStack {
          ForEach(1..<6) {rowX in
              boxView(row: rowX, col: colY)
            }
          }
        }
      }
  }
  }
struct boxView: View {
  @State var row: Int
  @State var col: Int
  var body: some View {
    let dragGesture = DragGesture(minimumDistance: 0, coordinateSpace: CoordinateSpace.global)
     .onChanged { (value) in
        print("trigger ",self.row,self.col)
     }
    return Rectangle()
        .stroke(Color.black)
        .frame(width: 50, height: 50)
        .gesture(dragGesture)
  }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
