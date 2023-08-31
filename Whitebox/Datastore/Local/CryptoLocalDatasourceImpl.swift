//
//  CryptoLocalDatasourceImpl.swift
//  Whitebox
//
//  Created by Tünde Péter on 2023. 08. 31..
//

import Combine
import CoreData



// MARK: struct
struct CryptoLocalDatasourceImpl: CryptoLocalDatasource {
    // MARK: - properties
    private var viewContext: NSManagedObjectContext
    
    
    
    // MARK: - initialization
    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
    }
    
    
    
    // MARK: - get
    func getAssetList() -> AnyPublisher<[CryptoAsset], Error> {
        do {
            let objects = try viewContext.fetch(fetchRequestForCryptoListEntity())
            return .just(objects.map { CryptoAsset(id: $0.id!,
                                                   name: $0.name!,
                                                   icon: $0.icon,
                                                   isFavorite: $0.isFavorite) })
        } catch {
            return .fail(with: error)
        }
    }
    
    
    
    func getAssetExchangeRate(id: String) -> AnyPublisher<CryptoExchangeRate, Error> {
        do {
            if let object = try viewContext.fetch(fetchRequestForCryptoExchangeRateEntity(id: id)).first {
                return .just(CryptoExchangeRate(id: id, rate: object.rate))
            } else {
                return .fail(with: CustomErrors.storage(.itemNotFound))
            }
        } catch {
            return .fail(with: error)
        }
    }
    
    
    
    func getFavoritesAssets() -> AnyPublisher<[CryptoAsset], Error> {
        let fetchRequest = CryptoAssetEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isFavorite = true")
        
        do {
            let objects = try viewContext.fetch(fetchRequest)
            return .just(objects.map { CryptoAsset(id: $0.id!,
                                                   name: $0.name!,
                                                   icon: $0.icon,
                                                   isFavorite: $0.isFavorite) })
        } catch {
            return .fail(with: error)
        }
    }

    
    
    
    // MARK: - save
    func saveAssetList(list: [CryptoAsset]) -> AnyPublisher<[CryptoAsset], Error> {
        // create entities
        _ = list.map { item in
            let entity = CryptoAssetEntity(context: viewContext)
            entity.mapFromDomain(item: item)
        }
        
        // save
        do {
            try viewContext.save()
            return .just(list)
        } catch {
            return .fail(with: error)
        }
    }

    
    
    func saveAssetExchangeRate(rate: CryptoExchangeRate) -> AnyPublisher<CryptoExchangeRate, Error> {
        // fetch for already saved rates with id
        let result = try? viewContext.fetch(fetchRequestForCryptoExchangeRateEntity(id: rate.id)).first
        
        // setup entity
        let entity: CryptoExchangeRateEntity
        switch result {
        case .some(let data): entity = data
        default: entity = CryptoExchangeRateEntity(context: viewContext)
        }
        entity.mapFromDomain(item: rate)
        
        // save
        do {
            try viewContext.save()
            return .just(rate)
        } catch {
            return .fail(with: error)
        }
    }
    
    
    
    // MARK: - delete
    func deleteAssetList() -> AnyPublisher<Bool, Error> {
        // delete old items
        let results = try? viewContext.fetch(fetchRequestForCryptoListEntity())
        results?.forEach { viewContext.delete($0) }
        
        // save
        do {
            try viewContext.save()
            return .just(true)
        } catch {
            return .fail(with: error)
        }
    }
    
    
    
    // MARK: - update
    func updateAsset(asset: CryptoAsset) -> AnyPublisher<CryptoAsset, Error> {
        // fetch for already saved rates with id
        let result = try? viewContext.fetch(fetchRequestForCryptoEntity(id: asset.id)).first
        
        // setup entity
        let entity: CryptoAssetEntity
        switch result {
        case .some(let data): entity = data
        default: entity = CryptoAssetEntity(context: viewContext)
        }
        entity.mapFromDomain(item: asset)
        
        // save
        do {
            try viewContext.save()
            return .just(asset)
        } catch {
            return .fail(with: error)
        }
    }
    
    
    
    // MARK: - Helpers
    private func fetchRequestForCryptoListEntity() -> NSFetchRequest<CryptoAssetEntity> {
        let fetchRequest = CryptoAssetEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
    
    private func fetchRequestForCryptoEntity(id: String) -> NSFetchRequest<CryptoAssetEntity> {
        let fetchRequest = CryptoAssetEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        return fetchRequest
    }
    
    
    
    private func fetchRequestForCryptoExchangeRateEntity(id: String) -> NSFetchRequest<CryptoExchangeRateEntity> {
        let fetchRequest = CryptoExchangeRateEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        return fetchRequest
    }
}
