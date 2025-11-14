# Klondike CLI C#

## Project Overview
This is a command-line implementation of the classic Klondike Solitaire card game written in C#. The game runs entirely in the console and was developed and tested in Visual Studio 2015.

## Project Structure

```
KlondikeTest/
├── Program.cs          # Main game logic and game loop
├── Card.cs            # Card class with game rules
├── Deck.cs            # Deck class with shuffle functionality
├── CardEnums.cs       # Enumerations for card properties
└── Properties/
    └── AssemblyInfo.cs
```

## Core Components

### Card.cs
- Represents a single playing card
- Properties:
  - `Type` - CardType enum (e.g., HA, D10, SK)
  - `Suite` - Hearts, Diamonds, Clubs, or Spades
  - `Color` - Red or Black
  - `Rank` - Ace through King
- Key methods:
  - `PutField(Card)` - Validates if card can be placed on field (alternating colors, descending rank)
  - `PutStack(Card)` - Validates if card can be placed on foundation (same suit, ascending rank)
  - `OpenCard()` / `CloseCard()` - Controls card visibility

### Deck.cs
- Creates a standard 52-card deck
- `Shuffle()` - Randomizes card order
- `Pop()` - Removes and returns the last card

### CardEnums.cs
Defines enumerations:
- `CardSuite` - Hearts, Diamonds, Clubs, Spades
- `CardRank` - Ace through King (0-12)
- `CardColor` - Black, Red
- `CardType` - All 52 card types (HA, H2, ..., SK)

### Program.cs
Main game implementation with:
- **7 Tableau piles** (Table1Cards - Table7Cards)
- **4 Foundation piles** (HeartsCards, DiamondsCards, ClubsCards, SpadesCards)
- **Stock pile** (StockCards) - Face-down cards to draw from
- **Waste pile** (UnusedCards) - Face-up drawn cards

## Game Rules

### Setup
1. Deal cards to 7 tableau piles (1, 2, 3, 4, 5, 6, 7 cards respectively)
2. Top card of each pile is face-up
3. Remaining 24 cards form the stock

### Gameplay Commands
- `#` - Draw a card from stock to waste
- `<CARD>` - Move card to foundation (e.g., `HA`)
- `<CARD> <CARD>` - Move card to tableau (e.g., `H5 D6`)
- `<CARD> X` - Move King to empty tableau spot

### Valid Moves
**To Tableau:**
- Card must be opposite color
- Card must be one rank lower (e.g., Red 6 on Black 7)
- Kings can only go on empty spaces

**To Foundation:**
- Must start with Ace
- Must be same suit
- Must be next rank in sequence

### Display Format
- `[#]` - Face-down card
- `[ ]` - Empty slot
- ` x ` - No card in this row
- `HA`, `D10`, `SK`, etc. - Face-up cards

## Technical Details

- **Language:** C# (.NET Framework)
- **Target:** Console Application
- **IDE:** Visual Studio 2015
- **Game Loop:** Infinite while loop with console input
- **Screen Management:** Uses `Console.Clear()` to refresh display

## Code Organization

### Game State
All game state is stored in static lists at the program level:
- 4 foundation piles (one per suit)
- 7 tableau piles
- 1 stock pile
- 1 waste pile

### Input Handling
`HandleInput()` parses commands:
1. Single card name → Move to foundation
2. Two card names → Move between tableau piles
3. `#` → Draw from stock
4. Card name + `X` → Move King to empty tableau

### Card Movement
`Shift()` methods handle card transfers:
- Validates moves using Card.PutField() and Card.PutStack()
- Moves cards between lists
- Automatically reveals cards when moved

## Development Notes

- Uses enum parsing for card input validation
- Card representation uses integer encoding (0-51)
- Suite/rank calculated from integer value
- No win condition check implemented
- No undo functionality
- Single card draw from stock (not three-card variant)
