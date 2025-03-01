#lang forge

open "wardrobe.frg"


pred testAnalogousColorOutfit {
    let top = one Clothing, 
        bottom = one Clothing, 
        shoes = one Clothing, 
        accessory = one Clothing, 
        outerwear = one Clothing | 
        analogousOrWarmCool[Outfit] {
            -- Assigning analogous colors to items
            top.color = Red
            bottom.color = Orange
            shoes.color = Yellow
            accessory.color = Rose
            outerwear.color = none -- Outerwear is not required for this test
        }
}

run testAnalogousColorOutfit for 1 Outfit, 5 Clothing, 15 Color, 4 Season



pred testInvalidOutfit {
    let top = one Clothing, 
        bottom = one Clothing, 
        shoes = one Clothing, 
        accessory = one Clothing, 
        outerwear = one Clothing | 
        not warmOrCool[Outfit] {
            -- Assigning a mixture of warm and cool colors
            top.color = Red
            bottom.color = Blue
            shoes.color = Yellow
            accessory.color = Cyan
            outerwear.color = Green
        }
}

run testInvalidOutfit for 1 Outfit, 5 Clothing, 15 Color, 4 Season

pred testComplementaryOrAnalogousColors {
    let top = one Clothing, 
        bottom = one Clothing, 
        shoes = one Clothing, 
        accessory = one Clothing, 
        outerwear = one Clothing | 
        analogousOrWarmCool[Outfit] {
            -- Assigning complementary colors to items
            top.color = Red
            bottom.color = Cyan
            shoes.color = Yellow
            accessory.color = Blue
            outerwear.color = none -- Outerwear is not required for this test
        }
}

run testComplementaryOrAnalogousColors for 1 Outfit, 5 Clothing, 15 Color, 4 Season

pred testOutfitNoOuterwear {
    let top = one Clothing, 
        bottom = one Clothing, 
        shoes = one Clothing, 
        accessory = one Clothing | 
        analogousOrWarmCool[Outfit] {
            -- Assigning colors to items without outerwear
            top.color = Orange
            bottom.color = Yellow
            shoes.color = Red
            accessory.color = Rose
            outerwear.color = none
        }
}

run testOutfitNoOuterwear for 1 Outfit, 5 Clothing, 15 Color, 4 Season

// test suite for rgbValues {

//     assert rgbValuesTest is necessary for rgbValues
    
//     example validRGBValues1 is {rgbValues} for {
//         Color = `Red + `Green + `Blue
//         `Red.red = 255
//         `Red.green = 0
//         `Red.blue = 0
//         `Green.red = 0
//         `Green.green = 255
//         `Green.blue = 0
//         `Blue.red = 0
//         `Blue.green = 0
//         `Blue.blue = 255
//     }

//     example invalidRGBValues1 is {not rgbValues} for {
//         Color = `Red + `Green + `Blue
//         `Red.red = 300
//         `Red.green = 0
//         `Red.blue = 0
//         `Green.red = 0
//         `Green.green = 255
//         `Green.blue = 0
//         `Blue.red = 0
//         `Blue.green = 0
//         `Blue.blue = 255
//     }

//     example validRGBValues2 is {rgbValues} for {
//         Color = `Cyan + `Purple + `Rose
//         `Cyan.red = 0
//         `Cyan.green = 255
//         `Cyan.blue = 255
//         `Purple.red = 128
//         `Purple.green = 0
//         `Purple.blue = 255
//         `Rose.red = 255
//         `Rose.green = 0
//         `Rose.blue = 127
//     }

//     example invalidRGBValues2 is {not rgbValues} for {
//         Color = `Cyan + `Purple + `Rose
//         `Cyan.red = 255
//         `Cyan.green = 128
//         `Cyan.blue = 0
//         `Purple.red = 128
//         `Purple.green = 0
//         `Purple.blue = 250
//         `Rose.red = 128
//         `Rose.green = 0
//         `Rose.blue = 255
//     }
// }

// test suite for warmColor {
//     example validWarmColor is {some c: Color | warmColor[c]} for {
//         Red = `c
//     }

//     example invalidWarmColor is {some c: Color | warmColor[c]} for {
//         Chartreuse = `c
//     }
// }

// test suite for coolColor {

// }

// test suite for verifyWarmColors {

// }

// test suite for verifyCoolColors {

// }

// test suite for wellformedRGB {

// }

// test suite for complementaryColor {

// }

// test suite for complementaryRGB {

// }

// test suite for verifyComplementaryColors {

// }

// test suite for analogousColor {

// }

// test suite for analagousRGB {

// }

// test suite for verifyAnalogousColors {

// }

// test suite for triadicRGB {

// }

// test suite for triadicColor {

// }

// test suite for verifyTriadicColors {

// }

// ////////////////////////////////////////////////////////////
// // HELPER PREDS FOR ASSERTIONS
// ////////////////////////////////////////////////////////////

// pred rgbValuesTest {
//     all c: Color | {
//         (c = Red) implies (c.red = 255 and c.green = 0 and c.blue = 0)
//         (c = Green) implies (c.red = 0 and c.green = 255 and c.blue = 0)
//         (c = Blue) implies (c.red = 0 and c.green = 0 and c.blue = 255)
//     }
// }

// pred warmColorTest[c: Color] {
//     c in Red or c in Orange or c in Yellow or c in Rose
// }

// /*pred warmRGBTest[c: Color] {
//     // Warm colors have higher red and green values, and lower blue values
//     c.red > c.blue
//     c.green >= 0 and c.green <= 255
//     wellformedRGB[c]
// }

// pred coolColorTest[c: Color] {
//     c in Blue or c in Green or c in Cyan or c in Purple or c in SkyBlue or c in OceanGreen or c in Chartreuse or c in Magenta
// }

// pred coolRGBTest[c: Color] {
//     // Cool colors have higher blue and green values, and lower red values
//     c.blue >= c.red or c.green >= c.red
//     wellformedRGB[c]

// }

// // Ensure that predefined warm colors match their RGB definitions
// pred verifyWarmColorsTest[c: Color] {
//     warmColor[c] implies warmRGB[c]

// }

// // Ensure that predefined cool colors match their RGB definitions
// pred verifyCoolColorsTest[c: Color] {
//     coolColor[c] implies coolRGB[c]
// }

// pred wellformedRGBTest[c: Color] {
//     c.red >= 0 and c.red <= 255
//     c.green >= 0 and c.green <= 255
//     c.blue >= 0 and c.blue <= 255
// }


// pred complementaryColorTest[c1: Color, c2: Color] {
//     (c1 = Red and c2 = Cyan) or
//     (c1 = Green and c2 = Magenta) or
//     (c1 = Blue and c2 = Yellow) or
//     (c1 = Chartreuse and c2 = Purple) or
//     (c1 = OceanGreen and c2 = Rose) or
//     (c1 = Orange and c2 = SkyBlue) or
//     (c1 = Black and c2 = White) 
// }

// pred complementaryRGBTest[c1: Color, c2: Color] {
//     wellformedRGB[c1]
//     wellformedRGB[c2]

//     add[c1.red, c2.red] = 255
//     add[c1.green, c2.green] = 255
//     add[c1.blue, c2.blue] = 255
// }

// // Ensure that predefined complementary colors match their RGB definitions
// pred verifyComplementaryColorsTest[c1, c2: Color] {
//     complementaryColor[c1, c2] implies complementaryRGB[c1, c2]
// }


// // Define analogous color groups based on predefined sets
// pred analogousColorTest[c1: Color, c2: Color] {
    
//     (c1 = Red and c2 = Orange) or
//     (c1 = Orange and c2 = Yellow) or
//     (c1 = Magenta and c2 = Purple) or
//     (c1 = Rose and c2 = Magenta) or
//     (c1 = Purple and c2 = Blue) or
//     (c1 = Blue and c2 = SkyBlue) or
//     (c1 = SkyBlue and c2 = Cyan) or
//     (c1 = Chartreuse and c2 = Green) or
//     (c1 = Chartreuse and c2 = Yellow) or
//     (c1 = Rose and c2 = Red) or
//     (c1 = OceanGreen and c2 = Cyan) or
//     (c1 = Green and c2 = OceanGreen)

// }

// // Define analogous colors based on proximity in RGB values
// pred analogousRGBTest[c1: Color, c2: Color] {

//     wellformedRGB[c1]
//     wellformedRGB[c2]

// // Case 1: Red values are the same, and green and blue differ by ≤ 128
//     (c1.red = c2.red and c1.green = c2.green and abs[subtract[c1.blue, c2.blue]] <= 128) or
    
//     // Case 2: Green values are the same, and red and blue differ by ≤ 128
//     (c1.green = c2.green and abs[subtract[c1.red, c2.red]] <= 128 and c1.blue = c2.blue) or
    
//     // Case 3: Blue values are the same, and red and green differ by ≤ 128
//     (c1.blue = c2.blue and c1.red = c2.red and abs[subtract[c1.green, c2.green]] <= 128)
// }

// // Ensure that predefined analogous colors match their RGB definitions
// pred verifyAnalogousColorsTest[c1, c2: Color] {
//     analogousColor[c1, c2] implies analogousRGB[c1, c2]
// }


// pred triadicRGBTest[c1: Color, c2: Color, c3: Color] {
//     rgbValues
//     add[add[c1.red, c2.red], c3.red] >= 375
//     add[add[c1.red, c2.red], c3.red] <= 385

//     add[add[c1.green, c2.green], c3.green] >= 375
//     add[add[c1.green, c2.green], c3.green] <= 385

//     add[add[c1.blue, c2.blue], c3.blue] >= 375
//     add[add[c1.blue, c2.blue], c3.blue] <= 385


// }

// // Define triadic color groups based on predefined sets
// pred triadicColorTest[c1: Color, c2: Color, c3: Color] {
//     (c1 = Red and c2 = Green and c3 = Blue) or
//     (c1 = Green and c2 = Blue and c3 = Red) or
//     (c1 = Blue and c2 = Red and c3 = Green) or
//     (c1 = Orange and c2 = Purple and c3 = Cyan) or
//     (c1 = Purple and c2 = Cyan and c3 = Orange) or
//     (c1 = Cyan and c2 = Orange and c3 = Purple)
// }

// // Ensure that predefined triadic colors match their RGB definitions
// pred verifyTriadicColorsTest {
//     all c1, c2, c3: Color | triadicColor[c1, c2, c3] implies triadicRGB[c1, c2, c3]
// }

// // pred seasonalityColors {} */