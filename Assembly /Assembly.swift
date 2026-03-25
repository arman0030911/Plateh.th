import Foundation

class Assembly { 
    static func createMAinViewModel() -> MainViewModel {
        let dataSource = FetchPaymentsManager()
        let repo = FetchPaymentsRepositoryImpl(dataSource:dataSource)
        let useCase = FetchPaymentsUseCaseImpl(repository:repo )
        
         let setDataSource = SetPaymentManager()
         let setRepo = SetPaymentRepositoryImpl(dataSource: setDataSource)
         let setUseCase = SetPaymentUseCaseImpl(repository: setRepo)
        
        return MainViewModel(FetchUseCase: useCase, setUseCase: setUseCase )
    }
    
    static func createAddViewModel() -> AddViewModel{
        let manager = CreatePaymentManager()
        let repo = CreatePaymentRepositoryImpt(dataSource:manager)
        let useCase = CreatePaymentUseCaseImp(repository: repo)
        return AddViewModel(createUseCase: useCase )
    }
    
    static func createPaymentsViewModel() -> PaymentsViewModel { 
        let dataSource = FetchPaymentsManager () 
        let repo = FetchPaymentsRepositoryImpl(dataSource: dataSource)
        let useCase = FetchPaymentsUseCaseImpl(repository: repo)

        let setDataSource = SetPaymentManager()
        let setRepo = SetPaymentRepositoryImpl(dataSource: setDataSource)
        let setUseCase = SetPaymentUseCaseImpl(repository: setRepo)

        return PaymentsViewModel(fetchUseCase: useCase, setUseCase: setUseCase)
    }

    static func createDetailsViewModel() -> DetailsViewModel {
        let fetchDataSource = FetchPaymentsManager()
        let fetchRepo = FetchPaymentsRepositoryImpl(dataSource: fetchDataSource)
        let fetchUseCase = FetchPaymentsUseCaseImpl(repository: fetchRepo)

        let updateDataSource = UpdatePaymentManager()
        let updateRepo = UpdatePaymentRepositoryImpl(dataSource: updateDataSource)
        let updateUseCase = UpdatePaymentUseCaseImpl(repository: updateRepo)

        let deleteDataSource = DeletePaymentManager()
        let deleteRepo = DeletePaymentRepositoryImpl(dataSource: deleteDataSource)
        let deleteUseCase = DeletePaymentUseCaseImpl(repository: deleteRepo)

        return DetailsViewModel(
            fetchUseCase: fetchUseCase,
            updateUseCase: updateUseCase,
            deleteUseCase: deleteUseCase
        )
    }
}
