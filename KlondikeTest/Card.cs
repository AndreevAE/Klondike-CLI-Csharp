using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace KlondikeTest
{
    class Card
    {
        public Card(int val)
        {
            CRST = val;
        }
        // Color, Rank, Suite, Type
        private int CRST;
        private bool _isOpened = false;

        public bool isOpened()
        {
            return _isOpened;
        }
        public CardType Type
        {
            get
            {
                return (CardType)CRST;
            }
        }

        public CardSuite Suite
        {
            get
            {
                if (CRST < 13)
                    return CardSuite.Hearts;
                if (CRST < 26)
                    return CardSuite.Diamonds;
                if (CRST < 39)
                    return CardSuite.Clubs;
                return CardSuite.Spades;
            }
        }

        public CardColor Color
        {
            get
            {
                if (CRST < 26)
                    return CardColor.Red;

                return CardColor.Black;
            }
        }
        
        public CardRank Rank
        {
            get
            {
                return (CardRank)(CRST % 13);
            }
        }

        // Накладываем в поле
        public bool PutField(Card downCard)
        {
            if (this.Color == downCard.Color)
                return false;

            if (this.Rank == (downCard.Rank - 1))
                return true;

            return false;
        }

        // Накладываем в результат
        public bool PutStack (Card downCard)
        {
            if (downCard == null)
                if (this.Rank != (int)CardRank.Ace)
                    return false;
                else
                    return true;

            if (this.Suite != downCard.Suite)
                return false;

            if (this.Rank == (downCard.Rank + 1))
                return true;

            return false;
        }

        // Переворачиваем
        public void OpenCard()
        {
            _isOpened = true;
        }

        public void CloseCard()
        {
            _isOpened = false;
        }
    }
}
