using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace KlondikeTest
{
    class Program
    {
        static private List<Card> HeartsCards = new List<Card>();
        static private List<Card> DiamondsCards = new List<Card>();
        static private List<Card> ClubsCards = new List<Card>();
        static private List<Card> SpadesCards = new List<Card>();

        static private List<Card> Table1Cards = new List<Card>();
        static private List<Card> Table2Cards = new List<Card>();
        static private List<Card> Table3Cards = new List<Card>();
        static private List<Card> Table4Cards = new List<Card>();
        static private List<Card> Table5Cards = new List<Card>();
        static private List<Card> Table6Cards = new List<Card>();
        static private List<Card> Table7Cards = new List<Card>();

        static private List<List<Card>> Tables = new List<List<Card>>();

        static private List<Card> StockCards = new List<Card>();
        static private List<Card> UnusedCards = new List<Card>();
        
        const string closed = "[#]";
        const string ex = " x ";
        const string open = "[ ]";
        const string tabulat = "\t";
        const string perenos = "\n";

        static void Main(string[] args)
        {
            StartGame();

            // CYCLE
            while (true)
            {
                //Console.Clear();
                DrawConsolingGaming();
                HandleInput();
            }
        }

        static private void StartGame()
        {
            Deck deck = new KlondikeTest.Deck();
            deck.Shuffle();

            Tables.Add(Table1Cards);
            Tables.Add(Table2Cards);
            Tables.Add(Table3Cards);
            Tables.Add(Table4Cards);
            Tables.Add(Table5Cards);
            Tables.Add(Table6Cards);
            Tables.Add(Table7Cards);

            for (int i = 0; i < 7; i++)
            {
                for (int j = 0; j <= i; j++)
                {
                    Tables[i].Add(deck.Pop());
                }
            }
            
            for (int i = 0; i < 7; i++)
            {
                Tables[i].Last().OpenCard();
            }

            for (int i = 0; i < 24; i++)
            {
                StockCards.Add(deck.Pop());
            }
        }

        static private void DrawConsolingGaming()
        {

            // CLEAR SCREEN
            Console.Write("Klondike\n");
            
            // Stock + Unused + 4Stack
            DrawSYUKA(StockCards);
            DrawSYUKA(UnusedCards);
            Console.Write(tabulat);
            DrawSYUKA(HeartsCards);
            DrawSYUKA(DiamondsCards);
            DrawSYUKA(ClubsCards);
            DrawSYUKA(SpadesCards);
            Console.WriteLine();
            Console.WriteLine();

            // Table
            int RowCount = MaxCount();
            for (int j = 0; j < RowCount; j++)
            {
                for (int i = 0; i < 7; i++)
                {
                    if (Tables[i].Count <= j)
                    {
                        Console.Write(ex + tabulat);
                    }
                    else
                    {
                        if (Tables[i][j].isOpened())
                            Console.Write(Tables[i][j].Type.ToString() + tabulat);
                        else
                            Console.Write(closed + tabulat);
                    }
                }
                Console.WriteLine();
            }
            
            
        }

        static private void DrawSYUKA(List<Card> list)
        {
            if (list.Count == 0)
            {
                Console.Write(open + tabulat);
            }
            else
            {
                if (list.Last().isOpened())
                    Console.Write(list.Last().Type + tabulat);
                else
                    Console.Write(closed + tabulat);
            }
        }

        static private void HandleInput()
        {
            string input = Console.ReadLine().ToUpper();

            Console.Clear();
            
            if (input == "\n")
                return;

            if (input == "#")
            {
                StockManipulate();
                return;
            }

            string[] inputArray = input.Split(' ');
            
            // from table or unused or stack to table
            if (inputArray.Count() == 2)
            {
                CardType CardTypeFrom = new CardType();
                try
                {
                    CardTypeFrom = (CardType)Enum.Parse(typeof(CardType), inputArray[0]);
                }
                catch (Exception e)
                {
                    Console.WriteLine("WROONG!!");
                    return;
                }
                Card CardOut = new Card((int)CardTypeFrom);
                CardOut.OpenCard();

                List<Card> from = new List<Card>();
                from = FindInUnused(CardOut);
                if (from == null)
                {
                    from = FindInTables(CardOut);
                }
                if (from == null)
                {
                    from = FindInStack(CardOut);
                }
                if (from == null)
                {
                    Console.WriteLine("Wrong Card!");
                    return;
                }

                //////
                if (inputArray[1] == "X")
                {
                    if (CardOut.Rank != CardRank.King)
                    {
                        Console.WriteLine("Wrong Card!");
                        return;
                    }
                    for (int i = 0; i < 7; i++)
                    {
                        if (Tables[i].Count == 0)
                        {
                            Shift(from, CardOut, Tables[i]);
                            return;
                        }
                    }
                    Console.WriteLine("Wrong Card!");
                    return;
                }
                else
                {
                    CardType CardTypeTo = new CardType();
                    try
                    {
                        CardTypeTo = (CardType)Enum.Parse(typeof(CardType), inputArray[1]);
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("WROONG!!");
                        return;
                    }
                    Card CardIn = new Card((int)CardTypeTo);
                    CardIn.OpenCard();

                    List<Card> to = new List<Card>();
                    to = FindInStack(CardIn);
                    if (to != null)
                    {
                        Console.WriteLine("Wrong Card!");
                        return;
                    }
                    to = FindInTables(CardIn);
                    if (to == null)
                    {
                        Console.WriteLine("Wrong Card!");
                        return;
                    }

                    if (CardOut.PutField(to.Last()))
                    {
                        //Shift(from, to);
                        Shift(from, CardOut, to);
                    }
                    else
                    {
                        Console.WriteLine("Wrong Card!");
                    }
                }
            }

            // from table or unused to stack
            if (inputArray.Count() == 1)
            {
                CardType ct = new CardType();
                try
                {
                    ct = (CardType)Enum.Parse(typeof(CardType), inputArray[0]);
                }
                catch (Exception e)
                {
                    Console.WriteLine("WRONG!!!");
                    return;
                }
                Card cardToStack = new Card((int)ct);
                List<Card> from = new List<Card>();
                from = FindInUnused(cardToStack);
                if (from == null)
                {
                    from = FindInTables(cardToStack);
                }
                if (from == null)
                {
                    Console.WriteLine("Wrong Card!");

                    return;
                }

                // card to suitable stack
                switch (cardToStack.Suite)
                {
                    case CardSuite.Hearts:
                        if (HeartsCards.Count == 0)
                        {
                            if (cardToStack.Type == CardType.HA)
                                Shift(from, HeartsCards);
                        }
                        else if (cardToStack.PutStack(HeartsCards.Last()))
                            Shift(from, HeartsCards);
                        break;
                    case CardSuite.Diamonds:
                        if (DiamondsCards.Count == 0)
                        {
                            if (cardToStack.Type == CardType.DA)
                                Shift(from, DiamondsCards);
                        }
                        else if (cardToStack.PutStack(DiamondsCards.Last()))
                            Shift(from, DiamondsCards);
                        break;
                    case CardSuite.Clubs:
                        if (ClubsCards.Count == 0)
                        {
                            if (cardToStack.Type == CardType.CA)
                                Shift(from, ClubsCards);
                        }
                        else if (cardToStack.PutStack(ClubsCards.Last()))
                            Shift(from, ClubsCards);
                        break;
                    case CardSuite.Spades:
                        if (SpadesCards.Count == 0)
                        {
                            if (cardToStack.Type == CardType.SA)
                                Shift(from, SpadesCards);
                        }
                        else if (cardToStack.PutStack(SpadesCards.Last()))
                            Shift(from, SpadesCards);
                        break;
                }
            }
        }

        private static void Shift(List<Card> from, Card cardOut, List<Card> to)
        {
            int indexFrom = 0;

            for (int i = 0; i < from.Count; i++)
            {
                if (from[i].Type == cardOut.Type)
                {
                    indexFrom = i;
                    break;
                }
            }

            while (from.Count != indexFrom)
            {
                Card card = from.ElementAt(indexFrom);
                from.Remove(from.ElementAt(indexFrom));
                to.Add(card);
            }

            if (from.Count != 0)
            {
                from.Last().OpenCard();
            }
        }

        static private void StockManipulate()
        {
            if (StockCards.Count() == 0)
            {
                while (UnusedCards.Count != 0)
                {
                    Card card = UnusedCards.Last();
                    UnusedCards.Remove(UnusedCards.Last());
                    card.CloseCard();
                    StockCards.Add(card);
                }
            }
            else
            {
                Card card = StockCards.Last();
                StockCards.Remove(StockCards.Last());
                card.OpenCard();
                UnusedCards.Add(card);
            }
        }

        static private void Shift(List<Card> Out, List<Card> In)
        {
            Card card = Out.Last();
            Out.Remove(Out.Last());
            if (Out.Count != 0)
            {
                Out.Last().OpenCard();
            }
            In.Add(card);
        }

        static private List<Card> FindInStack(Card card)
        {
            if (HeartsCards.Count != 0)
                if (HeartsCards.Last().Type == card.Type)
                    return HeartsCards;

            if (DiamondsCards.Count != 0)
                if (DiamondsCards.Last().Type == card.Type)
                    return DiamondsCards;

            if (ClubsCards.Count != 0)
                if (ClubsCards.Last().Type == card.Type)
                    return ClubsCards;

            if (SpadesCards.Count != 0)
                if (SpadesCards.Last().Type == card.Type)
                    return SpadesCards;

            return null;
        }

        static private List<Card> FindInUnused(Card card)
        {
            if (UnusedCards.Count() == 0)
                return null;

            if (UnusedCards.Last().Type == card.Type)
                return UnusedCards;

            return null;
        }

        static private List<Card> FindInTables(Card card)
        {
            for (int i = 0; i < 7; i++)
            {
                for (int j = Tables[i].Count - 1; j >= 0; j--)
                {
                    if (!Tables[i][j].isOpened())
                    {
                        break;
                    }
                    if (Tables[i][j].Type == card.Type)
                        return Tables[i];
                }
            }

            return null;
        }

        static private int MaxCount()
        {
            int MaxCount = 0;
            for (int i = 0; i < 7; i++)
            {
                if (MaxCount < Tables[i].Count)
                    MaxCount = Tables[i].Count;
            }
            return MaxCount;
        }
    }
}
