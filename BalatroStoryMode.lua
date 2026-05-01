SMODS.Atlas{
    key = 'repaints',
    path = 'Jokers.png',
    px = 71,
    py = 95
}
    local bool = true
SMODS.current_mod.calculate = function (self, context)
    if G.GAME.blind and G.GAME.current_round.hands_left ~= 0 and G.GAME.chips >= G.GAME.blind.chips and bool then
        if math.random() >= .9 then
        G.GAME.blind.chips = G.GAME.chips + 1
        else bool = false
        end
    end
    if context.before then bool = true end
end

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

SMODS.Joker:take_ownership('smiley',
{
    atlas = 'repaints',
    pos = {x=6, y=15}
},
true
)

--[[
TO DO
rocket takes off after some amount of time
adding lusty joker makes your deck hearts
--]]