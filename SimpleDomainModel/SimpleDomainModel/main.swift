//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

open class TestMe {
  open func Please() -> String {
    return "I have been tested"
  }
}

////////////////////////////////////
// Money
//
public struct Money {
  public var amount : Int
  public var currency : String
  private let validMoney: [String] = ["USD", "GBP", "EUR", "CAN"]
  
  public func convert(_ to: String) -> Money {
    let convertRates: [String: Double] = ["USD": 1, "GBP": 0.5, "EUR": 1.5, "CAN": 1.25]
    if !validMoney.contains(to) {
        print("The only acceptable currencies are  USD, GBP (British pounds), EUR (Euro) and CAN (Canadian dollars)")
    }
    var convertResult: Int
    convertResult = Int((Double(self.amount) / convertRates[self.currency]!) * Double(convertRates[to]!))
    return Money(amount: convertResult, currency: to)
  }
  
    
  public func add(_ to: Money) -> Money {
    var selfMoney: Money = self
    if to.currency != self.currency {
        selfMoney = self.convert(to.currency)
    }
    return Money(amount: selfMoney.amount + to.amount, currency: to.currency)
  }
    
  public func subtract(_ from: Money) -> Money {
    var target: Money = from
    if from.currency != self.currency {
        target = from.convert(self.currency)
    }
    return Money(amount: self.amount - target.amount, currency: self.currency)
  }
}

////////////////////////////////////
// Job

open class Job {
  fileprivate var title : String
  fileprivate var type : JobType

  public enum JobType {
    case Hourly(Double)
    case Salary(Int)
  }

  public init(title : String, type : JobType) {
    self.title = title
    self.type = type
  }

  open func calculateIncome(_ hours: Int) -> Int {
    switch self.type {
    case JobType.Hourly(let num):
        return Int(hours * Int(num))
    case JobType.Salary(let num):
        return num
    }
  }
  
  open func raise(_ amt : Double) {
    switch self.type {
    case JobType.Hourly(let num):
        self.type = JobType.Hourly(num + amt)
    case JobType.Salary(let num):
        self.type = JobType.Salary(num + Int(amt))
    }
  }
}

//////////////////////////////////////
//// Person
////
open class Person {
  open var firstName : String = ""
  open var lastName : String = ""
  open var age : Int = 0

  fileprivate var _job : Job? = nil
  open var job : Job? {
    get {
        return _job
    }
    set(value) {
        if self.age >= 16 {
            self._job = value
        }
    }
  }

  fileprivate var _spouse : Person? = nil
  open var spouse : Person? {
    get {
        return _spouse
    }
    set(value) {
        if self.age >= 18 {
            self._spouse = value
        }
    }
  }

  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }

  open func toString() -> String {
    return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(String(describing: self._job)) spouse:\(String(describing: self._spouse))]"
  }
}

//////////////////////////////////////
//// Family
////
open class Family {
  fileprivate var members : [Person] = []

  public init(spouse1: Person, spouse2: Person) {
    if spouse1.spouse == nil && spouse2.spouse == nil {
        spouse2.spouse = spouse1
        spouse1.spouse = spouse2
        members += [spouse2, spouse1]
    } else {
        print("You are not allowed to married")
    }
  }

  open func haveChild(_ child: Person) -> Bool {
    if members[0].age > 21 || members[1].age > 21 {
        members.append(child)
        return true
    }
    return false
  }
  
  open func householdIncome() -> Int {
    var totalIncome = 0
    for member in members {
        if member._job != nil {
            switch member.job!.type {
            case .Salary(let num):
                totalIncome += num
            case .Hourly(let num):
                totalIncome += Int(num * 2000)
            }
        }
    }
    return totalIncome
  }
}





