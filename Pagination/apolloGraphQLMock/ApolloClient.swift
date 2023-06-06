import Foundation

let apolloClient = ApolloClient.shared
typealias GraphQLResultHandler<Data> = (Result<GraphQLResult<Data>, Error>) -> Void

/**
 Mock of the GraphQL client defined in Apollo library.
 */

class ApolloClient {
    
    public static let shared = ApolloClient()
    
    private let maxPages = 3
    var errorInFirstPage = false
    var errorInSecondPage = false
    var emptyMessages = false

    /**
     This method mocks the fetch apollo one with these behaviour:
     - If errorInFirstPage is set, we return an error when quering the first page
     - If errorInSecondPage is set, we return an error when quering the second page
     - If neither of them are set, we return the messages
     
     When returning the messages, this rules apply:
     - If emptyMessages is set, an empty array is returned
     - If emptyMessages is not set, we return:
            - 'first' messages for page 1
            - 'first' messages for page 2
            - 3 messages for page 3
            - 0 messages for page > 3
     */
    func fetch(query: GraphQLMessagesQuery, _ resultHandler: GraphQLResultHandler<GraphQLMessageSummary>? = nil) {
        print("Sending request to BE for after: \(query.after)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            print("Receiving response from BE for after: \(query.after)")
            let totalCount = self.maxPages * query.first + 3

            if query.after == -1 && self.errorInFirstPage {
                resultHandler?(.failure(GraphQLError("Backend or network error")))
                return
            }
            
            if query.after == 0 && self.errorInSecondPage {
                resultHandler?(.failure(GraphQLError("Backend or network error")))
                return
            }
            
            if query.after > self.maxPages - 2 {
                let summmary = GraphQLMessageSummary(totalCount: totalCount, messages: [])
                resultHandler?(.success(GraphQLResult<GraphQLMessageSummary>(data: summmary, errors: nil)))
                return
            }

            var messages: [GraphQLMessageEntity] = []
            if !self.emptyMessages {
                let results = query.after == self.maxPages - 2 ? 3 : query.first
                for i in 1...results {
                    messages.append(GraphQLMessageEntity(id: (query.after + 2) * 1000 + i, message: "Message \(i) in after \(query.after)"))
                }
            }
            let summmary = GraphQLMessageSummary(totalCount: totalCount, messages: messages)
            resultHandler?(.success(GraphQLResult<GraphQLMessageSummary>(data: summmary, errors: nil)))
        }
    }
}
