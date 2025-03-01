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

one sig Red, Green, Blue, Orange, Yellow, Magenta, Cyan, Purple, SkyBlue, Rose, OceanGreen, Chartreuse, Black, White, Gray extends Color {}

abstract sig Season {}
one sig Summer, Winter, Spring, Fall extends Season {}

abstract sig Formality {}
one sig Casual, Business, Formal extends Formality {}


pred rgbValues {
    all c: Color | {
        (c = Red) implies (c.red = 255 and c.green = 0 and c.blue = 0)
        (c = Green) implies (c.red = 0 and c.green = 255 and c.blue = 0)
        (c = Blue) implies (c.red = 0 and c.green = 0 and c.blue = 255)
        (c = Orange) implies (c.red = 255 and c.green = 128 and c.blue = 0)
        (c = Yellow) implies (c.red = 255 and c.green = 255 and c.blue = 0)
        (c = Magenta) implies (c.red = 255 and c.green = 0 and c.blue = 255)
        (c = Cyan) implies (c.red = 0 and c.green = 255 and c.blue = 255)
        (c = Purple) implies (c.red = 128 and c.green = 0 and c.blue = 255)
        (c = SkyBlue) implies (c.red = 0 and c.green = 127 and c.blue = 255)
        (c = Rose) implies (c.red = 255 and c.green = 0 and c.blue = 127)
        (c = OceanGreen) implies (c.red = 0 and c.green = 255 and c.blue = 128)
        (c = Chartreuse) implies (c.red = 127 and c.green = 255 and c.blue = 0)
        (c = Black) implies (c.red = 0 and c.green = 0 and c.blue = 0)
        (c = White) implies (c.red = 255 and c.green = 255 and c.blue = 255)
        (c = Gray) implies (c.red = 128 and c.green = 128 and c.blue = 128)

    }
}

pred warmColor[c: Color] {
    c in Red or c in Orange or c in Yellow or c in Rose
}

pred warmRGB[c: Color] {
    // Warm colors have higher red and green values, and lower blue values
    //c.red > 128 and c.red < 255 and c.green < 128 and c.blue < c.red
    c.red > c.blue
    c.green >= 0 and c.green <= 255
    wellformedRGB[c]
}

pred coolColor[c: Color] {
    c in Blue or c in Green or c in Cyan or c in Purple or c in SkyBlue or c in OceanGreen or c in Chartreuse or c in Magenta
}

pred coolRGB[c: Color] {
    // Cool colors have higher blue and green values, and lower red values
    //c.blue > 128 and c.green > 128 and c.red < c.blue
    c.blue >= c.red or c.green >= c.red
    wellformedRGB[c]

}

// Ensure that predefined warm colors match their RGB definitions
pred verifyWarmColors[c: Color] {
    warmColor[c] implies warmRGB[c]

}

// Ensure that predefined cool colors match their RGB definitions
pred verifyCoolColors[c: Color] {
    coolColor[c] implies coolRGB[c]
}

pred wellformedRGB[c: Color] {
    -- Ensure RGB values are within valid range (0 to 255)
    c.red >= 0 and c.red <= 255
    c.green >= 0 and c.green <= 255
    c.blue >= 0 and c.blue <= 255
}


pred complementaryColor[c1: Color, c2: Color] {
    (c1 = Red and c2 = Cyan) or
    (c1 = Green and c2 = Magenta) or
    (c1 = Blue and c2 = Yellow) or
    (c1 = Chartreuse and c2 = Purple) or
    (c1 = OceanGreen and c2 = Rose) or
    (c1 = Orange and c2 = SkyBlue) or
    (c1 = Black and c2 = White) 
}



pred complementaryRGB[c1: Color, c2: Color] {
    wellformedRGB[c1]
    wellformedRGB[c2]

    add[c1.red, c2.red] = 255
    add[c1.green, c2.green] = 255
    add[c1.blue, c2.blue] = 255
}

// Ensure that predefined complementary colors match their RGB definitions
pred verifyComplementaryColors[c1, c2: Color] {
    complementaryColor[c1, c2] implies complementaryRGB[c1, c2]
}


// Define analogous color groups based on predefined sets
pred analogousColor[c1: Color, c2: Color] {
    
    (c1 = Red and c2 = Orange) or
    (c1 = Orange and c2 = Yellow) or
    (c1 = Magenta and c2 = Purple) or
    (c1 = Rose and c2 = Magenta) or
    (c1 = Purple and c2 = Blue) or
    (c1 = Blue and c2 = SkyBlue) or
    (c1 = SkyBlue and c2 = Cyan) or
    (c1 = Chartreuse and c2 = Green) or
    (c1 = Chartreuse and c2 = Yellow) or
    (c1 = Rose and c2 = Red) or
    (c1 = OceanGreen and c2 = Cyan) or
    (c1 = Green and c2 = OceanGreen)

}

// Define analogous colors based on proximity in RGB values
pred analogousRGB[c1: Color, c2: Color] {

    wellformedRGB[c1]
    wellformedRGB[c2]

    // Case 1: Red values are the same, and green and blue differ by ≤ 128
    (c1.red = c2.red and c1.green = c2.green and abs[subtract[c1.blue, c2.blue]] <= 128) or
    
    // Case 2: Green values are the same, and red and blue differ by ≤ 128
    (c1.green = c2.green and abs[subtract[c1.red, c2.red]] <= 128 and c1.blue = c2.blue) or
    
    // Case 3: Blue values are the same, and red and green differ by ≤ 128
    (c1.blue = c2.blue and c1.red = c2.red and abs[subtract[c1.green, c2.green]] <= 128)
}


// Ensure that predefined analogous colors match their RGB definitions
pred verifyAnalogousColors[c1, c2: Color] {
    analogousColor[c1, c2] implies analogousRGB[c1, c2]
}


pred neutralColor[c: Color] {
    c in Black or c in White or c in Gray
}

pred neutralMatch[o: Outfit] {
    neutralColor[o.top.color] 
    and neutralColor[o.bottom.color]
    and (no o.outerwear or neutralColor[o.outerwear.color])
    and neutralColor[o.accessory.color]
    and neutralColor[o.shoes.color]
}

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

    colorRules[outfit]

}

pred colorRules[outfit: Outfit] {

    -- Ensure at least one valid color pattern pair exists in the outfit
    let c1 = outfit.top.color, c2 = outfit.bottom.color, c3 = outfit.shoes.color, c4 = outfit.accessory.color,
        c5 = outfit.outerwear.color |
    
    -- Check for complementary colors between the top, bottom, shoes, accessory, and outerwear
    (complementaryColor[c1, c2] or complementaryColor[c1, c3] or complementaryColor[c1, c4] or complementaryColor[c1, c5] or
     complementaryColor[c2, c3] or complementaryColor[c2, c4] or complementaryColor[c2, c5] or
     complementaryColor[c3, c4] or complementaryColor[c3, c5] or complementaryColor[c4, c5]) or
    
    -- Check for neutral color match (if all items are neutral)
    neutralMatch[outfit] or
    
    -- Check for analogous colors between any two items
    (analogousColor[c1, c2] or analogousColor[c1, c3] or analogousColor[c1, c4] or analogousColor[c1, c5] or
     analogousColor[c2, c3] or analogousColor[c2, c4] or analogousColor[c2, c5] or
     analogousColor[c3, c4] or analogousColor[c3, c5] or analogousColor[c4, c5])
}

-- Ensure that at least one valid outfit exists for each season
pred wardrobeHasValidOutfits {
    all s: Season | 
        all f: Formality |
            some o: Outfit | 
                o.top.season = s and 
                o.top.formality = f and
                seasonalityMatch[o] and 
                formalityMatch[o] and 
                wellformed[o]
}

// run {
//     rgbValues
//     all c1, c2: Color | {
//         //verifyWarmColors[c]
//         // verifyCoolColors[c]
//         // verifyComplementaryColors[c1, c2]
//         verifyAnalogousColors[c1, c2]
//      }
// } for exactly 15 Color, 9 Int


run wardrobeHasValidOutfits for 4 Season, 3 Formality, 12 Outfit, 48 Clothing, 15 Color, 9 Int
