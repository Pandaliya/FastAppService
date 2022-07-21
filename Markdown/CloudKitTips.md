#  CloudKit知识点

## CloudKit的数据组织结构

CloudKit通过以下类的层次结构组织数据：CKContainer, CKDatabase, CKRecordZone和CKRecord。

1. 顶层是CKContainer, 它封装了一组相关的CloudKit数据
2. 每个CKContainer中都有CKDatabase的多个实例
3. 在CKDatabase中是CKRecordZones, 在CKRecordZones中的CKRecords中。你可以读写记录, 查询与一组条件匹配的记录, 
并且(最重要的是)可以收到上述任何更改的通知。

**CKRecordZone**

只有私有数据库才能创建自定义CKRecordZone。只有自定义的Zone，才能用于共享（sharedCloudDatabase）！
自定义Zone对数据的处理更有效，毕竟不用搜索整个数据库！而且支持更多功能，比如：原子操作，订阅，共享等


## 操作

Apple在CloudKit SDK中提供了两个级别的功能：高级的”便利”功能, 例如fetch(), save()和delete(), 
以及具有繁琐名称的较低级别的操作构造, 例如CKModifyRecordsOperation。

## 订阅

订阅是CloudKit最有价值的功能之一。它们建立在Apple的通知基础结构上, 以**允许各种客户端在发生某些CloudKit更改时获得推送通知**。
这些可以是iOS用户熟悉的普通推送通知(例如声音, 横幅或徽章), 或者在CloudKit中, 它们可以是称为静音推送的特殊通知类。
这些**无声推送完全是在没有用户可见性或交互作用的情况下发生的, 因此, 不需要用户为你的应用启用推送通知**, 
从而避免了你成为应用开发者时可能遇到的许多用户体验难题。


## DOC tips

After you promote your schema to production, the record types and their fields are immutable and exist for all time. 
You can add new record types, and additional fields to existing record types, 
but **you can’t modify or delete existing record types**.
