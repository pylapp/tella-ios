//
//  Copyright © 2022 INTERNEWS. All rights reserved.
//

import SwiftUI

struct ManageFileView: View {
    
    @EnvironmentObject var fileListViewModel : FileListViewModel
    
    var body: some View {
        HStack(spacing: 0) {
            
            sortFilesButton
            
            Spacer()
            
            selectingFilesButton
            
            Spacer()
                .frame(width: 5)
            
            viewTypeButton
        }
        .padding(EdgeInsets(top: 0, leading: fileListViewModel.showingMoveFileView ? 8 : 16 , bottom: 0, trailing: fileListViewModel.showingMoveFileView ? 8 : 12))
        
    }
    
    
    private var sortFilesButton: some View {
        Button {
            fileListViewModel.showingSortFilesActionSheet = true
        } label: {
            HStack{
                Text(fileListViewModel.sortBy.displayName)
                    .font(.custom(Styles.Fonts.regularFontName, size: 14) )
                    .foregroundColor(.white)
                fileListViewModel.sortBy.image
                    .frame(width: 20, height: 20)
            }
        }
        .frame(height: 44)
    }
    
    @ViewBuilder
    private var selectingFilesButton: some View {
        
        if !fileListViewModel.showingMoveFileView {
            
            Button {
                
                
                if fileListViewModel.selectingFiles {
                    fileListViewModel.filesAreAllSelected ? fileListViewModel.resetSelectedItems() :  fileListViewModel.selectAll()
                } else {
                    fileListViewModel.selectingFiles = !fileListViewModel.selectingFiles
                    fileListViewModel.initVaultFileStatusArray()
                }
                
            } label: {
                
                HStack {
                    
                    if fileListViewModel.selectingFiles {
                        Image(fileListViewModel.filesAreAllSelected ? "files.selected" : "files.unselected-empty")
                    } else {
                        Image("files.select")
                    }
                }
            }
            .frame(width: 50, height: 50)
        }
    }
    
    @ViewBuilder
    private var viewTypeButton: some View {
        if !fileListViewModel.shouldHideViewsForGallery {
            Button {
                fileListViewModel.viewType = fileListViewModel.viewType == .list ? FileViewType.grid : FileViewType.list
            } label: {
                HStack{
                    fileListViewModel.viewType.image
                        .frame(width: 24, height: 24)
                }
            }
            .frame(width: 50, height: 50)
        }
    }
    
}

struct ManageFileView_Previews: PreviewProvider {
    static var previews: some View {
        ManageFileView()
    }
}