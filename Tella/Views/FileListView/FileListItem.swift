//
//  Copyright © 2021 INTERNEWS. All rights reserved.
//

import SwiftUI

struct FileListItem: View {
    
    var file: VaultFile
    var parentFile: VaultFile?
    
    @State var showingActionSheet: Bool = false
    @ObservedObject var appModel: MainAppModel
    @State var showFileInfoActive = false
    
    @Binding var selectingFile : Bool
    @Binding var isSelected : Bool
    
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                HStack(alignment: .center, spacing: 0){
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 35, height: 35, alignment: .center)
                        .overlay(
                            file.gridImage
                                .frame(width: 35, height: 35)
                                .cornerRadius(5)
                        )
                    VStack(alignment: .leading, spacing: 0){
                        Spacer()
                        Text(file.fileName)
                            .font(Font(UIFont.boldSystemFont(ofSize: 14)))
                            .foregroundColor(Color.white)
                            .lineLimit(1)
                        
                        if #available(iOS 14.0, *) {
                            Text(file.created, style: .date)
                                .font(Font(UIFont.systemFont(ofSize: 10)))
                                .foregroundColor(Color(white: 0.8))
                        } else {
                            TextDate(date: file.created)
                            // Fallback on earlier versions
                        }

//                        NavigationLink(destination:
//                                        FileInfoView(file: file),
//                                       isActive: $showFileInfoActive) {
//                            EmptyView()
//                        }.hidden()
                         Spacer()

                    }
                    .padding(EdgeInsets(top: 0, leading: 18, bottom: 0, trailing: 0))
                    Spacer()
                    if selectingFile {
                        HStack {
                            Image(isSelected ? "files.selected" : "files.unselected")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                        .frame(width: 40, height: 40)
                        
                        
                    } else {
                        HStack{
                            Image("files.more")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                        .frame(width: 40, height: 40)
                        .onTapGesture {
                            showingActionSheet = true
                        }
                    }
                    
                    FileActionMenu(selectedFile: file,
                                   parentFile: parentFile,
                                   showingActionSheet: $showingActionSheet,
                                   showFileInfoActive: $showFileInfoActive,
                                   appModel: appModel)
                }
                .padding(EdgeInsets(top: 12, leading: 17, bottom: 12, trailing: 20))
                
                if selectingFile {
                    Rectangle()
                        .fill(Color.white.opacity(0.001))
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .onTapGesture {
                            isSelected = !isSelected
                        }
                }
            }
            .listRowBackground((isSelected && selectingFile)  ? Color.white.opacity(0.16) : Styles.Colors.backgroundMain)
            .background((isSelected && selectingFile) ? Color.white.opacity(0.16) : Styles.Colors.backgroundMain)

            .frame(height: 60)
            
        }
    }
}
