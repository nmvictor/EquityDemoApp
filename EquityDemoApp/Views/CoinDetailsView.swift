//
//  CoinDetailsView.swift
//  EquityDemoApp
//
//  Created by Moin' Victor on 02/05/2025.
//


import SwiftUI

struct CoinDetailsView: View {
    
    @ObservedObject var viewModel: CoinDetailsViewModel
    private let columns: [GridItem] = [
           GridItem(.flexible()),
           GridItem(.flexible()),
       ]
    private let spacing: CGFloat = 30
    
    
    var body: some View {
           ScrollView {
               VStack {
                   ChartView(coin: viewModel.coin)
                       .padding(.vertical)

                   VStack(spacing: 20) {
                       Text("Name: \(viewModel.title)")
                       Divider()
                       Text("Price:   \(viewModel.symbol) \(viewModel.price)")
                      // overviewGrid
                       Divider()
                       Text("Market Cap: \(viewModel.marketCap)")
                       Divider()
                       Text("Tier: \(viewModel.tier)")
                       Divider()
                       Text("Rank: \(viewModel.rank)")
                       Button {
                           viewModel.buttonTapped()
                       } label: {
                           Text(viewModel.buttonTitle)
                               .font(.system(size: 17, weight: .bold))
                               .foregroundColor(Color.white)
                               .padding()
                       }
                       .background(Color.black)
                       .cornerRadius(10)
                       .padding(.top, 20)
                   }
                   .padding()
               }
           }
           .background(
            Color.white
                   .ignoresSafeArea()
           )
           .navigationTitle(viewModel.title)
//           .toolbar {
//               ToolbarItem(placement: .navigationBarTrailing) {
//                   navigationBarTrailingItems
//               }
           }
       }
    


//    var body: some View {
//        VStack {
//            if viewModel.isLoading {
//                EmptyView()
//            } else {
//                Text("Name: \(viewModel.title)")
//                Text("Price:   \(viewModel.symbol) \(viewModel.price)")
//                Text("Market Cap: \(viewModel.marketCap)")
//                Text("Tier: \(viewModel.tier)")
//                Text("Rank: \(viewModel.rank)")
//                Button {
//                    viewModel.buttonTapped()
//                } label: {
//                    Text(viewModel.buttonTitle)
//                        .font(.system(size: 17, weight: .bold))
//                        .foregroundColor(Color.white)
//                        .padding()
//                }
//                .background(Color.black)
//                .cornerRadius(10)
//                .padding(.top, 20)
//            }
//        }
//        .alert(viewModel.errorAlertTitle, isPresented: $viewModel.shouldShowAlert) {
//            Button(viewModel.errorAlertButtonTitle) {
//                viewModel.errorAlertButtonTapped()
//            }
//        }
//    }

