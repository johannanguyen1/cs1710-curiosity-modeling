#lang forge/froglet
// option bitwidth 9

sig Clothing {
    category: one Category,
    color: one Color,
    season: one Season,
    formality: one Formality
}

abstract sig Category {}
one sig Top, Bottom, Outerwear, Accessory, Shoe extends Category {}

abstract sig Color {
    red: one Int,
    green: one Int,
    blue: one Int
}

one sig Red, Green, Blue, Orange, Yellow, Magenta, Cyan, Purple, SkyBlue, Rose, OceanGreen, LeafGreen, Black, White, Gray extends Color {}

abstract sig Season {}
one sig Summer, Winter, Spring, Fall extends Season {}

abstract sig Formality {}
one sig Casual, Business, Formal extends Formality {}

// -- Define RGB values for each color
// pred rgbValues {
//     all c: Color | {
//         (c = Red) implies (c.red = 255 and c.green = 0 and c.blue = 0)
//         (c = Green) implies (c.red = 0 and c.green = 255 and c.blue = 0)
//         (c = Blue) implies (c.red = 0 and c.green = 0 and c.blue = 255)
//         (c = Orange) implies (c.red = 255 and c.green = 165 and c.blue = 0)
//         (c = Yellow) implies (c.red = 255 and c.green = 255 and c.blue = 0)
//         (c = Purple) implies (c.red = 128 and c.green = 0 and c.blue = 128)
//         (c = Black) implies (c.red = 0 and c.green = 0 and c.blue = 0)
//         (c = White) implies (c.red = 255 and c.green = 255 and c.blue = 255)
//         (c = Gray) implies (c.red = 128 and c.green = 128 and c.blue = 128)
//     }
// }

pred rgbValues {
    all c: Color | {
        (c = Red) implies (c.red = 255 and c.green = 0 and c.blue = 0)
        (c = Green) implies (c.red = 0 and c.green = 255 and c.blue = 0)
        (c = Blue) implies (c.red = 0 and c.green = 0 and c.blue = 255)
        (c = Orange) implies (c.red = 255 and c.green = 165 and c.blue = 0)
        (c = Yellow) implies (c.red = 255 and c.green = 255 and c.blue = 0)
        (c = Magenta) implies (c.red = 255 and c.green = 0 and c.blue = 255)
        (c = Cyan) implies (c.red = 0 and c.green = 255 and c.blue = 255)
        (c = Purple) implies (c.red = 128 and c.green = 0 and c.blue = 128)
        (c = SkyBlue) implies (c.red = 135 and c.green = 206 and c.blue = 235)
        (c = Rose) implies (c.red = 255 and c.green = 0 and c.blue = 127)
        (c = OceanGreen) implies (c.red = 46 and c.green = 139 and c.blue = 87)
        (c = LeafGreen) implies (c.red = 50 and c.green = 205 and c.blue = 50)
        (c = Black) implies (c.red = 0 and c.green = 0 and c.blue = 0)
        (c = White) implies (c.red = 255 and c.green = 255 and c.blue = 255)
        (c = Gray) implies (c.red = 128 and c.green = 128 and c.blue = 128)
    }
}


pred wellformedComplementary[c1: Color, c2: Color] {
    -- Ensure RGB values are within valid range (0 to 255)
    c1.red >= 0 and c1.red <= 255
    c1.green >= 0 and c1.green <= 255
    c1.blue >= 0 and c1.blue <= 255

    c2.red >= 0 and c2.red <= 255
    c2.green >= 0 and c2.green <= 255
    c2.blue >= 0 and c2.blue <= 255

    -- Ensure the RGB components add up to 255
    add[c1.red, c2.red] = 255
    add[c1.green, c2.green] = 255
    add[c1.blue, c2.blue] = 255
}

pred complementary[c1: Color, c2: Color] {
    rgbValues
    c1.red = subtract[255, c2.red]
    c1.green = subtract[255, c2.green]
    c1.blue = subtract[255, c2.blue]
    wellformedComplementary[c1, c2]
}

pred monochrome[c1: Color, c2: Color] {
    c1 = c2
}

pred analogous[c1: Color, c2: Color] {
    rgbValues
    abs[subtract[c1.red, c2.red]] <= 50 and abs[subtract[c1.green, c2.green]] <= 50 and abs[subtract[c1.blue, c2.blue]] <= 50
}

pred triadic[c1: Color, c2: Color, c3: Color] {
    rgbValues
    add[add[c1.red, c2.red], c3.red] >= 375
    add[add[c1.red, c2.red], c3.red] <= 385

    add[add[c1.green, c2.green], c3.green] >= 375
    add[add[c1.green, c2.green], c3.green] <= 385

    add[add[c1.blue, c2.blue], c3.blue] >= 375
    add[add[c1.blue, c2.blue], c3.blue] <= 385


}

run {
    rgbValues
    some c1, c2: Color | complementary[c1, c2]
} for exactly 9 Color, 10 Int


/*-- Define complementary color pairs
pred complementary[c1: Color, c2: Color] {
    (c1 = Red and c2 = Green) or
    (c1 = Green and c2 = Red) or
    (c1 = Blue and c2 = Orange) or
    (c1 = Orange and c2 = Blue) or
    (c1 = Yellow and c2 = Purple) or
    (c1 = Purple and c2 = Yellow) or
    ((c1 = Black or c1 = White or c1 = Gray) and 
        (c2 = Black or c2 = White or c2 = Gray))
}
*/
-- Outfit definition
sig Outfit {
    top: one Clothing,
    bottom: one Clothing,
    outerwear: lone Clothing,
    accessory: one Clothing,
    shoes: one Clothing
}

pred seasonalityMatch[outfit: Outfit] {
    -- Enforce seasonality
    outfit.top.season = outfit.bottom.season
    outfit.top.season = outfit.shoes.season
    outfit.outerwear = none or outfit.outerwear.season = outfit.top.season   
    outfit.outerwear != none implies outfit.outerwear.season in Winter or 
        outfit.outerwear.season in Fall
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
    -- Ensure at least one color pattern pair exists in the outfit
    some c1, c2: Color | {
        c1 != c2 and  
        (c1 = outfit.top.color or c1 = outfit.bottom.color or c1 = outfit.shoes.color or c1 = outfit.outerwear.color) and
        (c2 = outfit.top.color or c2 = outfit.bottom.color or c2 = outfit.shoes.color or c2 = outfit.outerwear.color) and
        (complementary[c1, c2] or monochrome[c1, c2] or analogous[c1, c2])
    }
    some c1, c2, c3: Color | {
        c1 != c2 and c2 != c3 and c1 != c3 and
        (c1 = outfit.top.color or c1 = outfit.bottom.color or c1 = outfit.shoes.color or c1 = outfit.outerwear.color) and
        (c2 = outfit.top.color or c2 = outfit.bottom.color or c2 = outfit.shoes.color or c2 = outfit.outerwear.color) and
        (c3 = outfit.top.color or c3 = outfit.bottom.color or c3 = outfit.shoes.color or c3 = outfit.outerwear.color) and
        triadic[c1, c2, c3]
    }

}

-- Ensure that at least one valid outfit exists for each season
pred wardrobeHasValidOutfits {
    all s: Season | some o: Outfit | 
        // o.top.season = s and
        seasonalityMatch[o] and 
        formalityMatch[o] and 
        wellformed[o] and 
        colorRules[o]
}

run wardrobeHasValidOutfits for exactly 4 Season, exactly 2 Outfit, exactly 10 Clothing
