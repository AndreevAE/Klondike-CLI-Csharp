using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace KlondikeTest
{
    class Deck
    {
        private List<Card> _cards = new List<Card>();

        public Deck()
        {
            for (int i = 0; i < 52; ++i)
            {
                Card card = new Card(i);
                _cards.Add(card);
            }

        }
        public void Shuffle()
        {
            var rnd = new Random();
            var result = _cards.OrderBy(item => rnd.Next()).ToList();
            _cards = result;
        }

        public Card Pop()
        {
            Card card = _cards.Last();
            _cards.Remove(_cards.Last());
            return card;
        }

    }
}
