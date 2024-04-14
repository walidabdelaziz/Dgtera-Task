//
//  SQLiteDataManager.swift
//  Dgtera Task
//
//  Created by Walid Ahmed on 14/04/2024.
//

import Foundation
import SQLite

class SQLiteDataManager {
    static let shared = SQLiteDataManager()
    private let currentSchemaVersion = 4
    private var schemaVersion: Int {
        get {
            return UserDefaults.standard.integer(forKey: "schemaVersion")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "schemaVersion")
        }
    }
    private var db: Connection!
    private let productsTable = Table("products")
    private let orderItemsTable = Table("order_items")
    private let id = Expression<Int>("id")
    private let name = Expression<String>("name")
    private let lstPrice = Expression<Double>("lst_price")
    private let orderViewCount = Expression<Int?>("order_view_count")
    private let imageSmallBool = Expression<Bool?>("image_small_bool")
    private let imageSmallString = Expression<String?>("image_small_string")
    
    
    private init() {
        let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        do {
            db = try Connection("\(dbPath)/products.sqlite3")
            createTables()
            migrateIfNeeded()
        } catch {
            fatalError("Error opening database: \(error)")
        }
    }
    private func migrateIfNeeded() {
        if schemaVersion < currentSchemaVersion {
            schemaVersion = currentSchemaVersion
        }
    }
    private func createTables() {
        do {
            try db.run(productsTable.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(name)
                table.column(lstPrice)
                table.column(orderViewCount)
                table.column(imageSmallBool)
                table.column(imageSmallString)
            })
        } catch {
            fatalError("Error creating tables: \(error)")
        }
    }
    func saveProducts(_ products: [Products]) {
        for product in products {
            var imageSmallBoolValue: Bool?
            var imageSmallStringValue: String?
            
            switch product.imageSmall {
            case .bool(let boolValue):
                imageSmallBoolValue = boolValue
            case .string(let stringValue):
                imageSmallStringValue = stringValue
            case .none:
                break
            }
            
            let insertProduct = productsTable.insert(or: .replace,
                                                     id <- product.id ?? 0,
                                                     name <- product.displayName ?? "",
                                                     lstPrice <- product.lstPrice ?? 0,
                                                     orderViewCount <- product.orderViewCount ?? 0,
                                                     imageSmallBool <- imageSmallBoolValue,
                                                     imageSmallString <- imageSmallStringValue)
            do {
                try db.run(insertProduct)
            } catch {
                print("Error saving product to database: \(error)")
            }
        }
    }
    func getProducts() -> [Products] {
        var retrievedProducts = [Products]()
        do {
            for product in try db.prepare(productsTable) {
                var imageSmall: ImageSmall?
                if let boolValue = product[imageSmallBool] {
                    imageSmall = .bool(boolValue)
                } else if let stringValue = product[imageSmallString] {
                    imageSmall = .string(stringValue)
                }
                
                let retrievedProduct = Products(id: product[id],
                                                orderViewCount: product[orderViewCount],
                                                displayName: product[name],
                                                lstPrice: product[lstPrice],
                                                imageSmall: imageSmall)
                retrievedProducts.append(retrievedProduct)
            }
        } catch {
            print("Error retrieving products from database: \(error)")
        }
        return retrievedProducts
    }
}
