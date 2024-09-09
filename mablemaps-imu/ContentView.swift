// //
// //  ContentView.swift
// //  mablemaps-imu
// //
// //  Created by Badrinadh Aila on 8/20/24.
// //

// import SwiftUI
// import CoreMotion

// struct ContentView: View {
//     @StateObject private var motionManager = MotionManager()
    
//     var body: some View {
//         VStack {
//             Text("Accelerometer Data")
//             Text("X: \(motionManager.accelerometerData.x, specifier: "%.2f")")
//             Text("Y: \(motionManager.accelerometerData.y, specifier: "%.2f")")
//             Text("Z: \(motionManager.accelerometerData.z, specifier: "%.2f")")
            
//             Text("Gyroscope Data")
//             Text("X: \(motionManager.gyroscopeData.x, specifier: "%.2f")")
//             Text("Y: \(motionManager.gyroscopeData.y, specifier: "%.2f")")
//             Text("Z: \(motionManager.gyroscopeData.z, specifier: "%.2f")")
            
//             Text("Magnetometer Data")
//             Text("X: \(motionManager.magnetometerData.x, specifier: "%.2f")")
//             Text("Y: \(motionManager.magnetometerData.y, specifier: "%.2f")")
//             Text("Z: \(motionManager.magnetometerData.z, specifier: "%.2f")")

//             HStack {
//                 Button(action: {
//                         motionManager.startRecording()
//                     }) {
//                         Text("Start")
//                             .font(.title)
//                             .padding()
//                             .background(Color.blue)
//                             .foregroundColor(.white)
//                             .cornerRadius(10)
//                             .frame(width: 100, height: 50)
//                     }
//                 Button(action: {
//                     motionManager.stopRecording()
//                     motionManager.sendDataToServer()
//                     }) {
//                         Text("Stop")
//                             .font(.title)
//                             .padding()
//                             .background(Color.red)
//                             .foregroundColor(.white)
//                             .cornerRadius(10)
//                             .frame(width: 100, height: 50)
//                     }
//             }
//         }
//         .onAppear {
//             motionManager.startUpdates()
//         }
//         .onDisappear {
//             motionManager.stopUpdates()
//         }
//     }
// }

// class MotionManager: ObservableObject {
//     private var motionManager = CMMotionManager()
//     private var magnetometerManager = CMMotionManager()
    
//     @Published var accelerometerData = CMAcceleration()
//     @Published var gyroscopeData = CMRotationRate()
//     @Published var magnetometerData = CMMagneticField()

//     private var recordedAccelerometerData: [CMAcceleration] = []
//     private var recordedGyroscopeData: [CMRotationRate] = []
//     private var recordedMagnetometerData: [CMMagneticField] = []
    
//     func startUpdates() {
//         if motionManager.isAccelerometerAvailable {
//             motionManager.accelerometerUpdateInterval = 0.001
//             motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, error in
//                 if let data = data {
//                     self?.accelerometerData = data.acceleration
//                 }
//             }
//         }
        
//         if motionManager.isGyroAvailable {
//             motionManager.gyroUpdateInterval = 0.001
//             motionManager.startGyroUpdates(to: .main) { [weak self] data, error in
//                 if let data = data {
//                     self?.gyroscopeData = data.rotationRate
//                 }
//             }
//         }
        
//         if motionManager.isMagnetometerAvailable {
//             motionManager.magnetometerUpdateInterval = 0.1
//             motionManager.startMagnetometerUpdates(to: .main) { [weak self] data, error in
//                 if let data = data {
//                     self?.magnetometerData = data.magneticField
//                 }
//             }
//         }
//     }
    
//     func stopUpdates() {
//         motionManager.stopAccelerometerUpdates()
//         motionManager.stopGyroUpdates()
//         motionManager.stopMagnetometerUpdates()
//     }

//     func startRecording() {
//         recordedAccelerometerData.removeAll()
//         recordedGyroscopeData.removeAll()
//         recordedMagnetometerData.removeAll()
        
//         if motionManager.isAccelerometerAvailable {
//             motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, error in
//                 if let data = data {
//                     self?.recordedAccelerometerData.append(data.acceleration)
//                 }
//             }
//         }
        
//         if motionManager.isGyroAvailable {
//             motionManager.startGyroUpdates(to: .main) { [weak self] data, error in
//                 if let data = data {
//                     self?.recordedGyroscopeData.append(data.rotationRate)
//                 }
//             }
//         }
        
//         if magnetometerManager.isMagnetometerAvailable {
//             magnetometerManager.startMagnetometerUpdates(to: .main) { [weak self] data, error in
//                 if let data = data {
//                     self?.recordedMagnetometerData.append(data.magneticField)
//                 }
//             }
//         }
//     }

//     func stopRecording() {
//         stopUpdates()
//     }
    
//     func sendDataToServer() {
//         guard let url = URL(string: "http://128.180.100.88:5000/data") else { return }
        
//         var request = URLRequest(url: url)
//         request.httpMethod = "POST"
        
//         let dataToSend: [String: Any] = [
//             "accelerometerData": recordedAccelerometerData.map { ["x": $0.x, "y": $0.y, "z": $0.z] },
//             "gyroscopeData": recordedGyroscopeData.map { ["x": $0.x, "y": $0.y, "z": $0.z] },
//             "magnetometerData": recordedMagnetometerData.map { ["x": $0.x, "y": $0.y, "z": $0.z] }
//         ]

//         print(dataToSend)
        
//         do {
//             let jsonData = try JSONSerialization.data(withJSONObject: dataToSend, options: [])
//             request.httpBody = jsonData
//             request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
//             let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                 if let error = error {
//                     print("Error sending data: \(error)")
//                     return
//                 }
//                 print("Data sent successfully")
//             }
//             task.resume()
//         } catch {
//             print("Error serializing JSON: \(error)")
//         }
//     }








// }



import SwiftUI
import CoreMotion

struct ContentView: View {
    @StateObject private var motionManager = MotionManager()
    
    var body: some View {
        VStack {
            Text("Accelerometer Data")
            Text("X: \(motionManager.accelerometerData.x, specifier: "%.2f")")
            Text("Y: \(motionManager.accelerometerData.y, specifier: "%.2f")")
            Text("Z: \(motionManager.accelerometerData.z, specifier: "%.2f")")
            
            Text("Gyroscope Data")
            Text("X: \(motionManager.gyroscopeData.x, specifier: "%.2f")")
            Text("Y: \(motionManager.gyroscopeData.y, specifier: "%.2f")")
            Text("Z: \(motionManager.gyroscopeData.z, specifier: "%.2f")")
            
            Text("Magnetometer Data")
            Text("X: \(motionManager.magnetometerData.x, specifier: "%.2f")")
            Text("Y: \(motionManager.magnetometerData.y, specifier: "%.2f")")
            Text("Z: \(motionManager.magnetometerData.z, specifier: "%.2f")")

            HStack {
                Button(action: {
                    // motionManager.startUpdates()
                    motionManager.startRecording()
                }) {
                    Text("Start")
                        .font(.title)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .frame(width: 100, height: 50)
                }
                Button(action: {
                    motionManager.stopRecording()
                }) {
                    Text("Stop")
                        .font(.title)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .frame(width: 100, height: 50)
                }
            }

            Text("Magnitudes from Server")
            List(motionManager.magnitudes, id: \.self) { magnitude in
                Text("\(magnitude)")
            }

            Text("Distance in Meters: \(motionManager.cumulativeSum * 100, specifier: "%.2f")")


        }
        .onAppear {
            // motionManager.startUpdates()
        }
        .onDisappear {
            motionManager.stopUpdates()
        }
    }
}

class MotionManager: ObservableObject {
    private var motionManager = CMMotionManager()
    private var magnetometerManager = CMMotionManager()
    
    @Published var accelerometerData = CMAcceleration()
    @Published var gyroscopeData = CMRotationRate()
    @Published var magnetometerData = CMMagneticField()
    @Published var magnitudes: [Double] = []  // Variable to store magnitudes
    @Published var cumulativeSum: Double = 0.0  // Variable to store cumulative sum


    
    private var recordedAccelerometerData: [CMAcceleration] = []
    private var recordedGyroscopeData: [CMRotationRate] = []
    private var recordedMagnetometerData: [CMMagneticField] = []
    
    func startUpdates() {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.001
            motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, error in
                if let data = data {
                    self?.accelerometerData = data.acceleration
                    self?.recordedAccelerometerData.append(data.acceleration)
                    self?.checkAndSendData()
                }
            }
        }
        
        if motionManager.isGyroAvailable {
            motionManager.gyroUpdateInterval = 0.001
            motionManager.startGyroUpdates(to: .main) { [weak self] data, error in
                if let data = data {
                    self?.gyroscopeData = data.rotationRate
                    self?.recordedGyroscopeData.append(data.rotationRate)
                    self?.checkAndSendData()
                }
            }
        }
        
        if magnetometerManager.isMagnetometerAvailable {
            magnetometerManager.magnetometerUpdateInterval = 0.001
            magnetometerManager.startMagnetometerUpdates(to: .main) { [weak self] data, error in
                if let data = data {
                    self?.magnetometerData = data.magneticField
                    self?.recordedMagnetometerData.append(data.magneticField)
                    self?.checkAndSendData()
                }
            }
        }
    }
    
    func stopUpdates() {
        motionManager.stopAccelerometerUpdates()
        motionManager.stopGyroUpdates()
        magnetometerManager.stopMagnetometerUpdates()
    }
    
    func startRecording() {
        cumulativeSum = 0.0
        magnitudes.removeAll()
        recordedAccelerometerData.removeAll()
        recordedGyroscopeData.removeAll()
        recordedMagnetometerData.removeAll()
        
        startUpdates()
    }
    
    func stopRecording() {
        stopUpdates()
    }
    
    func checkAndSendData() {
        if recordedAccelerometerData.count >= 100 || recordedGyroscopeData.count >= 100 {
            sendDataToServer()
            recordedAccelerometerData.removeAll()
            recordedGyroscopeData.removeAll()
            recordedMagnetometerData.removeAll()
        }
    }
    
    func sendDataToServer() {
        guard let url = URL(string: "http://128.180.100.88:5000/data") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let dataToSend: [String: Any] = [
            "accelerometerData": recordedAccelerometerData.map { ["x": $0.x, "y": $0.y, "z": $0.z] },
            "gyroscopeData": recordedGyroscopeData.map { ["x": $0.x, "y": $0.y, "z": $0.z] },
            "magnetometerData": recordedMagnetometerData.map { ["x": $0.x, "y": $0.y, "z": $0.z] }
        ]

        print(dataToSend)
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dataToSend, options: [])
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error sending data: \(error)")
                    return
                }
                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    let response = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    let message = response["message"] as! String
                    let magnitude = response["magnitude"] as! [Double]
                    print("type of magnitude: \(type(of: magnitude))")
                    print("Magnitude from server: \(magnitude)")
                    print("Message from server:  \(message)")
                    print("Response from server: \(responseString)")

                    if magnitude[0] > 0.02{
                        DispatchQueue.main.async{
                        self.magnitudes.append(magnitude[0])
                        self.cumulativeSum += self.magnitudes[0]
                        print(self.cumulativeSum)
                    }
                    }    

                    
                }
            }
            task.resume()
        } catch {
            print("Error serializing JSON: \(error)")
        }
    }
}
