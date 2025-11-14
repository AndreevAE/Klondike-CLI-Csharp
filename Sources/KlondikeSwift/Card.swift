import Foundation

class Card {
    // Color, Rank, Suite, Type
    private var CRST: Int
    private var _isOpened: Bool = false

    init(_ val: Int) {
        self.CRST = val
    }

    func isOpened() -> Bool {
        return _isOpened
    }

    var Type: CardType {
        return CardType(rawValue: CRST)!
    }

    var Suite: CardSuite {
        if CRST < 13 {
            return .Hearts
        }
        if CRST < 26 {
            return .Diamonds
        }
        if CRST < 39 {
            return .Clubs
        }
        return .Spades
    }

    var Color: CardColor {
        if CRST < 26 {
            return .Red
        }
        return .Black
    }

    var Rank: CardRank {
        return CardRank(rawValue: CRST % 13)!
    }

    // Накладываем в поле
    func PutField(_ downCard: Card) -> Bool {
        if self.Color == downCard.Color {
            return false
        }

        if self.Rank.rawValue == (downCard.Rank.rawValue - 1) {
            return true
        }

        return false
    }

    // Накладываем в результат
    func PutStack(_ downCard: Card?) -> Bool {
        if downCard == nil {
            if self.Rank != CardRank.Ace {
                return false
            } else {
                return true
            }
        }

        if self.Suite != downCard!.Suite {
            return false
        }

        if self.Rank.rawValue == (downCard!.Rank.rawValue + 1) {
            return true
        }

        return false
    }

    // Переворачиваем
    func OpenCard() {
        _isOpened = true
    }

    func CloseCard() {
        _isOpened = false
    }
}
