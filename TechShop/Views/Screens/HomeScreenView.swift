//
//  HomeScreenView.swift
//  TechShop
//
//  Created by Swarup Ranjan Mondal on 09/01/21.
//

import SwiftUI

struct HomeScreenView: View {
    
    @ObservedObject var main = MainController.shared
    @State var searchText = ""
    
    var products: [Product]
    
    var body: some View {
        ZStack {
            ScrollView(.vertical) {
                HStack {
                    NavigationLink(
                        destination: LoginScreenView(),
                        tag: "Login",
                        selection: $main.selection
                    ) {
                        EmptyView()
                    }
                    
                    NavigationLink(
                        destination: RegisterScreenView(),
                        tag: "Register",
                        selection: $main.selection
                    ) {
                        EmptyView()
                    }
                }
                
                HStack {
                    NavigationLink(
                        destination: ProfileScreenView()
                                        .onAppear() {
                                            main.getMyOrders()
                                        },
                        tag: "Profile",
                        selection: $main.selection
                    ) {
                        EmptyView()
                    }
                    
                    NavigationLink(
                        destination: UpdateProfileScreen(name: main.user.name, email: main.user.email),
                        tag: "UpdateProfile",
                        selection: $main.selection
                    ) {
                        EmptyView()
                    }
                }
                
                HStack {
                    NavigationLink(
                        destination: UserListScreenView()
                            .onAppear() {
                                main.listUsers()
                            },
                        tag: "Users",
                        selection: $main.selection
                    ){
                        EmptyView()
                    }
                    
                    NavigationLink(
                        destination: ProductListScreenView()
                            .onAppear() {
                                main.listProducts()
                            },
                        tag: "Products",
                        selection: $main.selection
                    ){
                        EmptyView()
                    }
                    
                    NavigationLink(
                        destination: OrderListScreenView()
                            .onAppear() {
                                main.listOrders()
                            },
                        tag: "Orders",
                        selection: $main.selection
                    ){
                        EmptyView()
                    }
                }
                
                HStack {
                    NavigationLink(
                        destination: CartScreenView()
                                        .onAppear() {
                                            main.loadShippingAddress()
                                        },
                        tag: "Cart",
                        selection: $main.selection
                    ) {
                        EmptyView()
                    }
                    
                    NavigationLink(
                        destination: ShippingScreenView(shippingAddress: main.shippingAddress)
                                        .onAppear() {
                                            main.loadPaymentMethod()
                                        },
                        tag: "Shipping",
                        selection: $main.selection
                    ) {
                        EmptyView()
                    }
                    
                    NavigationLink(
                        destination: OrderScreenView(),
                        tag: "OrderScreen",
                        selection: $main.selection
                    ) {
                        EmptyView()
                    }
                }
                
                NavigationLink(
                    destination: ProductDetailsScreenView()
                                    .onAppear() {
                                        MainController.shared.getProductDetails(productId: main.selectedIdOrScreen, completionHandler: {} ) 
                                    },
                    tag: "Product",
                    selection: $main.selection
                ) {
                    EmptyView()
                }
                
                VStack(alignment: .center, spacing: 0) {
                    Text(main.isLoggedIn ? "Welcome \(getFirstName(main.user.name))!" : "")
                        .font(.system(size: 16, weight: .heavy))
                        .foregroundColor(.gray)
                        .padding(.leading, 12)
                        .padding(.trailing, 10)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    
                    SearchBar(searchText: $searchText)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                    
                    if products.count == 0 {
                        Text("Failed to load products! 😥")
                            .bold()
                            .multilineTextAlignment(.center)
                            .padding(.top, 50)
                            .padding(.horizontal, 20)
                    } else {
                        ForEach(products.filter({ product in
                            searchText.isEmpty ||
                                (product.name.range(of: searchText, options: .caseInsensitive) != nil) || (product.brand.range(of: searchText, options: .caseInsensitive) != nil)
                        })) { product in
                            Button(action: {
                                main.selectedIdOrScreen = product._id
                                main.selection = "Product"
                            }) {
                                ProductView(product: product)
                            }
                        }
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: TitleView())
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    CartButton()
                    if main.user.isAdmin {
                        AdminDropDownButton()
                    }
                    UserDropDownButton()
                }
            }
            
            if main.loading {
                Loader()
            }
        }
    }
}

struct ProductListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
//            HomeScreenView(products: testProducts)
        }
    }
}
