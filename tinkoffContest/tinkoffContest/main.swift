//
//  main.swift
//  tinkoffContest
//
//  Created by Егор Шкарин on 04.04.2022.
//

import Foundation

final class Cache<Key: Hashable, Value> {
    //Наш кеш
    private let wrapped = NSCache<WrappedKey, Entry>()
    // Замыкание, которое формирует дату при инициалицации кеша. По умолчанию текущая дата
    private let dateProvider: () -> Date
    // Интервал через которых кеш удаляется
    private let entryLifetime: TimeInterval
    // ???
    private let keyTracker = KeyTracker()
    
    init(dateProvider: @escaping () -> Date = Date.init,
         entryLifetime: TimeInterval = 12 * 60 * 60,
         maximumEntryCount: Int = 50) {
        //Добавляем время от которого отсчитывается жизненный цикл значения
        self.dateProvider = dateProvider
        // Время жизни значения
        self.entryLifetime = entryLifetime
        // Максимальное число записей
        wrapped.countLimit = maximumEntryCount
        // Делегат кеша
        wrapped.delegate = keyTracker
        
    }
    
    /// Функция вставки значения в кеш
    /// - value - Значние
    /// - key - ключ
    func insert(_ value: Value, forKey key: Key) {
        // Добавляем временной интервал к дате, которую указали в инициализаторе
        let date = dateProvider().addingTimeInterval(entryLifetime)
        // Создаем значение для кеша
        let entry = Entry(value: value, key: key, expirationDate: date)
        // Кладем значение в кеш по задонному ключу Key
        insert(entry)
    }
    
    /// Функция получения значения из кеша
    /// - key - ключ
    func value(forKey key: Key) -> Value? {
        // Получаем значение по ключу, если его нет возвращаем nil
        guard let entry = wrapped.object(forKey: WrappedKey(key)) else {
            return nil
        }
        // Сравниваем текущее время и время которе указано для значение
        // Если меньше то все ок, возвращаем значение, если больше то удаляем значение по ключу
        // и возвращаем nil
        guard dateProvider() < entry.expirationDate else {
            removeValue(forKey: key)
            return nil
        }
        return entry.value
    }
    /// Функция удаления значения из кеша
    /// - key - ключ
    func removeValue(forKey key: Key) {
        // Удаляем значение по ключу
        wrapped.removeObject(forKey: WrappedKey(key))
    }
}

private extension Cache {
    /// Класс для значний ключа в кеше
    // Наследуется от NSObject из за требований NSCache
    final class WrappedKey: NSObject {
        // Сам ключ, долже быть Hashable, так как он должен быть уникальным
        let key: Key
        
        init(_ key: Key) { self.key = key }
        
        override var hash: Int { return key.hashValue }
        // Эта перегрузка нудна чтобы мы могли сравнивать два значения по ключу
        override func isEqual(_ object: Any?) -> Bool {
            guard let value = object as? WrappedKey else {
                return false
            }
            return value.key == key
        }
    }
}
extension Cache {
    /// Класс для значения в кеше.
    /// Хранить может что угодно
    final class Entry {
        // Ключ для значения в кеше
        let key: Key
        // Само значение
        let value: Value
        // Дата для удаление из кеша
        let expirationDate: Date
        
        init(value: Value, key: Key, expirationDate: Date) {
            self.key = key
            self.value = value
            self.expirationDate = expirationDate
        }
    }
}

extension Cache {
    /// Сабскрипт для обращению к кешу в виде: cache[key]
    /// и такого же получения из него данных
    subscript(key: Key) -> Value? {
        get { return value(forKey: key)}
        set {
            guard let value = newValue else {
                removeValue(forKey: key)
                return
            }
            self.insert(value, forKey: key)
        }
    }
}

private extension Cache {
    // Класс для отслеживания клбючей значений
    // Он нужен для хранения значений в памяти устройтва, так как обычный кеш хранит все в оперативной памяти и при завершении приложения все чистит
    final class KeyTracker: NSObject, NSCacheDelegate {
        // массив ключей значений
        var keys = Set<Key>()
        // Функция, которая уведомляет NSCache каждый раз, когда что то было удалено из него
        func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
            guard let entry = obj as? Entry else {
                return
            }
            keys.remove(entry.key)
        }
    }
}

extension Cache.Entry: Codable where Key: Codable, Value: Codable {}
extension Cache {
    //Эти методы нужны для того, чтобы делать вставку и удаление при кодировании и декодировании
    private func entry(forKey key: Key) -> Entry? {
        guard let entry = wrapped.object(forKey: WrappedKey(key)) else {
            return nil
        }
        
        guard dateProvider() < entry.expirationDate else {
            removeValue(forKey: key)
            return nil
        }
        
        return entry
    }
    
    private func insert(_ entry: Entry) {
        wrapped.setObject(entry, forKey: WrappedKey(entry.key))
        // Добаляем новый ключ в множество ключей в keyTraker
        keyTracker.keys.insert(entry.key)
    }
}
// Это расширение нужно для кодирования и декодирования занчений и ключей кеша
extension Cache: Codable where Key: Codable, Value: Codable {
    // Инициализатор для декодирования
    convenience init(from decoder: Decoder) throws {
        self.init()
        // Создание контенера для значений
        let container = try decoder.singleValueContainer()
        //        декодирование в массив [Entry]
        let entries = try container.decode([Entry].self)
        //        добавление в кеш значений
        entries.forEach(insert)
    }
    // Функция для кодирования
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(keyTracker.keys.compactMap(entry))
    }
}

extension Cache where Key: Codable, Value: Codable {
    func saveToDisk(
        withName name: String,
        using fileManager: FileManager = .default
    ) throws {
        let folderURLs = fileManager.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        )
        
        let fileURL = folderURLs[0].appendingPathComponent(name + ".cache")
        let data = try JSONEncoder().encode(self)
        try data.write(to: fileURL)
    }
    func readFromDisk(
        withName name: String,
        using fileManager: FileManager = .default
    ) throws -> [Entry] {
        let folderURLs = fileManager.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        )
        
        let fileURL = folderURLs[0].appendingPathComponent(name + ".cache")
        let decoder = JSONDecoder()
        let data = try Data(contentsOf: fileURL)
        if let entries = try? decoder.decode([Entry].self, from: data) {
            return entries
        } else {
            return []
        }
    }
}
//MARK: - Usage
struct SomeData: Codable {
    let id: String
    let data: String
}
struct AnotherData: Codable {
    let id: String
    let data: String
}
let anotherData1 = AnotherData(id: "anotherData1", data: "anotherData1")
let anotherData2 = AnotherData(id: "anotherData2", data: "anotherData2")
let anotherData3 = AnotherData(id: "anotherData3", data: "anotherData4")
let anotherData4 = AnotherData(id: "anotherData4", data: "anotherData5")
let anotherData5 = AnotherData(id: "anotherData5", data: "anotherData6")
let anotherData6 = AnotherData(id: "anotherData6", data: "anotherData7")

let data1 = SomeData(id: "key1", data: "value1")
let data2 = SomeData(id: "key2", data: "value2")
let data3 = SomeData(id: "key3", data: "value3")
let data4 = SomeData(id: "key4", data: "value4")
let data5 = SomeData(id: "key5", data: "value5")
let data6 = SomeData(id: "key6", data: "value6")

let cache = Cache<String, SomeData>()
let cache2 = Cache<String, AnotherData>()

cache2.insert(anotherData1, forKey: anotherData1.id)
cache2.insert(anotherData2, forKey: anotherData2.id)
cache2.insert(anotherData3, forKey: anotherData3.id)
cache2.insert(anotherData4, forKey: anotherData4.id)
cache2.insert(anotherData5, forKey: anotherData5.id)
cache2.insert(anotherData6, forKey: anotherData6.id)

cache2.removeValue(forKey: "anotherData4")

cache.insert(data1, forKey: data1.id)
cache.insert(data2, forKey: data2.id)
cache.insert(data3, forKey: data3.id)
cache.insert(data4, forKey: data4.id)
cache.insert(data5, forKey: data5.id)
cache.insert(data6, forKey: data6.id)
do {
    try cache2.saveToDisk(withName: String(describing: AnotherData.self), using: .default)
} catch {
    print("Sometihk wrong")
}

do {
    let entries = try cache.readFromDisk(withName: String(describing: SomeData.self), using: .default)
    entries.forEach { elem in
        print(elem.value.data)
    }
} catch {
    print("Sometihk wrong")
}

do {
    let entries = try cache2.readFromDisk(withName: String(describing: AnotherData.self), using: .default)
    entries.forEach { elem in
        print(elem.value.data)
    }
} catch {
    print("Sometihk wrong")
}
