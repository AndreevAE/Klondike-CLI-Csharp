import Foundation

enum CardSuite {
    case Hearts
    case Diamonds
    case Clubs
    case Spades
}

enum CardRank: Int {
    case Ace = 0
    case Two
    case Three
    case Four
    case Five
    case Six
    case Seven
    case Eight
    case Nine
    case Ten
    case Jack
    case Queen
    case King
}

enum CardColor {
    case Black
    case Red
}

enum CardType: Int, CaseIterable {
    // Hearts
    case HA = 0
    case H2
    case H3
    case H4
    case H5
    case H6
    case H7
    case H8
    case H9
    case H10
    case HJ
    case HQ
    case HK

    // Diamonds
    case DA
    case D2
    case D3
    case D4
    case D5
    case D6
    case D7
    case D8
    case D9
    case D10
    case DJ
    case DQ
    case DK

    // Clubs
    case CA
    case C2
    case C3
    case C4
    case C5
    case C6
    case C7
    case C8
    case C9
    case C10
    case CJ
    case CQ
    case CK

    // Spades
    case SA
    case S2
    case S3
    case S4
    case S5
    case S6
    case S7
    case S8
    case S9
    case S10
    case SJ
    case SQ
    case SK

    init?(string: String) {
        guard let match = CardType.allCases.first(where: { String(describing: $0) == string }) else {
            return nil
        }
        self = match
    }
}
