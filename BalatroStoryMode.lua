SMODS.Atlas{
    key = 'repaints',
    path = 'Jokers.png',
    px = 71,
    py = 95
}

local left_clicked = Controller.L_cursor_press
function Controller.L_cursor_press(x, y)
    left_clicked(x, y)
    if G and G.jokers and G.jokers.cards and not G.SETTINGS.paused then
        SMODS.calculate_context({BStory_click = true})
    end
end

local bool = true --Occasionally make the Blind require 1 extra chip (not final hand)
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

SMODS.Joker:take_ownership('rocket',
{
    config = {extra = {dollars = 1, increase = 2, take_off = 4}},
    calculate = function (self, card, context)
        if context.setting_blind then
            card.ability.extra.take_off = card.ability.extra.take_off - 1
        end
        if context.end_of_round and card.ability.extra.take_off <= 0 then
        card.disable_align = true
        card.T.y = card.T.y - 0.5
        G.E_MANAGER:add_event(Event({
            func = function ()
                SMODS.destroy_cards({card}, true, false, false)
                return true
            end
        }))
        end
    end
},
true
)

SMODS.Joker:take_ownership('chaos',
{
    config = {extra = 1},
    calculate = function (self, card, context)
        if G.shop and card.ability.extra > 0 and context.BStory_click then
        G.FUNCS.reroll_shop()
        card.ability.extra = card.ability.extra - 1
        end

        if context.setting_blind then
            card.ability.extra = 1
        end

    end

},
true
)

SMODS.Joker:take_ownership('lusty_joker',
{
    add_to_deck = function (self, card, from_debuff)
        for _, card in pairs(G.playing_cards) do
                assert(SMODS.change_base(card, 'Hearts'))
        end
    end
},
true
)
SMODS.Joker:take_ownership('diet_cola',
{
    add_to_deck = function (self, card, from_debuff)
        card:add_sticker('eternal', true)
    end
},
true
)

SMODS.Joker:take_ownership('raised_fist',
{
    atlas = 'repaints',
    pos = {x=8, y=2}
},
true
)


--[[
TO DO
rocket takes off after some amount of time -maybe make it look better? -add explosion
sillyheart oparadise
square joker is triamnge now
buff obleksik
golden joker is actually pyrite joker, gives 1 dollar,
juggler and drunkard art swap
bean gives Bean quotes when triggered
smiley face gives pricy air quotes
gift card charges you per joker
doc glases on BUll [sic]
chekcered deck is clubs and diamonds
idol buff (Each played    gives x2 Mult when scored) [sic]
Hit The Road -> Hit Road The (makes screen trans colored)
flower pot buff -> x3 Mult if poker hand [sic]
wee joker becomes larger the more chips it has
Four Fingers nerf -> All Flushes and Straights can be made with  cards
remove Mime text, add video 
negative interest while in debt
loyalty card buff -> x4 Mult every hands played
8 ball art revert
Needle is Phyrexia
scary face jumpscare sometimes
shaking space joker makes it sick
--]]