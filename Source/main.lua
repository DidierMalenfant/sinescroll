-- SPDX-FileCopyrightText: 2022-present Didier Malenfant <coding@malenfant.net>
--
-- SPDX-License-Identifier: MIT

import 'CoreLibs/graphics'
import "CoreLibs/object"

import "../toyboxes/toyboxes.lua"

local gfx <const> = playdate.graphics

-- luacheck: globals Scroller
class('Scroller').extends(Object)

function Scroller:init(text)
    Scroller.super.init(self)

    gfx.setFont(gfx.getSystemFont())

    self.font_table = gfx.imagetable.new("Art/font")
    assert(self.font_table)

    self.all_text = text
    self.letter_width = 16
    self.slice_width = 1
    self.nb_of_slices_per_letter = self.letter_width / self.slice_width

    self.sine_1_speed = 5
    self.sine_1_amplitude = 20
    self.sine_1_period = 1
    self.sine_1_current_angle = 0

    self.sine_2_speed = 6
    self.sine_2_amplitude = 30
    self.sine_2_period = 1
    self.sine_2_current_angle = 0

    self.current_text_index = 1
    self.current_text_offset = 0
end

function Scroller:find_char_index(character) -- luacheck: ignore self
    local lookup_table <const> = "0123456789:;<=>?*abcdefghijklmnopqrstuvwxyz[\\]^_"

    return string.find(lookup_table, character, 1, true)
end

function Scroller:draw(y)
    local angle = self.sine_1_current_angle
    local angle_2 = self.sine_2_current_angle
    local start_index = self.current_text_index
    local length <const> = 25
    local x = -self.current_text_offset

    --gfx.drawText(string.format("*start index %d*", start_index), 1, 1)
    --gfx.drawText(string.format("*length %d %s*", length, string.sub(text, start_index, start_index)), 1, 20)

    for text_index = start_index, start_index + length, 1 do
        local index = self:find_char_index(string.sub(self.all_text, text_index, text_index))
        if index then
            for slice_index = 1, self.nb_of_slices_per_letter, 1 do
                local image_index = ((index - 1) * self.nb_of_slices_per_letter) + slice_index
                local image = self.font_table:getImage(image_index)
                assert(image)

                local height_1 = math.sin(math.rad(angle)) * self.sine_1_amplitude
                local height_2 = math.sin(math.rad(angle_2)) * self.sine_2_amplitude

                image:setInverted(true)
                image:drawIgnoringOffset(x, y + height_1 + height_2)

                x += self.slice_width

                angle += self.sine_1_period
                angle_2 += self.sine_2_period
            end
        else
            x += (self.slice_width * self.nb_of_slices_per_letter)

            angle += self.nb_of_slices_per_letter * self.sine_1_period
            angle_2 += self.nb_of_slices_per_letter * self.sine_2_period
        end
    end
end

function Scroller:update()
    self.current_text_offset += 2
    if self.current_text_offset >= self.letter_width then
        self.current_text_offset -= self.letter_width

        self.current_text_index += 1
        self.sine_1_current_angle += (self.sine_1_period * self.nb_of_slices_per_letter)
        self.sine_2_current_angle += (self.sine_2_period * self.nb_of_slices_per_letter)

        if self.current_text_index == #self.all_text - 25 then
            self.current_text_index = 0
        end
    end

    self.sine_1_current_angle = (self.sine_1_current_angle - self.sine_1_speed) % 360
    self.sine_2_current_angle = (self.sine_2_current_angle - self.sine_2_speed) % 360
end

class('Main', { scroller = nil, module = nil, player = nil }).extends()

function Main:init()
    Main.super.init(self)

    gfx.setColor(gfx.kColorWhite)
    gfx.setFont(gfx.getSystemFont())

    self.scroller = Scroller("                         hello lamerz___ what up? dr soft " ..
                             "here with the very first little demo on the playdate. greetings to the kent team " ..
                             "/ bamiga sector one - red sector and tristar - aces - the champs                         ")
    assert(self.scroller)

    self.module = modplayer.module.new('Sounds/Crystal_Hammer.mod')
    assert(self.module)
    
    self.player = modplayer.player.new()
    assert(self.player)
    
    self.player:load(self.module)
    self.player:play()
end

function Main:update()
    playdate.graphics.fillRect(0, 0, 400, 240)
    gfx.fillRect(0, 0, 400, 240)

    playdate.drawFPS(385,0)

    self.scroller:draw(100)
    self.scroller:update()
    
    local stats = playdate.getStats()
    if (stats) then
        local game_stats = stats['game']
        if game_stats then
            gfx.drawText(string.format('*Game %2.2f*', game_stats), 1, 1)
        end
        local audio_stats = stats['audio']
        if game_stats then
            gfx.drawText(string.format('*Audio %2.2f*', audio_stats), 1, 21)
        end
        local kernel_stats = stats['kernel']
        if kernel_stats then
            gfx.drawText(string.format('*Kernel %2.2f*', kernel_stats), 1, 41)
        end
    end
    
    self.player:update()
end

local main = Main()

function playdate.update()
    main:update()
end
