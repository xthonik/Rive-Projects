//
//  ContentView.swift
//  Krisha Splash Screen
//
//  Created by Darkhan Basshybayev on 25.04.2025.
//

import SwiftUI
import RiveRuntime
import CoreHaptics

struct ContentView: View {
  private let vm: RiveViewModel = {
    var model = RiveViewModel(fileName: "splash_animation", stateMachineName: "default")
    model.fit = .layout
    model.layoutScaleFactor = RiveViewModel.layoutScaleFactorAutomatic
    model.alignment = .center
    return model
  }()
  
  @State private var viewWidth: CGFloat = UIScreen.main.bounds.width
  @State private var viewHeight: CGFloat = UIScreen.main.bounds.height * 0.5
  @State private var hapticEngine: CHHapticEngine?

  var body: some View {
    ZStack {
      vm.view()
        .frame(width: viewWidth, height: viewHeight)
        .border(Color.secondary)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .ignoresSafeArea()
    .overlay(
      VStack(spacing: 12) {
        Button("Haptics1") {
          // Restart Rive animation
          vm.reset()
          vm.play()
          // Replay haptics
          prepareHaptics()
          playHaptics1()
        }
        .padding(.bottom, 8)

        Button("Haptics2") {
          vm.reset()
          vm.play()
          prepareHaptics()
          playHaptics2()
        }
        .padding(.bottom, 8)


        HStack {
          Text("Width: \(Int(viewWidth))")
            .frame(width: 80, alignment: .leading)
          Slider(value: $viewWidth, in: 100...UIScreen.main.bounds.width * 1.5)
        }
        HStack {
          Text("Height: \(Int(viewHeight))")
            .frame(width: 80, alignment: .leading)
          Slider(value: $viewHeight, in: 100...UIScreen.main.bounds.height * 1.5)
        }
      }
      .padding()
      .background(Color(.systemBackground).opacity(0.8))
      .cornerRadius(8)
      .padding(.bottom, 20),
      alignment: .bottom
    )
    .onAppear {
      prepareHaptics()
      vm.riveModel?.enableAutoBind { instance in
        // Auto-bound view model instance available here
        playHaptics1()
      }
    }
  }

  private func prepareHaptics() {
    guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
    do {
      hapticEngine = try CHHapticEngine()
      try hapticEngine?.start()
    } catch {
      print("Haptics error: \(error)")
    }
  }

  private func playHaptics1() {
    guard let engine = hapticEngine,
          let url = Bundle.main.url(forResource: "haptics1", withExtension: "ahap")
    else { return }
    do {
      let pattern = try CHHapticPattern(contentsOf: url)
      let player = try engine.makePlayer(with: pattern)
      try player.start(atTime: CHHapticTimeImmediate)
    } catch {
      print("Failed to play haptics1: \(error)")
    }
  }

  private func playHaptics2() {
    guard let engine = hapticEngine,
          let url = Bundle.main.url(forResource: "haptics2", withExtension: "ahap")
    else { return }
    do {
      let pattern = try CHHapticPattern(contentsOf: url)
      let player = try engine.makePlayer(with: pattern)
      try player.start(atTime: CHHapticTimeImmediate)
    } catch {
      print("Failed to play haptics2: \(error)")
    }
  }

}

#Preview {
  ContentView()
}
