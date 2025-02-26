#lang forge/froglet

sig Clothing {
    category: one Category,
    color: one Color,
    season: one Season,
    formality: one Formality
}

abstract sig Category {}
one sig Top, Bottom, Outerwear, Accessory, Shoe extends Category {}

abstract sig Color {}
one sig Red, Green, Blue, Orange, Yellow, Purple, Black, White, Gray extends Color {}

abstract sig Season {}
one sig Summer, Winter, Spring, Fall extends Season {}

abstract sig Formality {}
one sig Casual, Business, Formal extends Formality {}

-- Define complementary color pairs
pred complementary[c1: Color, c2: Color] {
    (c1 = Red and c2 = Green) or
    (c1 = Green and c2 = Red) or
    (c1 = Blue and c2 = Orange) or
    (c1 = Orange and c2 = Blue) or
    (c1 = Yellow and c2 = Purple) or
    (c1 = Purple and c2 = Yellow) or
    (c1 in Black + White + Gray and c2 in Black + White + Gray)
}

-- Outfit definition
sig Outfit {
    top: one Clothing,
    bottom: one Clothing,
    outerwear: lone Clothing,
    accessory: set Clothing,
    shoes: one Clothing
}

pred seasonalityMatch[outfit: Outfit] {
    -- Enforce seasonality
    outfit.top.season = outfit.bottom.season
    outfit.top.season = outfit.shoes.season
    outfit.outerwear = none or outfit.outerwear.season = outfit.top.season    
}

pred formalityMatch[outfit: Outfit] {
    -- Ensure formality match
    outfit.top.formality = outfit.bottom.formality
    outfit.top.formality = outfit.shoes.formality
    outfit.outerwear = none or outfit.outerwear.formality = outfit.top.formality
}
    
pred wellformed[outfit: Outfit] {
    -- Ensure valid outfit composition
    outfit.top.category = Top
    outfit.bottom.category = Bottom
    outfit.shoes.category = Shoe
    outfit.outerwear = none or outfit.outerwear.category = Outerwear
    all a: outfit.accessory | a.category = Accessory
}

pred colorRules[outfit: Outfit] {
    -- Ensure at least one complementary color pair exists in the outfit
    // some disj c1, c2: outfit.top.color + outfit.bottom.color + outfit.shoes.color + 
    //                  (outfit.outerwear.color & Color) |
    //     complementary(c1, c2)

    complementary[outfit.top.color, outfit.bottom.color]

}

-- Ensure that at least one valid outfit exists for each season
pred wardrobeHasValidOutfits {
    all s: Season | some o: Outfit | 
        o.top.season = s and
        seasonalityMatch[o] and 
        formalityMatch[o] and 
        wellformed[o] and 
        colorRules[o]
}

run wardrobeHasValidOutfits for exactly 4 Season, exactly 4 Outfit, exactly 10 Clothing