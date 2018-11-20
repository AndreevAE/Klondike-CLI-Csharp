using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace KlondikeTest
{
    public enum CardSuite
    {
        Hearts,
        Diamonds,
        Clubs,
        Spades,
    }

    public enum CardRank
    {
        Ace,
        Two,
        Three,
        Four,
        Five,
        Six,
        Seven,
        Eight,
        Nine,
        Ten,
        Jack,
        Queen,
        King,
    }

    public enum CardColor
    {
        Black,
        Red,
    }

    public enum CardType
    {
        //  Hearts
        HA,
        H2,
        H3,
        H4,
        H5,
        H6,
        H7,
        H8,
        H9,
        H10,
        HJ,
        HQ,
        HK,

        //  Diamonds
        DA,
        D2,
        D3,
        D4,
        D5,
        D6,
        D7,
        D8,
        D9,
        D10,
        DJ,
        DQ,
        DK,

        //  Clubs
        CA,
        C2,
        C3,
        C4,
        C5,
        C6,
        C7,
        C8,
        C9,
        C10,
        CJ,
        CQ,
        CK,

        //  Spades
        SA,
        S2,
        S3,
        S4,
        S5,
        S6,
        S7,
        S8,
        S9,
        S10,
        SJ,
        SQ,
        SK,
    }
}
