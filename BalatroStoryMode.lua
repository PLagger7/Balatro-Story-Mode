------------------
--ATLASES
------------------
SMODS.Atlas{
    key = 'repaints',
    path = 'Jokers.png',
    px = 71,
    py = 95
}

SMODS.Atlas{
    key = 'blinds',
    atlas_table = 'ANIMATION_ATLAS',
    frames = '21',
    path = 'BlindChips.png',
    px = 34,
    py = 34
}

SMODS.Atlas{
    key = 'straight_up_mimin_it',
    atlas_table = 'ANIMATION_ATLAS',
    frames = '153',
    path = 'mimaron.png',
    px = 45,
    py = 26
}

SMODS.Atlas{
    key = 'divorc',
    path = 'divorc.png',
    px = 1536,
    py = 1024
}
------------------
--SOUNDS
------------------

SMODS.Sound({
    key = 'bahh',
    path = 'bahh.ogg',
    pitch = 1
})

SMODS.Sound({
    key = 'mark',
    path = 'hello-everybody-my-name-is-markiplier.ogg',
    pitch = 1,
})

SMODS.Sound({
    key = 'splat',
    path = 'ralsei-splat.ogg',
    pitch = 1
})

SMODS.Sound({
    key = 'driving',
    path = 'snd_cardrive_bc.wav',
    pitch = 1
})

SMODS.Sound({
    key = 'rev',
    path = 'snd_dogrev.wav',
    pitch = 1
})
------------------
--FUNCTIONS
------------------

local left_clicked = Controller.L_cursor_press --Add click context
function Controller.L_cursor_press(x, y)
    left_clicked(x, y)
    if G and G.jokers and G.jokers.cards and not G.SETTINGS.paused then
        SMODS.calculate_context({BStory_click = true})
    end
end

local run_info_func = G.FUNCS.run_info --Make blinds scale by 1% when run info is pressed
function G.FUNCS.run_info()
run_info_func()
G.GAME.starting_params.ante_scaling = G.GAME.starting_params.ante_scaling + G.GAME.starting_params.ante_scaling*0.01
end

local bool = true 
SMODS.current_mod.calculate = function (self, context)
    --Occasionally make the Blind require 1 extra chip (not final hand)
    if G.GAME.blind and G.GAME.current_round.hands_left ~= 0 and G.GAME.chips >= G.GAME.blind.chips and bool then
        if math.random() >= .9 then
        G.GAME.blind.chips = G.GAME.chips + 1
        else bool = false
        end
    end
    if context.before then bool = true end
end

------------------
--JOKERS
------------------

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
    eternal_compat = true,
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

SMODS.Joker:take_ownership('square',
{
    name = 'triangle',
    atlas = 'repaints',
    pos = {x=9, y=11},
    pixel_size = { h = 71 },
    cost = 3,
    config = { extra = { chips = 0, chip_mod = 3 } },
    loc_vars = function (self, info_queue, card)
        return{
            vars = {card.ability.extra.chips, card.ability.extra.chip_mod}
        }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint and #context.full_hand == 3 then
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.CHIPS
            }
        end

        if context.joker_main then
            return{
                chips = card.ability.extra.chips
            }
        end
    end,
},
true
)

SMODS.Joker:take_ownership('juggler',
{
    atlas = 'repaints',
    pos = {x=0, y=1}
},
true
)

SMODS.Joker:take_ownership('drunkard',
{
    atlas = 'repaints',
    pos = {x=1, y=1}
},
true
)

SMODS.Joker:take_ownership('8_ball',
{
    atlas = 'repaints',
    pos = {x=0, y=5}
},
true
)

SMODS.Joker:take_ownership('obelisk',
{
    config = {extra = 0.25, x_mult = 1}
},
true
)

SMODS.Joker:take_ownership('golden',
{
    atlas = 'repaints',
    pos = {x=9, y=2},
    config = {extra = 4, pyrite = false},
    loc_vars = function (self, info_queue, card)
        return{
            vars = {card.ability.extra},
            key = card.ability.pyrite and 'j_BStory_golden_pyrite' or nil
        }
    end,

    add_to_deck = function (self, card, from_debuff)
        card.ability.pyrite = true
        card.ability.extra = 1
    end,

    draw = function (self, card, layer)
        if (layer == 'card' or layer == 'both') and (card.config.center.discovered or card.bypass_discovery_center) then
            if card.ability.pyrite then
                card.children.center:set_sprite_pos({x=0, y=9})
            else
                card.children.center:set_sprite_pos({x=9, y=2})
            end
        end
    end
},
true
)

SMODS.Joker:take_ownership('gift',
{
    calculate = function (self, card, context)
        if context.end_of_round and not context.game_over and context.main_eval and not context.blueprint then
            local fee = 0
            for _, area in ipairs({ G.jokers, G.consumeables }) do
                for _, other_card in ipairs(area.cards) do
                    if other_card.set_cost then
                        fee = fee + 1
                        other_card.ability.extra_value = (other_card.ability.extra_value or 0) +
                            card.ability.extra
                        other_card:set_cost()
                    end
                end
            end
            return {
                dollars = -fee,
                message = localize('k_val_up'),
                colour = G.C.MONEY
            }
        end
    end
},
true)

SMODS.Joker:take_ownership('ice_cream',
{
    name = 'iced_cream', --with a d because i am being a d
    atlas = 'repaints',
    pos = {x=4,y=10},
    config = { extra = { chips = 100, chip_mod = 5 }, melted = false },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.chips, card.ability.extra.chip_mod },
        }
    end,
        calculate = function(self, card, context)
        if context.after and not context.blueprint then
            if card.ability.extra.chips - card.ability.extra.chip_mod <= 0 and not card.ability.melted then
                card.ability.melted = true
                card.ability.extra.chips = card.ability.extra.chips - card.ability.extra.chip_mod
                return {
                    message = localize('k_melted_ex'),
                    colour = G.C.CHIPS
                }
            else
                card.ability.extra.chips = card.ability.extra.chips - card.ability.extra.chip_mod
                return {
                    message = localize { type = 'variable', key = 'a_chips_minus', vars = { card.ability.extra.chip_mod } },
                    colour = G.C.CHIPS
                }
            end
        end
        if context.joker_main then
            return {
                chips = card.ability.extra.chips
            }
        end
    end,

    draw = function (self, card, layer)
        if (layer == 'card' or layer == 'both') and (card.config.center.discovered or card.bypass_discovery_center) then
            if card.ability.melted then
                card.children.center:set_sprite_pos({x=0, y=16})
            else
                card.children.center:set_sprite_pos({x=4, y=10})
            end
        end
    end
},
true
)

SMODS.Joker:take_ownership('turtle_bean',
{
    name = 'bean', --like the streamer!
    atlas = 'repaints',
    pos = {x=4, y=13},
    config = { extra = { h_size = 5, h_mod = 1 }, eaten = false },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.h_size, card.ability.extra.h_mod } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            if card.ability.extra.h_size - card.ability.extra.h_mod <= 0 and not card.ability.eaten then
                card.ability.eaten = true
                card.ability.extra.h_size = card.ability.extra.h_size - card.ability.extra.h_mod
                G.hand:change_size(-card.ability.extra.h_mod)
                return {
                    message = localize('k_eaten_ex'),
                    colour = G.C.FILTER
                }
            else
                card.ability.extra.h_size = card.ability.extra.h_size - card.ability.extra.h_mod
                G.hand:change_size(-card.ability.extra.h_mod)
                return {
                    message = localize { type = 'variable', key = 'a_handsize_minus', vars = { card.ability.extra.h_mod } },
                    colour = G.C.FILTER
                }
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        G.hand:change_size(card.ability.extra.h_size)
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.hand:change_size(-card.ability.extra.h_size)
    end,

    draw = function (self, card, layer)
        if (layer == 'card' or layer == 'both') and (card.config.center.discovered or card.bypass_discovery_center) then
            if card.ability.eaten then
                card.children.center:set_sprite_pos({x=1, y=16})
            else
                card.children.center:set_sprite_pos({x=4, y=13})
            end
        end
    end
},
true
)

SMODS.Joker:take_ownership('popcorn',
{
    name = 'popped_corn', --past tense cuz i ated it
    atlas = 'repaints',
    pos = {x=1, y=15},
    config = { extra = { mult_loss = 4, mult = 20 }, eaten = false },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.mult_loss } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            if card.ability.extra.mult - card.ability.extra.mult_loss <= 0 and not card.ability.eaten then
                card.ability.eaten = true
                card.ability.extra.mult = card.ability.extra.mult - card.ability.extra.mult_loss
                return {
                    message = localize('k_eaten_ex'),
                    colour = G.C.RED
                }
            else
                card.ability.extra.mult = card.ability.extra.mult - card.ability.extra.mult_loss
                return {
                    message = localize { type = 'variable', key = 'a_mult_minus', vars = { card.ability.extra.mult_loss } },
                    colour = G.C.MULT
                }
            end
        end
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end,
    draw = function (self, card, layer)
        if (layer == 'card' or layer == 'both') and (card.config.center.discovered or card.bypass_discovery_center) then
            if card.ability.eaten then
                card.children.center:set_sprite_pos({x=2, y=16})
            else
                card.children.center:set_sprite_pos({x=1, y=15})
            end
        end
    end
},
true
)

SMODS.Joker:take_ownership('ramen',
{
    name = 'rawmen', --:drool:
    atlas = 'repaints',
    pos = { x = 2, y = 15 },
    config = { extra = { Xmult_loss = 0.01, Xmult = 2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, card.ability.extra.Xmult_loss }, eaten = false }
    end,
    calculate = function(self, card, context)
        if context.discard and not context.blueprint then
            if card.ability.extra.Xmult - card.ability.extra.Xmult_loss <= 1 and not card.ability.eaten then
                card.ability.eaten = true
                card.ability.extra.Xmult = card.ability.extra.Xmult - card.ability.extra.Xmult_loss
                return {
                    message = localize('k_eaten_ex'),
                    colour = G.C.FILTER
                }
            else
                card.ability.extra.Xmult = card.ability.extra.Xmult - card.ability.extra.Xmult_loss
                return {
                    message = localize { type = 'variable', key = 'a_xmult_minus', vars = { card.ability.extra.Xmult_loss } },
                    colour = G.C.RED,
                    delay = 0.2
                }
            end
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.Xmult
            }
        end
    end,
    draw = function (self, card, layer)
        if (layer == 'card' or layer == 'both') and (card.config.center.discovered or card.bypass_discovery_center) then
            if card.ability.eaten then
                card.children.center:set_sprite_pos({x=3, y=16})
            else
                card.children.center:set_sprite_pos({x=2, y=15})
            end
        end
    end
},
true
)

SMODS.Joker:take_ownership('selzer',
{
    name = 'seltza', --thunk please learn how to spell kthx
    atlas = 'repaints',
    pos = { x = 3, y = 15 },
    config = { extra = { hands_left = 10 }, drank = false },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.hands_left } }
    end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play then
            return {
                repetitions = 1
            }
        end
        if context.after and not context.blueprint then
            if card.ability.extra.hands_left - 1 <= 0 and not card.ability.drank then
                card.ability.drank = true
                card.ability.extra.hands_left = card.ability.extra.hands_left - 1
                return {
                    message = localize('k_drank_ex'),
                    colour = G.C.FILTER
                }
            else
                card.ability.extra.hands_left = card.ability.extra.hands_left - 1
                return {
                    message = card.ability.extra.hands_left .. '',
                    colour = G.C.FILTER
                }
            end
        end
    end,
    draw = function (self, card, layer)
        if (layer == 'card' or layer == 'both') and (card.config.center.discovered or card.bypass_discovery_center) then
            if card.ability.drank then
                card.children.center:set_sprite_pos({x=4, y=16})
            else
                card.children.center:set_sprite_pos({x=3, y=15})
            end
        end
    end
},
true
)

SMODS.Joker:take_ownership('wee',
{
    draw = function(self, card, layer)
        card.ability._orig_scale = card.ability._orig_scale or card.T.scale
        card.T.scale = card.ability._orig_scale * (1 + card.ability.extra.chips/160)
    end
},
true
)

SMODS.Joker:take_ownership('mime',
{
    pantomime_sprite = nil,
    loc_vars = function (self, info_queue, card)
        if self.pantomime_sprite and self.pantomime_sprite.remove then
            self.pantomime_sprite:remove()
            self.pantomime_sprite = nil
        end
        self.pantomime_sprite = AnimatedSprite(0, 0,  3.5, 3.5 * 45 / 26, G.ANIMATION_ATLAS.BStory_straight_up_mimin_it, {x=0,y=0})

        local main_end = {
            {
                n = G.UIT.C,
                config = { align = "bm", minh = 2, padding = 0.1 },
                nodes = {
                    { n = G.UIT.O, config = { object = self.pantomime_sprite } },
                }
            }
        }
        return{
            main_end = main_end
        }
    end
},
true
)

SMODS.Joker:take_ownership('space',
{
    name = 'spacey',
    atlas = 'repaints',
    config = { extra = { odds = 4 }, shakey = 0, nausea = false },
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'spacey')
        return {
            vars = { numerator, denominator },
            key = card.ability.nausea and 'j_BStory_sick_space' or nil
        }
    end,
    calculate = function(self, card, context)
        if context.before and SMODS.pseudorandom_probability(card, 'spacey', 1, card.ability.extra.odds)
            and not card.ability.nausea then
            return {
                level_up = true,
                message = localize('k_level_up_ex')
            }
        end
    end,

    draw = function (self, card, layer)
        if (layer == 'card' or layer == 'both') and (card.config.center.discovered or card.bypass_discovery_center) then
            if card.states.drag.is then
                local deltaX = math.abs(card.T.x-card.VT.x)
                local deltaY = math.abs(card.T.y-card.VT.y)
                local delta = math.sqrt(deltaX ^ 2 + deltaY ^2)
                if delta >= 0.67  then
                    card.ability.shakey = card.ability.shakey + delta
                    print(tostring(card.ability.shakey))
                if card.ability.shakey >= 100 or card.ability.nausea then
                    if not card.ability.nausea then
                        play_sound('BStory_splat', 1, 2)
                        card:juice_up()
                        card.ability.nausea = true
                    end
                    card.children.center:set_sprite_pos({x=5, y=16})
                else
                    if not card.states.drag.is then
                    card.ability.shakey = 0
                    else card.ability.shakey = card.ability.shakey - 1
                    end
                    card.children.center:set_sprite_pos({x=3, y=5})
                end
            end
            end
        end
    end
},
true
)

SMODS.Joker:take_ownership('ride_the_bus',
{
    name = 'miss_the_bus',
    atlas = 'repaints',
    config = {extra = {mult_mod = 1, mult = 0}, missed = false},
    loc_vars = function (self, info_queue, card)
        return{
            vars = {card.ability.extra.mult_mod, card.ability.extra.mult},
            key = card.ability.missed and 'j_BStory_missed_the_bus' or nil
        }
    end,
    pos = {x=1, y=6},

    add_to_deck = function (self, card, from_debuff)
        G.E_MANAGER:add_event(Event({
            func = function()
                card.ability.missed = true
                play_sound('BStory_rev', 1, 2)
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 4.1,
            func = function ()
                play_sound('BStory_driving', 1, 0.5)
                card.disable_align = true
                card.T.x = card.T.x + 100
                SMODS.destroy_cards({card}, true, false, false)
                return true
            end
        }))
    end,

    draw = function (self, card, layer)
        if (layer == 'card' or layer == 'both') and (card.config.center.discovered or card.bypass_discovery_center) then
            if card.ability.missed then
                card.children.center:set_sprite_pos({x=6, y=16})
            else
                card.children.center:set_sprite_pos({x=1, y=6})
            end
        end
    end
},
true
)

SMODS.Joker:take_ownership( 'odd_todd',
{
    divorc_sprite = nil,

    loc_vars = function(self, info_queue, card)
        if self.divorc_sprite and self.divorc_sprite.remove then
            self.divorc_sprite:remove()
            self.divorc_sprite = nil
        end
        self.divorc_sprite = Sprite(0, 0, 3.5, 3.5 *  1024 / 1536, G.ASSET_ATLAS.BStory_divorc, {x = 0, y = 0})

        local main_end = {
            {
                n = G.UIT.C,
                config = { align = "bm", minh = 2, padding = 0.1 },
                nodes = {
                    { n = G.UIT.O, config = { object = self.divorc_sprite } },
                }
            }
        }
        return {
            main_end = main_end
        }
    end,
},
true
)

SMODS.Joker:take_ownership('bull',
{
    atlas = 'repaints'
},
true
)

SMODS.Joker:take_ownership('hanging_chad',
{
    name = 'hanging_chud',
    config = {extra = {repetitions = 2}},
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.repetitions } }
    end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and context.other_card == context.scoring_hand[2] then
            return {
                repetitions = card.ability.extra.repetitions
            }
        end
    end,
},
true
)

------------------
--TAROTS
------------------

SMODS.Consumable:take_ownership('death',
{
    use = function (self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        for i = 1, #G.hand.highlighted do
            local percent = 1.15 - (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip()
                    play_sound('card1', percent)
                    G.hand.highlighted[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        delay(0.2)
        local rightmost = G.hand.highlighted[1]
        for i = 1, #G.hand.highlighted do
            if G.hand.highlighted[i].T.x > rightmost.T.x then
                rightmost = G.hand.highlighted[i]
            end
        end
        for i = 1, #G.hand.highlighted do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    if G.hand.highlighted[i] ~= rightmost then
                        SMODS.copy_card(G.hand.highlighted[i], { new_card = rightmost })
                    end
                    return true
                end
            }))
        end
        for i = 1, #G.hand.highlighted do
            local percent = 0.85 + (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip()
                    play_sound('tarot2', percent, 0.6)
                    G.hand.highlighted[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
        delay(0.5)
    end,
},
true
)

------------------
--BLINDS
------------------

SMODS.Blind:take_ownership('needle',
{
    atlas = 'blinds',
    pos = {x=0, y=20}
},
true
)

SMODS.Blind:take_ownership('goad',
{
    calculate = function (self, blind, context)
        if context.setting_blind then
            play_sound('BStory_bahh', 1, 2)
            G.E_MANAGER:add_event(Event({
                blocking = false,
                func = function()
                    if G.STATE == G.STATES.SELECTING_HAND then
                        G.GAME.chips = G.GAME.blind.chips
                        G.STATE = G.STATES.HAND_PLAYED
                        G.STATE_COMPLETE = true
                        end_round()
                    return true
                end
            end
            }))
            end
        end
},
true
)

SMODS.Blind:take_ownership('mark',
{
    calculate = function (self, blind, context)
        if context.setting_blind then
            play_sound('BStory_mark', 1, 2)
        end
    end
},
true
)


--[[
TO DO
bean gives Bean quotes when triggered
smiley face gives pricy air quotes
doc glases on BUll [sic]
chekcered deck is clubs and diamonds
idol buff (Each played    gives x2 Mult when scored) [sic]
flower pot buff -> x3 Mult if poker hand [sic]
Four Fingers nerf -> All Flushes and Straights can be made with  cards
negative interest while in debt
loyalty card buff -> x4 Mult every hands played
scary face jumpscare sometimes
The Wheel -> after 7 cards played/discarded, cards drawn face down
--]]