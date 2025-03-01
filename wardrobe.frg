#lang forge/froglet
// option bitwidth 9

-- Defines what makes up an article of clothing
sig Clothing {
    category: one Category,
    color: one Color,
    season: one Season,
    formality: one Formality
}

-- Defines the categories of clothing possible in this universe
abstract sig Category {}
one sig Top, Bottom, Outerwear, Accessory, Shoe extends Category {}

-- Define a red, green, blue RGB field for each color
abstract sig Color {
    red: one Int,
    green: one Int,
    blue: one Int
}


-- Colors in the color wheel
one sig Red, Green, Blue, Orange, Yellow, Magenta, Cyan, Purple, SkyBlue, Rose, OceanGreen, Chartreuse, Black, White, Gray extends Color {}

-- For outfit preds: defines the seasons
abstract sig Season {}
one sig Summer, Winter, Spring, Fall extends Season {}

-- For outfit preds: defines different types of formality
abstract sig Formality {}
one sig Casual, Business, Formal extends Formality {}

-- Assigns each of the colors in the color wheel set RGB  values
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

-- Called to ensure the RGB values assigned are within a valid range (0 to 255)
pred wellformedRGB[c: Color] {
    c.red >= 0 and c.red <= 255
    c.green >= 0 and c.green <= 255
    c.blue >= 0 and c.blue <= 255
}

-- Defines if two given colors are complementary
pred complementaryColor[c1: Color, c2: Color] {
    (c1 = Red and c2 = Cyan) or
    (c1 = Green and c2 = Magenta) or
    (c1 = Blue and c2 = Yellow) or
    (c1 = Chartreuse and c2 = Purple) or
    (c1 = OceanGreen and c2 = Rose) or
    (c1 = Orange and c2 = SkyBlue) or
    (c1 = Black and c2 = White) 
}

-- Ensures two colors are mathematically complementary
pred complementaryRGB[c1: Color, c2: Color] {
    wellformedRGB[c1]
    wellformedRGB[c2]

    add[c1.red, c2.red] = 255
    add[c1.green, c2.green] = 255
    add[c1.blue, c2.blue] = 255
}

-- Ensure that predefined complementary colors match their RGB definitions
pred verifyComplementaryColors[c1, c2: Color] {
    complementaryColor[c1, c2] implies complementaryRGB[c1, c2]
}


-- Define analogous color groups based on predefined sets
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

-- Define analogous colors based on proximity in RGB values
pred analogousRGB[c1: Color, c2: Color] {

    wellformedRGB[c1]
    wellformedRGB[c2]

    -- Case 1: Red values are the same, and green and blue differ by ≤ 128
    (c1.red = c2.red and c1.green = c2.green and abs[subtract[c1.blue, c2.blue]] <= 128) or
    
    -- Case 2: Green values are the same, and red and blue differ by ≤ 128
    (c1.green = c2.green and abs[subtract[c1.red, c2.red]] <= 128 and c1.blue = c2.blue) or
    
    -- Case 3: Blue values are the same, and red and green differ by ≤ 128
    (c1.blue = c2.blue and c1.red = c2.red and abs[subtract[c1.green, c2.green]] <= 128)
}


-- Ensure that predefined analogous colors match their RGB definitions
pred verifyAnalogousColors[c1, c2: Color] {
    analogousColor[c1, c2] implies analogousRGB[c1, c2]
}

-- Defines what a netural color is
pred neutralColor[c: Color] {
    c in Black or c in White or c in Gray
}

-- Defines an entire neutral outfit match
pred neutralMatch[o: Outfit] {
    neutralColor[o.top.color] 
    and neutralColor[o.bottom.color]
    and (no o.outerwear or neutralColor[o.outerwear.color])
    and neutralColor[o.accessory.color]
    and neutralColor[o.shoes.color]
}



//////////////////////////////////////////

-- Outfit definition
sig Outfit {
    top: one Clothing,
    bottom: one Clothing,
    outerwear: lone Clothing,
    accessory: one Clothing,
    shoes: one Clothing
}

-- Enforce seasonality
pred seasonalityMatch[outfit: Outfit] {
    outfit.top.season = outfit.bottom.season
    outfit.top.season = outfit.shoes.season
    outfit.outerwear = none or outfit.outerwear.season = outfit.top.season   
    outfit.outerwear != none implies outfit.outerwear.season in Winter or 
        outfit.outerwear.season in Fall
}

-- Ensure formality match
pred formalityMatch[outfit: Outfit] {
    outfit.top.formality = outfit.bottom.formality
    outfit.top.formality = outfit.shoes.formality
    outfit.outerwear = none or outfit.outerwear.formality = outfit.top.formality
    
}

-- Ensure valid outfit composition
pred wellformed[outfit: Outfit] {
    outfit.top.category = Top
    outfit.bottom.category = Bottom
    outfit.shoes.category = Shoe
    outfit.outerwear = none or outfit.outerwear.category = Outerwear
    all a: outfit.accessory | a.category = Accessory

}

pred colorRules[outfit: Outfit] {
    -- Ensure at least one valid color pattern pair exists in the outfit
    let c1 = outfit.top.color, c2 = outfit.bottom.color, c3 = outfit.shoes.color, c4 = outfit.accessory.color,
        c5 = outfit.outerwear.color | {
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
                wellformed[o] and
                colorRules[o]

}

// Verify analagous colors predicate using helper verify analogous function
run {
    rgbValues
    all c1, c2: Color | {
        verifyAnalogousColors[c1, c2]
    
     }
} for exactly 15 Color, 9 Int

// Verify complementary colors predicate using helper verify complementary function
run {
    rgbValues
    all c1, c2: Color | {
        verifyComplementaryColors[c1, c2]
    }
} for exactly 15 Color, 9 Int

// Verify wellformedness for all colors in this universe
run {
    rgbValues
    all c: Color | {
        wellformedRGB[c]
     }
} for exactly 15 Color, 9 Int

// Verify wardrobe has valid outfits using helper predicate
run wardrobeHasValidOutfits for 4 Season, 3 Formality, 12 Outfit, 48 Clothing, 15 Color, 9 Int
