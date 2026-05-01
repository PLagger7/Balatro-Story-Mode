SMODS.Joker:take_ownership('joker',
{
    cost = 69,

    calculate = function (self, card, context)
        if context.joker_main then
            return{
                chips = 4,
            }
        end
    end
},
true

)

SMODS.Joker:take_ownership('baron',
{
    add_to_deck = function(self, card, from_debuff)
        for _, card in pairs(G.playing_cards) do
            if card:get_id() == 13 then
                SMODS.destroy_cards(card)
            end
        end
    end
},
true
)