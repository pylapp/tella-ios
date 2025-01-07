//
//  Copyright © 2022 INTERNEWS. All rights reserved.
//

import Foundation
import SwiftUI

struct SubmittedDetailsView: View {
    
    @StateObject var submittedReportVM : SubmittedMainViewModel
    @EnvironmentObject private var sheetManager: SheetManager
    
    var rootView: AnyClass = ViewClassType.reportMainView
    private let delayTimeInSecond = 0.1

    var body: some View {
        
        ContainerView {
            
            VStack {
                
                outboxReportHeaderView
                
                ZStack {
                    
                    ScrollView {
                        
                        VStack(alignment: .leading, spacing: 0) {
                            
                            reportDetails
                            
                            Spacer()
                                .frame(width: 16)
                            
                            itemsListView
                        }
                    }.padding(EdgeInsets(top: 20, leading: 16, bottom: 70, trailing: 16))
                }
            }
        }
        .onReceive(submittedReportVM.$shouldShowMainView, perform: { value in
            if value {
                dismissViews()
            }
        })
        .onReceive(submittedReportVM.$shouldShowToast) { shouldShowToast in
            if shouldShowToast {
                Toast.displayToast(message: submittedReportVM.toastMessage)
            }
        }
        .onReceive(submittedReportVM.$shouldShowMainView, perform: { value in
            if value {
                dismissViews()
            }
        })
        .navigationBarHidden(true)
    }
    
    var outboxReportHeaderView: some View {
        
        HStack(spacing: 0) {
            Button {
                dismissViews()
            } label: {
                Image("back")
                    .flipsForRightToLeftLayoutDirection(true)
                    .padding()
            }
            
            Text(LocalizableReport.reportsText.localized)
                .font(.custom(Styles.Fonts.semiBoldFontName, size: 14))
                .foregroundColor(.white)
            
            Spacer()
            
            Button {
                showDeleteReportConfirmationView()
            } label: {
                Image("report.delete-outbox")
                    .padding(.all, 22)
            }
            
        }.frame(height: 56)
    }
    
    
    private var reportDetails: some View {
        Group {
            Text(submittedReportVM.title)
                .font(.custom(Styles.Fonts.semiBoldFontName, size: 14))
                .foregroundColor(.white)
            
            Spacer()
                .frame(height: 4)
            
            uploadInfosView
            
            if submittedReportVM.reportHasDescription {
                
                Spacer()
                    .frame(height: 12)
                
                Text(submittedReportVM.description)
                    .font(.custom(Styles.Fonts.regularFontName, size: 13))
                    .foregroundColor(.white)
                
            }
            Spacer()
                .frame(height: 18)
            
            if submittedReportVM.reportHasFile {
                Divider()
                    .background(Color.white)
            }
        }
    }
    
    private var uploadInfosView : some View {
        
        Group {
            Text(submittedReportVM.uploadedDate)
                .font(.custom(Styles.Fonts.regularFontName, size: 13))
                .foregroundColor(.white)
            
            Spacer()
                .frame(height: 2)
            
            if submittedReportVM.reportHasFile {
                Text(submittedReportVM.uploadedFiles)
                    .font(.custom(Styles.Fonts.regularFontName, size: 13))
                    .foregroundColor(.white)
            }
            
        }
    }
    
    private var itemsListView: some View {
        LazyVStack(spacing: 1) {
            ForEach($submittedReportVM.progressFileItems, id: \.file.id) { file in
                SubmittedDetailsItemView(item: file)
                    .frame(height: 60)
            }
        }
    }
    
    private func dismissViews() {
        self.submittedReportVM.reportsMainViewModel.selectedPage = .submitted
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delayTimeInSecond, execute: {
            self.popTo(rootView)
        })
    }
    
    private func showDeleteReportConfirmationView() {
        sheetManager.showBottomSheet(modalHeight: 200) {
            DeleteReportConfirmationView(title: submittedReportVM.title,
                                         message: LocalizableReport.deleteSubmittedReportMessage.localized) {
                submittedReportVM.deleteReport()
                sheetManager.hide()
            }
        }
    }
    
}

//struct ReportDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        OutboxDetailsView()
//    }
//}