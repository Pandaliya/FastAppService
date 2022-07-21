# 使用CoreData和CloudKit

[参考iCloud系列](https://www.fatbobman.com/posts/coreDataWithCloudKit-2/)

### CloudKit中的一些概念

**Container**

在添加任何数据之前，我们需要一个Container也就是官方术语中的容器来保存数据记录，也就是Record。 
Container在官方术语中是服务器上所有应用程序数据概念位置。目前有三种，Public，Private和Share。

Public：公有数据，同一个App中所有用户都能访问的数据存储区域。
Private：用户的隐私数据，只有用户iCloud账户授权的设备才能访问。
Share：可分享的数据，用于用户之间数据分享。



### 为已有项目添加CoreData

1. 首先创建一个Data Model文件

2. 在AppDelegate中添加CoreData相关代码

```swift
// AppDelegate.swift
// MARK: - Core Data
lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "hangge_1841")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        if let error = error as NSError? {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    })
    return container
}()
```

3. 创建一个管理类

```Swift
let CDM = CoreDataManager.share
class CoreDataManager: NSObject {
    static let share = CoreDataManager()
    
    // MARK: - Analysis
    func recordError(error: NSError) {
        debugPrint("record error:", error)
    }
}

### 遇到的问题？

如何删除iCloud Container
