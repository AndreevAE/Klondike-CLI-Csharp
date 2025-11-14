import Foundation

var HeartsCards: [Card] = []
var DiamondsCards: [Card] = []
var ClubsCards: [Card] = []
var SpadesCards: [Card] = []

var Table1Cards: [Card] = []
var Table2Cards: [Card] = []
var Table3Cards: [Card] = []
var Table4Cards: [Card] = []
var Table5Cards: [Card] = []
var Table6Cards: [Card] = []
var Table7Cards: [Card] = []

var Tables: [[Card]] = []

var StockCards: [Card] = []
var UnusedCards: [Card] = []

let closed = "[#]"
let ex = " x "
let open = "[ ]"
let tabulat = "\t"
let perenos = "\n"

enum CardLocation {
    case Hearts
    case Diamonds
    case Clubs
    case Spades
    case Table(Int)
    case Unused
    case NotFound
}

func StartGame() {
    let deck = Deck()
    deck.Shuffle()

    Tables.append(Table1Cards)
    Tables.append(Table2Cards)
    Tables.append(Table3Cards)
    Tables.append(Table4Cards)
    Tables.append(Table5Cards)
    Tables.append(Table6Cards)
    Tables.append(Table7Cards)

    for i in 0..<7 {
        for _ in 0...i {
            Tables[i].append(deck.Pop())
        }
    }

    for i in 0..<7 {
        Tables[i].last!.OpenCard()
    }

    for _ in 0..<24 {
        StockCards.append(deck.Pop())
    }
}

func DrawConsolingGaming() {
    // CLEAR SCREEN
    print("Klondike")

    // Stock + Unused + 4Stack
    DrawSYUKA(StockCards)
    DrawSYUKA(UnusedCards)
    print(tabulat, terminator: "")
    DrawSYUKA(HeartsCards)
    DrawSYUKA(DiamondsCards)
    DrawSYUKA(ClubsCards)
    DrawSYUKA(SpadesCards)
    print()
    print()

    // Table
    let RowCount = MaxCount()
    for j in 0..<RowCount {
        for i in 0..<7 {
            if Tables[i].count <= j {
                print(ex + tabulat, terminator: "")
            } else {
                if Tables[i][j].isOpened() {
                    print(String(describing: Tables[i][j].Type) + tabulat, terminator: "")
                } else {
                    print(closed + tabulat, terminator: "")
                }
            }
        }
        print()
    }
}

func DrawSYUKA(_ list: [Card]) {
    if list.count == 0 {
        print(open + tabulat, terminator: "")
    } else {
        if list.last!.isOpened() {
            print(String(describing: list.last!.Type) + tabulat, terminator: "")
        } else {
            print(closed + tabulat, terminator: "")
        }
    }
}

func HandleInput() {
    guard let input = readLine()?.uppercased() else {
        return
    }

    // Clear screen in Swift/Linux - print multiple newlines
    print(String(repeating: "\n", count: 50))

    if input == "" {
        return
    }

    if input == "#" {
        StockManipulate()
        return
    }

    let inputArray = input.split(separator: " ").map { String($0) }

    // from table or unused or stack to table
    if inputArray.count == 2 {
        guard let CardTypeFrom = CardType(string: inputArray[0]) else {
            print("WROONG!!")
            return
        }

        let CardOut = Card(CardTypeFrom.rawValue)
        CardOut.OpenCard()

        var fromLocation = CardLocation.NotFound
        fromLocation = FindInUnused(CardOut)
        if fromLocation == .NotFound {
            fromLocation = FindInTables(CardOut)
        }
        if fromLocation == .NotFound {
            fromLocation = FindInStack(CardOut)
        }
        if fromLocation == .NotFound {
            print("Wrong Card!")
            return
        }

        if inputArray[1] == "X" {
            if CardOut.Rank != CardRank.King {
                print("Wrong Card!")
                return
            }
            for i in 0..<7 {
                if Tables[i].count == 0 {
                    ShiftWithCardOut(from: fromLocation, cardOut: CardOut, to: .Table(i))
                    return
                }
            }
            print("Wrong Card!")
            return
        } else {
            guard let CardTypeTo = CardType(string: inputArray[1]) else {
                print("WROONG!!")
                return
            }

            let CardIn = Card(CardTypeTo.rawValue)
            CardIn.OpenCard()

            var toLocation = CardLocation.NotFound
            toLocation = FindInStack(CardIn)
            if toLocation != .NotFound {
                print("Wrong Card!")
                return
            }
            toLocation = FindInTables(CardIn)
            if toLocation == .NotFound {
                print("Wrong Card!")
                return
            }

            let toArray = getArray(toLocation)
            if CardOut.PutField(toArray.last!) {
                ShiftWithCardOut(from: fromLocation, cardOut: CardOut, to: toLocation)
            } else {
                print("Wrong Card!")
            }
        }
    }

    // from table or unused to stack
    if inputArray.count == 1 {
        guard let ct = CardType(string: inputArray[0]) else {
            print("WRONG!!!")
            return
        }

        let cardToStack = Card(ct.rawValue)
        var fromLocation = CardLocation.NotFound
        fromLocation = FindInUnused(cardToStack)
        if fromLocation == .NotFound {
            fromLocation = FindInTables(cardToStack)
        }
        if fromLocation == .NotFound {
            print("Wrong Card!")
            return
        }

        // card to suitable stack
        switch cardToStack.Suite {
        case .Hearts:
            if HeartsCards.count == 0 {
                if cardToStack.Type == CardType.HA {
                    ShiftSimple(from: fromLocation, to: .Hearts)
                }
            } else if cardToStack.PutStack(HeartsCards.last!) {
                ShiftSimple(from: fromLocation, to: .Hearts)
            }
        case .Diamonds:
            if DiamondsCards.count == 0 {
                if cardToStack.Type == CardType.DA {
                    ShiftSimple(from: fromLocation, to: .Diamonds)
                }
            } else if cardToStack.PutStack(DiamondsCards.last!) {
                ShiftSimple(from: fromLocation, to: .Diamonds)
            }
        case .Clubs:
            if ClubsCards.count == 0 {
                if cardToStack.Type == CardType.CA {
                    ShiftSimple(from: fromLocation, to: .Clubs)
                }
            } else if cardToStack.PutStack(ClubsCards.last!) {
                ShiftSimple(from: fromLocation, to: .Clubs)
            }
        case .Spades:
            if SpadesCards.count == 0 {
                if cardToStack.Type == CardType.SA {
                    ShiftSimple(from: fromLocation, to: .Spades)
                }
            } else if cardToStack.PutStack(SpadesCards.last!) {
                ShiftSimple(from: fromLocation, to: .Spades)
            }
        }
    }
}

func getArray(_ location: CardLocation) -> [Card] {
    switch location {
    case .Hearts:
        return HeartsCards
    case .Diamonds:
        return DiamondsCards
    case .Clubs:
        return ClubsCards
    case .Spades:
        return SpadesCards
    case .Table(let index):
        return Tables[index]
    case .Unused:
        return UnusedCards
    case .NotFound:
        return []
    }
}

func removeCards(from location: CardLocation, cardOut: Card) {
    switch location {
    case .Hearts:
        HeartsCards.removeLast()
    case .Diamonds:
        DiamondsCards.removeLast()
    case .Clubs:
        ClubsCards.removeLast()
    case .Spades:
        SpadesCards.removeLast()
    case .Table(let index):
        var indexFrom = 0
        for i in 0..<Tables[index].count {
            if Tables[index][i].Type == cardOut.Type {
                indexFrom = i
                break
            }
        }
        while Tables[index].count != indexFrom {
            Tables[index].remove(at: indexFrom)
        }
        if Tables[index].count != 0 {
            Tables[index].last!.OpenCard()
        }
    case .Unused:
        UnusedCards.removeLast()
    case .NotFound:
        break
    }
}

func removeLastCard(from location: CardLocation) {
    switch location {
    case .Hearts:
        HeartsCards.removeLast()
        if HeartsCards.count != 0 {
            HeartsCards.last!.OpenCard()
        }
    case .Diamonds:
        DiamondsCards.removeLast()
        if DiamondsCards.count != 0 {
            DiamondsCards.last!.OpenCard()
        }
    case .Clubs:
        ClubsCards.removeLast()
        if ClubsCards.count != 0 {
            ClubsCards.last!.OpenCard()
        }
    case .Spades:
        SpadesCards.removeLast()
        if SpadesCards.count != 0 {
            SpadesCards.last!.OpenCard()
        }
    case .Table(let index):
        Tables[index].removeLast()
        if Tables[index].count != 0 {
            Tables[index].last!.OpenCard()
        }
    case .Unused:
        UnusedCards.removeLast()
        if UnusedCards.count != 0 {
            UnusedCards.last!.OpenCard()
        }
    case .NotFound:
        break
    }
}

func addCards(to location: CardLocation, cards: [Card]) {
    switch location {
    case .Hearts:
        HeartsCards.append(contentsOf: cards)
    case .Diamonds:
        DiamondsCards.append(contentsOf: cards)
    case .Clubs:
        ClubsCards.append(contentsOf: cards)
    case .Spades:
        SpadesCards.append(contentsOf: cards)
    case .Table(let index):
        Tables[index].append(contentsOf: cards)
    case .Unused:
        UnusedCards.append(contentsOf: cards)
    case .NotFound:
        break
    }
}

func ShiftWithCardOut(from: CardLocation, cardOut: Card, to: CardLocation) {
    let fromArray = getArray(from)
    var indexFrom = 0

    for i in 0..<fromArray.count {
        if fromArray[i].Type == cardOut.Type {
            indexFrom = i
            break
        }
    }

    let cardsToMove = Array(fromArray[indexFrom...])

    // Remove cards from source
    switch from {
    case .Table(let index):
        Tables[index].removeSubrange(indexFrom...)
        if Tables[index].count != 0 {
            Tables[index].last!.OpenCard()
        }
    case .Unused:
        UnusedCards.removeSubrange(indexFrom...)
        if UnusedCards.count != 0 {
            UnusedCards.last!.OpenCard()
        }
    default:
        break
    }

    // Add cards to destination
    addCards(to: to, cards: cardsToMove)
}

func StockManipulate() {
    if StockCards.count == 0 {
        while UnusedCards.count != 0 {
            let card = UnusedCards.last!
            UnusedCards.removeLast()
            card.CloseCard()
            StockCards.append(card)
        }
    } else {
        let card = StockCards.last!
        StockCards.removeLast()
        card.OpenCard()
        UnusedCards.append(card)
    }
}

func ShiftSimple(from: CardLocation, to: CardLocation) {
    let fromArray = getArray(from)
    let card = fromArray.last!

    removeLastCard(from: from)
    addCards(to: to, cards: [card])
}

func FindInStack(_ card: Card) -> CardLocation {
    if HeartsCards.count != 0 {
        if HeartsCards.last!.Type == card.Type {
            return .Hearts
        }
    }

    if DiamondsCards.count != 0 {
        if DiamondsCards.last!.Type == card.Type {
            return .Diamonds
        }
    }

    if ClubsCards.count != 0 {
        if ClubsCards.last!.Type == card.Type {
            return .Clubs
        }
    }

    if SpadesCards.count != 0 {
        if SpadesCards.last!.Type == card.Type {
            return .Spades
        }
    }

    return .NotFound
}

func FindInUnused(_ card: Card) -> CardLocation {
    if UnusedCards.count == 0 {
        return .NotFound
    }

    if UnusedCards.last!.Type == card.Type {
        return .Unused
    }

    return .NotFound
}

func FindInTables(_ card: Card) -> CardLocation {
    for i in 0..<7 {
        for j in stride(from: Tables[i].count - 1, through: 0, by: -1) {
            if !Tables[i][j].isOpened() {
                break
            }
            if Tables[i][j].Type == card.Type {
                return .Table(i)
            }
        }
    }

    return .NotFound
}

func MaxCount() -> Int {
    var MaxCount = 0
    for i in 0..<7 {
        if MaxCount < Tables[i].count {
            MaxCount = Tables[i].count
        }
    }
    return MaxCount
}

// MAIN
StartGame()

// CYCLE
while true {
    DrawConsolingGaming()
    HandleInput()
}
