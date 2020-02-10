//
//  RequestFactory.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 26.11.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import Toolkit

struct RequestFactory {
    
    // MARK: Endpoints
    
    static let endpointHse = "https://www.hse.ru/data_protection_regulation"
    static let endpointRoot = "https://dima.pythonanywhere.com/"
    static let endpointWeb = "https://slide-wallet.web.app"
    
    
    // MARK: Auth
    
    static func login(username: String, password: String) -> RequestConfig<LoginParser> {
        let request = LoginRequest(username: username, password: password)
        let parser = LoginParser()
        
        return .init(request: request, parser: parser)
    }
    
    static func register(username: String,
                         password: String,
                         email: String,
                         name: String,
                         surname: String) -> RequestConfig<LoginParser> {
        let request = RegistrationRequest(username: username,
                                          password: password,
                                          email: email,
                                          name: name,
                                          surname: surname)
        let parser = LoginParser()
        
        return .init(request: request, parser: parser)
    }
    
    static func restore(email: String) -> RequestConfig<MessageParser> {
        let request = RestoreRequest(email: email)
        let parser = MessageParser()
        
        return .init(request: request, parser: parser)
    }
    
    static func reset(currentPassword: String,
                      newPassword: String) -> RequestConfig<MessageParser> {
        let request = ResetRequest(currentPassword: currentPassword,
                                   newPassword: newPassword)
        let parser = MessageParser()
        
        return .init(request: request, parser: parser)
    }
    
    static func reset(newPassword: String, token: String) -> RequestConfig<MessageParser> {
        let request = ResetEmailRequest(newPassword: newPassword, token: token)
        let parser = MessageParser()
        
        return .init(request: request, parser: parser)
    }
    
    static func tokenRefresh() -> RequestConfig<AccessTokenParser> {
        let request = TokenRefreshRequest()
        let parser = AccessTokenParser()
        
        return .init(request: request, parser: parser)
    }
    
    static func logoutAccess() -> RequestConfig<MessageParser> {
        let request = LogoutAccessRequest()
        let parser = MessageParser()
        
        return .init(request: request, parser: parser)
    }
    
    static func logoutRefresh() -> RequestConfig<MessageParser> {
        let request = LogoutRefreshRequest()
        let parser = MessageParser()
        
        return .init(request: request, parser: parser)
    }
    
    
    // MARK: Users
    
    static func transfer(receiver: User,
                         amount: Int) -> RequestConfig<MessageParser> {
        let request = TransferRequest(receiverUsername: receiver.username,
                                      amount: amount)
        let parser = MessageParser()
        
        return .init(request: request, parser: parser)
    }
    
    static func users() -> RequestConfig<UsersParser> {
        let request = UsersRequest()
        let parser = UsersParser()
    
        return .init(request: request, parser: parser)
    }
    
    static func user(by userID: Int) -> RequestConfig<UserParser> {
        let request = UserByIDRequest(userID: userID)
        let parser = UserParser()
        
        return .init(request: request, parser: parser)
    }
    
    static func deleteUser(by userID: Int) -> RequestConfig<MessageParser> {
        let request = DeleteUserRequest(userID: userID)
        let parser = MessageParser()
        
        return .init(request: request, parser: parser)
    }
    
    static func deleteAllUsers() -> RequestConfig<LoginParser> {
        let request = DeleteAllUsersRequest()
        let parser = LoginParser()
    
        return .init(request: request, parser: parser)
    }
    
    
    static func feedback(body: String) -> RequestConfig<MessageParser> {
        let request = FeedbackRequest(body: body)
        let parser = MessageParser()
        
        return .init(request: request, parser: parser)
    }
    
    
    // MARK: Transactions
    
    static func transactions() -> RequestConfig<TransactionsParser> {
        let request = TransactionsRequest()
        let parser = TransactionsParser()
        
        return .init(request: request, parser: parser)
    }
    
    static func addMoney(userID: Int, amount: Int) -> RequestConfig<MessageParser> {
        let request = AddMoneyRequest(userID: userID, amount: amount)
        let parser = MessageParser()
        
        return .init(request: request, parser: parser)
    }
    
    
    // MARK: Store
    
    static func shop() -> RequestConfig<ShopParser> {
        let request = ShopRequest()
        let parser = ShopParser()
        
        return .init(request: request, parser: parser)
    }
    
    static func myPurchases() -> RequestConfig<ShopParser> {
        let request = MyPurchasesRequest()
        let parser = ShopParser()
        
        return .init(request: request, parser: parser)
    }
    
    static func buy(by productID: Int) -> RequestConfig<MessageParser> {
        let request = BuyRequest(productID: productID)
        let parser = MessageParser()
        
        return .init(request: request, parser: parser)
    }
    
    static func addItem(name: String,
                        price: Int,
                        description: String) -> RequestConfig<MessageParser> {
        let request = AddItemRequest(name: name,
                                     price: price,
                                     description: description)
        let parser = MessageParser()
        
        return .init(request: request, parser: parser)
    }
    
    static func deleteItem(by productID: Int) -> RequestConfig<MessageParser> {
        let request = DeleteItemRequest(productID: productID)
        let parser = MessageParser()
        
        return .init(request: request, parser: parser)
    }
    
    static func updateItem(by productID: Int,
                           name: String,
                           price: Int,
                           description: String) -> RequestConfig<MessageParser> {
        let request = UpdateItemRequest(productID: productID,
                                        name: name,
                                        price: price,
                                        description: description)
        let parser = MessageParser()
        
        return .init(request: request, parser: parser)
    }
    
    static func addAdmin(email: String) -> RequestConfig<MessageParser> {
        let request = AddAdminRequest(email: email)
        let parser = MessageParser()
        
        return .init(request: request, parser: parser)
    }
}
