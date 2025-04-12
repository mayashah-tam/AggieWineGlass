//
//  WineDataInfo.swift
//  AggieWineGlass
//
//  Created by Maya Shah on 4/8/25.
//

import Combine

class WineDataInfo: ObservableObject {
    @Published var uniqueCategories: Set<String>
    @Published var uniqueFlavorProfiles: Set<String>
    @Published var uniquePairings: Set<String>
    @Published var uniqueFlavorSpecifics: Set<String>
    @Published var uniqueRegionClasses: Set<String>
    @Published var wines: [Wine]
    @Published var flavorMap: [String: Set<String>]

    init(uniqueCategories: Set<String> = [],
         uniqueFlavorProfiles: Set<String> = [],
         uniqueFlavorSpecifics: Set<String> = [],
         uniquePairings: Set<String> = [],
         uniqueRegionClasses: Set<String> = [],
         wines: [Wine] = []) {
        
        self.uniqueCategories = uniqueCategories
        self.uniqueFlavorProfiles = uniqueFlavorProfiles
        self.uniqueFlavorSpecifics = uniqueFlavorSpecifics
        self.uniquePairings = uniquePairings
        self.uniqueRegionClasses = uniqueRegionClasses
        self.wines = wines
        self.flavorMap = [
            "earth": [
                "clay pot", "fresh asphalt", "volcanic rock", "stone", "ginger", "petroleum", "wet asphalt", "beeswax",
                "wet gravel", "iron", "smoked meats", "clay dust", "ground coffee", "granite dust", "kerosene", "earthy",
                "pastrami", "wood ear", "saline", "smoke", "tree bark", "exotic spice", "chewing tobacco", "honeycomb",
                "slate", "grilled meat", "new leather", "crushed rocks", "forest floor", "minerals", "chalk", "potting soil",
                "pencil shavings", "charcoal", "plastic", "gun smoke", "crushed gravel", "graphite", "flint", "balsamic",
                "oolong tea", "mushroom broth", "ash", "pencil lead", "roasted meat", "chalk dust", "seashell", "petrichor",
                "cured meat", "caramel popcorn", "game", "quinine", "chutney", "leather", "mushroom", "honey", "tar",
                "dried leaves", "barbecue meat", "wet slate", "bacon fat", "barbecue smoke", "truffle", "rubber", "salt",
                "citrus oil", "beef broth", "cocoa", "forest mushroom", "pine bark", "tobacco leaf", "black truffle",
                "wet concrete", "lanolin", "underbrush", "wax"
            ],
            "floral": [
                "peony", "dried rose", "daffodil", "jasmine", "potpourri", "lily", "baby's breath", "dandelion", "acacia",
                "iris", "geranium", "orange blossom", "perfume", "dried flowers", "rose petal", "elderflower", "chamomile",
                "citrus blossom", "lilac", "wild iris", "violet", "apple blossom", "magnolia", "gardenia", "honeysuckle",
                "hibiscus", "rose water", "lavender", "rose hip"
            ],
            "microbio": [
                "campfire", "sourdough", "bread yeast", "banana", "curd", "parmesan cheese", "cheese", "lemon curd", "cream",
                "lager", "cheesy", "fresh bread", "sweaty", "creme fraiche", "yeast", "oil", "yogurt", "salted butter",
                "toasted bread"
            ],
            "tropical_fruit": [
                "tamarind", "grilled pineapple", "jackfruit", "bubblegum", "kiwi", "papaya", "lychee", "starfruit", "tropical",
                "pineapple", "fruit cup", "green mango", "mango", "green pineapple", "guava", "passion fruit", "green papaya"
            ],
            "citrus_fruit": [
                "citrus zest", "lemon pith", "grapefruit", "lemon", "orange peel", "mandarin orange", "meyer lemon", "orange",
                "pomello", "tangerine", "pink grapefruit", "lime", "orange zest", "citrus", "lemon peel", "lime peel",
                "orange rind", "blood orange", "marmalade", "grapefruit pith", "lime zest", "preserved lemon", "key lime",
                "lemon zest"
            ],
            "dried_fruit": [
                "prune", "dried apricot", "dried mango", "fig", "black raisin", "dried blueberry", "quince paste", "dried fruit",
                "dragon fruit", "dried cranberry", "medjool date", "yellow raisin", "mission fig", "golden raisin",
                "dried blackberry", "fruitcake", "raisin"
            ],
            "tree_fruit": [
                "canned peach", "bruised apple", "quince", "baked apple", "apricot jam", "apricot", "white nectarine",
                "green apple", "spiced pear", "melon", "fresh grapes", "peach preserves", "apple", "peach", "mirabelle plum",
                "green pear", "persimmon", "asian pear", "pear", "unripe pear", "stone fruit", "yellow apple", "white peach",
                "unripe peach", "pink lady apple", "melon rind", "honeydew melon", "green fig", "cantaloupe", "yellow plum",
                "nectarine", "green melon", "yellow peach", "stewed apricot"
            ],
            "oak": [
                "vanilla", "cigar box", "toffee", "wood smoke", "sweet tobacco", "incense", "buttered popcorn", "camphor",
                "espresso", "fudge", "pie crust", "mocha", "oak", "cigar", "coffee", "brown bread", "gingersnap", "dill",
                "fresh coconut", "nutmeg", "brown butter", "pastry", "cola", "cocoa nib", "coconut", "baking spice",
                "sandalwood", "toasted marshmallow", "baking chocolate", "butter", "allspice", "butterscotch", "creme brulee",
                "coconut oil", "cedar", "pipe tobacco", "dark chocolate", "milk chocolate", "chocolate", "clove", "tobacco",
                "caramel", "hickory"
            ],
            "vegetal": [
                "castelvetrano olive", "rhubarb", "red beet", "red bell pepper", "roasted pepper", "arugula", "chard",
                "cat's pee", "grass", "asparagus", "tomato leaf", "wheat grass", "green almond", "radicchio", "gooseberry",
                "green bell pepper", "fresh-cut grass", "pea shoot", "tomato", "green bean", "chervil", "sun-dried tomato",
                "bitter almond", "snap pea", "hay", "bell pepper", "celery", "earl grey tea", "straw"
            ],
            "black_fruit": [
                "plum", "bramble", "berry jam", "roasted plum", "hoisin", "sugarplum", "dark fruit", "blackberry jam",
                "wild blueberry", "black raspberry", "olive tapenade", "boysenberry", "blackberry sauce", "ripe blackberry",
                "bilberry", "blueberry", "mulberry", "plum sauce", "black fruit", "grape jam", "berry sauce", "blackberry",
                "sour plum", "cassis", "blackcurrant", "black cherry", "blackcurrant jam", "acai berry", "black plum",
                "kalamata olive", "spiced plum", "marionberry", "black olive", "jam"
            ],
            "non_oak": [
                "hazelnut cream", "dried fig", "peanut shell", "toasted nuts", "peanut", "maple syrup", "biscuit", "teriyaki",
                "walnut oil", "brown sugar", "sassafras", "carob", "pine nut", "brazil nut", "toasted almond", "black walnut",
                "walnut", "spice cake", "marzipan", "hazelnut", "roasted hazelnut", "chestnut", "toast", "peanut brittle",
                "molasses", "burnt sugar", "brioche", "nutty", "almond", "pecan", "roasted almond", "graham cracker",
                "burnt caramel"
            ],
            "red_fruit": [
                "dried strawberry", "bing cherry", "strawberry sauce", "morello cherry", "fresh strawberry", "wild strawberry",
                "ripe strawberry", "cherry", "red fruit", "red currant", "raspberry", "maraschino cherry", "red plum",
                "white cherry", "sour cherry", "red cherry", "pomegranate", "cherry cough syrup", "huckleberry", "watermelon",
                "cranberry", "red huckleberry", "fruit punch", "red-berry jam", "fruit roll-up", "cherry syrup", "cherry cola",
                "sour cherry pie", "raspberry sauce", "strawberry", "cotton candy", "roasted tomato"
            ],
            "spices": [
                "mustard seed", "cracked pepper", "green cardamom", "eucalyptus", "marjoram", "jasmine green tea",
                "candied ginger", "rooibos", "coriander", "thai basil", "curry spice", "anise", "pink peppercorn", "menthol",
                "aleppo pepper", "green herbs", "aniseed", "jalapeno", "white pepper", "juniper", "sage", "rosemary", "fennel",
                "yerba mate", "black licorice", "gingerbread", "bergamot", "mace", "vanilla bean", "cinnamon", "matcha",
                "5-spice powder", "mint", "musk", "tarragon", "thyme", "chili pepper", "fennel seed", "savory", "juniper berry",
                "bay leaf", "star anise", "licorice", "green peppercorn", "lemon grass", "pepper", "red licorice",
                "dried herbs", "szechuan peppercorn", "oregano", "dried rosemary"
            ]
        ]
    }
}
