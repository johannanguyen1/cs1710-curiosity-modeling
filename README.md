# Curiosity-Modeling---Wardrobe
# README: Essential Wardrobe Model

Project Objective: 
This project models a wardrobe system where clothing items (tops, bottoms, shoes, outerwear, and accessories) are categorized and described by attributes such as color, season, and formality. Our objective is to create valid outfits, which are described by color harmony and seasonal/formality matching. For example, a valid summer, casual outfit would contain a top, bottom, shoes, and accessories categorized in the summer season and casual formality. Our model also contains color relationships like complementary, analogous, and neutral colors, and ensures that each valid outfit fulfils one of these color relationships. We explicitly define which color pairings conform to each relationship, but we reenforce these definitions through RGB calculations.


Model Design and Visualization: 
The main three components of our model outline clothing, color relationships, and outfit composition. 

clothing: includes attributes for category (top, bottom, shoes, etc.), color, season, and formality. 

color relationships: ensure predefined colors have valid RGB values and follow relationships like complementary and analogous color schemes

outfit composition: a signature embodying a collection of clothing items; the predicates ensure that an outfit is well-formed by checking compatibility between clothing categories, colors, and seasons

The default Sterling visualizer is used to display the model, but we understand that a custom visualization would be useful to show the different articles of clothing and their colors in valid outfits. However, we don't know javascript :/. The visualized instances show a set of clothing items, with each having a category, color, and other attributes. You, the viewer, are able to observe the attributes of each article of clothing and when they are used to form an outfit. To analyze the correctness of our outfit formations, you can track the when each article of clothing is used in an outfit and then manually check the attributes of each article to see that they belong to the same season, formality, and their colors form a color relationship. 

We wrote checks for our explicit definitions of color relationships with RGB calculations predicates. The run statement used model a full wardrobe, detailing the seasons number of seasons, formalities, outfits, articles of clothing, and colors.

Signatures and Predicates: 

Sigs: 
- Clothing: Represents a clothing item with attributes like category, color, season, and formality.
- Category, Color, Season, Formality: Abstract signatures defining types for clothing categories, colors, seasons, and formality levels. 
    - One sigs are used to specify each choice for these abstract sigs, acting like enums. 
- Outfit: A collection of clothing items that represent a complete outfit.

Preds: 
- Color Predicates: 
    - ColorRGB Predicates: Ensure that colors follow valid RGB ranges and relationships, such as complementary and analogous pairs.
    - Color Definition Predicates: Define explicitly what colors belong in which relationship. For example, stating Blue and Yellow are complementary colors (based on the RGB Color wheel).
- Outfit Predicates: Ensure that outfits are well-formed by checking the compatibility of top, bottom, shoes, outerwear, and accessories based on their categories, colors, and seasons. 
    - Some specifics: 
        - Outerwear is only in the outfit if the season is winter or fall. 
        - Multiple accessories can be used. 
- Matching Predicates: Check if the items in the outfit match in terms of formality and seasonality. 

Testing: What tests did you write to test your model itself? What tests did you write to verify properties about your domain area? Feel free to give a high-level overview of this.

We tested within our model with predicates. For example, we have two predicates per color relationship, and use a verify________Colors to enforce that the definitions of our colors align with their mathematical calculation using RGB values. Our verifyAnalogousColors and verifyComplementaryColors guarantee that the two colors specified fit the properties of analogous and complementary colors mathematically if we define the color itself to be complementary or analogous. Our wellformed outfit predicate is fed into our wardroneHasValidOutfits predicates, in addition to our other properties of having a valid outfit, ensure that all the outfits are wellformed when we look in the Sterling visualization. We implement the same concept for RGB values when we define constraints for the numerical values such as ensuring positive values and within in the bounds 0 and 255. After creating run statements for our testing and validation predicates, we were able to observe the tables in the Sterling visualizations to ensurre wellformedness.



