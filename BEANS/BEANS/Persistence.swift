//
//  Persistence.swift
//  BEANS
//
//  Created by Brian Liew on 9/20/22.
//

import CoreData
import SwiftUI

struct PersistenceController {
    @Environment(\.managedObjectContext) private var viewContext
    
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "BEANS")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func save(viewContext: NSManagedObjectContext) -> Void {
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    // MARK: - ACCUMULATOR TASK
    
    func addAccumulatorTask(name: String, color: String, progress: Double, viewContext: NSManagedObjectContext) -> Void {
        let task = AccumulatorTask(context: viewContext)
        task.id = UUID()
        task.birth = Date.now
        task.name = name
        task.color = color
        task.progress = progress
        
        save(viewContext: viewContext)
    }
    
    func editAccumulatorTask(task: AccumulatorTask, name: String, progress: Double, viewContext: NSManagedObjectContext) -> Void {
        task.name = name
        task.progress = progress
        
        save(viewContext: viewContext)
    }
    
    func deleteAccumulatorTask(offsets: IndexSet, tasks: FetchedResults<AccumulatorTask>, viewContext: NSManagedObjectContext) {
        offsets.map { tasks[$0] }.forEach(viewContext.delete)
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    // MARK: - PERCENTAGE TASK
    
    func addPercentageTask(name: String, color: String, progress: Double, goal: Double, viewContext: NSManagedObjectContext) -> Void {
        let task = PercentageTask(context: viewContext)
        task.id = UUID()
        task.birth = Date.now
        task.name = name
        task.color = color
        task.progress = progress
        task.goal = goal
        
        save(viewContext: viewContext)
    }
    
    func editPercentageTask(task: PercentageTask, name: String, progress: Double, viewContext: NSManagedObjectContext) -> Void {
        task.name = name
        task.progress = progress
        
        save(viewContext: viewContext)
    }
    
    func deletePercentageTask(offsets: IndexSet, tasks: FetchedResults<PercentageTask>, viewContext: NSManagedObjectContext) {
        offsets.map { tasks[$0] }.forEach(viewContext.delete)
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    // MARK: - TIMED TASK
    
    func addTimedTask(name: String, color: String, viewContext: NSManagedObjectContext) -> Void {
        let task = TimedTask(context: viewContext)
        task.id = UUID()
        task.birth = Date.now
        task.name = name
        task.color = color
        task.progress = 0
        
        save(viewContext: viewContext)
    }
    
    func editTimedTask(task: PercentageTask, name: String, viewContext: NSManagedObjectContext) -> Void {
        task.name = name
        
        save(viewContext: viewContext)
    }
    
    func deleteTimedTask(offsets: IndexSet, tasks: FetchedResults<TimedTask>, viewContext: NSManagedObjectContext) {
        offsets.map { tasks[$0] }.forEach(viewContext.delete)
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
}
