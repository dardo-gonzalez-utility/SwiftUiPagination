import Foundation
import Combine

open class DataSourceCombine<T: Identifiable> {
    
    private var page = 1
    private let pageSize: Int
    private var totalCount = -1
    private var retrievedIds: [T.ID] = []
    
    internal func fetchRequest(after: Int, first: Int) -> AnyPublisher<DataSourcePage<T>, Error> {
        fatalError("Fetch method not implemented")
    }
    
    init(pageSize: Int) {
        self.pageSize = pageSize
    }
    
    func retrieveNextPage() -> AnyPublisher<[T], Error>  {
        if !shouldRetrieveNextPage() {
            return createEmptyPublisher()
        }
        
        return fetchRequest(after: page - 2, first: pageSize)
            .flatMap { [weak self] dataSourcePage in
                Just(self?.processDataSource(dataSourcePage) ?? [])
            }
            .eraseToAnyPublisher()
    }
    
    private func shouldRetrieveNextPage() -> Bool {
        totalCount < 0 ? true : page * pageSize < totalCount
    }

    func createEmptyPublisher() -> AnyPublisher<[T], Error> {
        let subject = PassthroughSubject<[T], Error>()
        DispatchQueue.main.async {
            subject.send([])
        }
        return subject.eraseToAnyPublisher()
    }
    
    // If new items are added in the BE between subsequent calls, this can result in getting
    // again a previously obtained item in the next requested page. To avoid duplicating it
    // we check them with the already retrieved ids
    func processDataSource(_ dataSourcePage: DataSourcePage<T>) -> [T] {
        page += 1
        totalCount = dataSourcePage.totalCount // totalCount may vary between subsequent calls because new items can be added in the BE
        let newItems = dataSourcePage.page.filter { !retrievedIds.contains($0.id) }
        retrievedIds.append(contentsOf: newItems.map { $0.id} )
        return newItems
    }
}
