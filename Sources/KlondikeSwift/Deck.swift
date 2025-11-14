import Foundation

class Deck {
    private var _cards: [Card] = []

    init() {
        for i in 0..<52 {
            let card = Card(i)
            _cards.append(card)
        }
    }

    func Shuffle() {
        _cards.shuffle()
    }

    func Pop() -> Card {
        let card = _cards.last!
        _cards.removeLast()
        return card
    }
}
