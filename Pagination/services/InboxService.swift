import Foundation
import Combine

enum MessagesError: Error {
    case unknown
}

/**
 Manager that handles queries to obtain the messages from BE
 */

class InboxService {
    
    // Method for getting messages using async/await
    func getMessagesWithAsyncAwait(page: Int) async throws -> [Message] {
        return try await withCheckedThrowingContinuation { continuation in
            let query = GraphQLMessagesQuery(after: page, first: 10)
            apolloClient.fetch(query: query) { result in
                switch result {
                case .success(let response):
                    guard let messagesGraphQL = response.data else {
                        return continuation.resume(throwing: MessagesError.unknown)
                    }
                    continuation.resume(returning: messagesGraphQL.messages.map { Message(graphQLMessageEntity: $0) } )
                case .failure(let error):
                    return continuation.resume(throwing: error)
                }
            }
        }
    }
    
    // Method for getting messages using combine
    func getMessagesWithCombine(page: Int) -> AnyPublisher<[Message], Error> {
        let subject = PassthroughSubject<[Message], Error>()
        
        let query = GraphQLMessagesQuery(after: page, first: 10)
        apolloClient.fetch(query: query) { result in
            switch result {
            case .success(let response):
                if let messagesGraphQL = response.data  {
                    subject.send(messagesGraphQL.messages.map { Message(graphQLMessageEntity: $0) })
                } else {
                    subject.send(completion: .failure(MessagesError.unknown))
                }
            case .failure(let error):
                subject.send(completion: .failure(error))
            }
        }

        return subject.eraseToAnyPublisher()
    }
}
