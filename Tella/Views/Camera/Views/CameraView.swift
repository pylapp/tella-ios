//
//  Copyrighét © 2022 INTERNEWS. All rights reserved.
//

import SwiftUI
import Combine

struct CameraView: View {
    
    // MARK: - Public properties
    
    @State var showingProgressView : Bool = false
    @ObservedObject var cameraViewModel :  CameraViewModel
    
    var customCameraRepresentable = CustomCameraRepresentable(
        cameraFrame: .zero,
        imageCompletion: {_,_   in }, videoURLCompletion: { _  in }
    )
    
    // MARK: - Private properties
    
    @State private var image: UIImage?
    @EnvironmentObject private var mainAppModel : MainAppModel
    
    
    var body: some View {
        
        ZStack {
            
            let frame = CGRect(x: 0, y: 0, width: UIScreen.screenWidth, height: UIScreen.screenHeight)
            
            cameraView(frame: frame)
                .edgesIgnoringSafeArea(.all)
            
            getCameraControlsView()
            
            getCameraHeaderView()
            
            ImportFilesProgressView(showingProgressView: $showingProgressView,
                                    importFilesProgressProtocol: ImportFilesFromCameraProgress())
            
        }
        
        .environmentObject(cameraViewModel)
        .onAppear {
            customCameraRepresentable.startRunningCaptureSession()
        }
        .onDisappear {
            customCameraRepresentable.stopRunningCaptureSession()
        }
        .navigationBarHidden(mainAppModel.selectedTab == .home ? false : true)
        
        .onReceive(customCameraRepresentable.$isRecording) { value in
            cameraViewModel.isRecording = value ?? false
        }
    }
    
    private  func cameraView(frame: CGRect) -> CustomCameraRepresentable {
        
        customCameraRepresentable.cameraFrame = frame
        
        customCameraRepresentable.imageCompletion = {image , data in
            cameraViewModel.image = image
            
            showingProgressView = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                cameraViewModel.saveImage()
            }
        }
        
        customCameraRepresentable.videoURLCompletion = {videoURL in
            cameraViewModel.videoURL = videoURL
            showingProgressView = true
            
            cameraViewModel.saveVideo()
        }
        return customCameraRepresentable
    }
    
    private func getCameraHeaderView() -> some View {
        VStack {
            
            HStack() {
                
                // Close button
                Button {
                    mainAppModel.vaultManager.clearTmpDirectory()
                    mainAppModel.selectedTab = .home
                } label: {
                    Image("close")
                }
                .frame(width: 30, height: 30)
                .padding(EdgeInsets(top: 15, leading: 16, bottom: 0, trailing: 12))
                
                Spacer()
                
                // Flash button
                Button {
                    customCameraRepresentable.toggleFlash()
                } label: {
                    Image("camera.flash")
                }
                .frame(width: 30, height: 30)
                .padding(EdgeInsets(top: 15, leading: 16, bottom: 0, trailing: 12))
            }
            .frame(height: 90)
            .background(Color.black.opacity(0.8))
            .edgesIgnoringSafeArea(.all)
            
            Spacer()
            
        }
        
    }
    private func getCameraControlsView() -> some View {
        
        CameraControlsView(captureButtonAction: {
            customCameraRepresentable.takePhoto()
        }, recordVideoAction: {
            customCameraRepresentable.startCaptureVideo()
        }, toggleCamera: {
            customCameraRepresentable.toggleCameraType()
        }, updateCameraTypeAction: { cameraType in
            customCameraRepresentable.cameraType = cameraType
        } )
            .edgesIgnoringSafeArea(.all)
        
    }
}
