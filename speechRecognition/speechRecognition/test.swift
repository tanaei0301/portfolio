import Foundation

class TestClass{
    let documentPath = try! FileManager().url(for: .documentDirectory,in: .userDomainMask,appropriateFor: nil, create: false)
}
