//
//  RequestFactory.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 26.11.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import Toolkit

struct RequestFactory {
    
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
    
    static func reset(accessToken: String,
                      currentPassword: String,
                      newPassword: String) -> RequestConfig<MessageParser> {
        let request = ResetRequest(accessToken: accessToken,
                                   currentPassword: currentPassword,
                                   newPassword: newPassword)
        let parser = MessageParser()
        
        return .init(request: request, parser: parser)
    }
    
    static func reset(newPassword: String, token: String) -> RequestConfig<MessageParser> {
        let request = ResetEmailRequest(newPassword: newPassword, token: token)
        let parser = MessageParser()
        
        return .init(request: request, parser: parser)
    }
    
    static func tokenRefresh(refreshToken: String) -> RequestConfig<AccessTokenParser> {
        let request = TokenRefreshRequest(refreshToken: refreshToken)
        let parser = AccessTokenParser()
        
        return .init(request: request, parser: parser)
    }
    
    static func logoutAccess(accessToken: String) -> RequestConfig<MessageParser> {
        let request = LogoutAccessRequest(accessToken: accessToken)
        let parser = MessageParser()
        
        return .init(request: request, parser: parser)
    }
    
    static func logoutRefresh(refreshToken: String) -> RequestConfig<MessageParser> {
        let request = LogoutRefreshRequest(refreshToken: refreshToken)
        let parser = MessageParser()
        
        return .init(request: request, parser: parser)
    }
    
    
    // MARK: Users
    
    static func transfer(accessToken: String,
                         receiver: User,
                         amount: Int) -> RequestConfig<MessageParser> {
        let request = TransferRequest(accessToken: accessToken,
                                      receiverUsername: receiver.username,
                                      amount: amount)
        let parser = MessageParser()
        
        return .init(request: request, parser: parser)
    }
    
    static func users(accessToken: String) -> RequestConfig<UsersParser> {
        let request = UsersRequest(accessToken: accessToken)
        let parser = UsersParser()
    
        return .init(request: request, parser: parser)
    }
    
    static func user(_ identifier: Int, accessToken: String) -> RequestConfig<UserParser> {
        let request = UserByIDRequest(accessToken: accessToken, identifier: identifier)
        let parser = UserParser()
        
        return .init(request: request, parser: parser)
    }
    
    static func deleteUser(by userID: Int, accessToken: String) -> RequestConfig<MessageParser> {
        let request = DeleteUserRequest(userID: userID, accessToken: accessToken)
        let parser = MessageParser()
        
        return .init(request: request, parser: parser)
    }
    
    static func deleteAllUsers() -> RequestConfig<LoginParser> {
        let request = DeleteAllUsersRequest()
        let parser = LoginParser()
    
        return .init(request: request, parser: parser)
    }
    
    
    static func feedback(body: String, accessToken: String) -> RequestConfig<MessageParser> {
        let request = FeedbackRequest(body: body, accessToken: accessToken)
        let parser = MessageParser()
        
        return .init(request: request, parser: parser)
    }
    
    
    // MARK: Transactions
    
    static func transactions(accessToken: String) -> RequestConfig<TransactionsParser> {
        let request = TransactionsRequest(accessToken: accessToken)
        let parser = TransactionsParser()
        
        return .init(request: request, parser: parser)
    }
    
    static func addMoney(userID: Int,
                         amount: Int,
                         accessToken: String) -> RequestConfig<MessageParser> {
        let request = AddMoneyRequest(userID: userID, amount: amount, accessToken: accessToken)
        let parser = MessageParser()
        
        return .init(request: request, parser: parser)
    }
    
    
    // MARK: Store
    
    static func shop(accessToken: String) -> RequestConfig<ShopParser> {
        let request = ShopRequest(accessToken: accessToken)
        let parser = ShopParser()
        
        return .init(request: request, parser: parser)
    }
    
    static func myPurchases(accessToken: String) -> RequestConfig<ShopParser> {
        let request = MyPurchasesRequest(accessToken: accessToken)
        let parser = ShopParser()
        
        return .init(request: request, parser: parser)
    }
    
    static func buy(id: Int, accessToken: String) -> RequestConfig<MessageParser> {
        let request = BuyRequest(id: id, accessToken: accessToken)
        let parser = MessageParser()
        
        return .init(request: request, parser: parser)
    }
    
    static func addItem(name: String,
                        price: Int,
                        description: String,
                        accessToken: String) -> RequestConfig<MessageParser> {
        let request = AddItemRequest(name: name,
                                     price: price,
                                     description: description,
                                     accessToken: accessToken)
        let parser = MessageParser()
        
        return .init(request: request, parser: parser)
    }
    
    static func deleteItem(by productID: Int, accessToken: String) -> RequestConfig<MessageParser> {
        let request = DeleteItemRequest(productID: productID, accessToken: accessToken)
        let parser = MessageParser()
        
        return .init(request: request, parser: parser)
    }
}
