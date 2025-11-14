# Klondike Swift CLI

Swift port of the Klondike Solitaire command-line game, preserving all logic and naming conventions from the original C# version.

## Requirements

- Swift 5.5 or later
- macOS 10.15+ or Linux with Swift installed

## Building and Running

### Using Swift Package Manager

```bash
# Build the project
swift build

# Run the game
swift run KlondikeSwift

# Or run the executable directly after building
.build/debug/KlondikeSwift
```

### Building a Release Version

```bash
swift build -c release
.build/release/KlondikeSwift
```

## Project Structure

```
Sources/KlondikeSwift/
├── main.swift          # Main game loop and logic
├── Card.swift          # Card class with game rules
├── Deck.swift          # Deck class with shuffle functionality
└── CardEnums.swift     # Enumerations for card properties
```

## Gameplay

Same as the C# version - see CLAUDE.md for complete game rules and commands.

### Quick Start

- Type `#` to draw a card from the stock
- Type card names (e.g., `HA`, `D10`, `SK`) to move cards
- Type `<CARD> <CARD>` to move between tableau piles (e.g., `H5 D6`)
- Type `<CARD> X` to move a King to an empty tableau spot

## Key Differences from C# Version

### Swift-Specific Changes

1. **Array Handling**: In Swift, arrays are value types. Implemented `CardLocation` enum to properly track and modify card locations.

2. **String Parsing**: Added custom `init?(string:)` to `CardType` enum for parsing card names from user input.

3. **Screen Clearing**: Uses newline repetition instead of `Console.Clear()` for cross-platform compatibility.

4. **Input Handling**: Uses `readLine()` instead of `Console.ReadLine()`.

### Preserved from C# Version

- All variable names (HeartsCards, Tables, StockCards, etc.)
- All function names (StartGame, DrawConsolingGaming, HandleInput, etc.)
- Game logic and rules
- Display format and symbols

## Implementation Notes

The Swift version maintains functional parity with the C# version while adapting to Swift's type system:

- **CardLocation enum**: Tracks where cards are located (Hearts, Diamonds, Clubs, Spades, Table(Int), Unused)
- **Helper functions**:
  - `getArray(_:)` - Retrieves array for a location
  - `removeLastCard(from:)` - Removes and reveals next card
  - `addCards(to:cards:)` - Adds cards to a location
  - `ShiftWithCardOut(from:cardOut:to:)` - Moves multiple cards
  - `ShiftSimple(from:to:)` - Moves single card

## Development Status

- ✅ Core game logic ported
- ✅ All card movement rules implemented
- ✅ Input parsing and validation
- ✅ Display rendering
- ⏳ Testing in progress
- 📋 Future: Unit tests, refactoring, improvements

## License

Same as original project - see LICENSE file.
