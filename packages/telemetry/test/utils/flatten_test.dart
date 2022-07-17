import 'dart:convert';

import 'package:telemetry/src/api/utils/flatten.dart';
import 'package:test/test.dart';

void main() {
  test('should flatten ', () {
    print(map.flatten());
    print(customJson.flatten());
  });
}

final map = {
  'int': 1,
  'double': 1.0,
  'null': null,
  'bool': true,
  'string': 'text',
  'list': [
    1,
    1.0,
    true,
    null,
    [1],
    {1},
    {
      'int': 1,
      'double': 1.0,
      'null': null,
      'bool': true,
      'string': 'text',
      'list': [1],
      'set': {2},
      'map': {'el': 3}
    },
  ],
  'set': {
    1,
    1.0,
    true,
    null,
    [
      1,
      1.0,
      true,
      null,
      [
        1,
        1.0,
        true,
        null,
        [1],
        {2},
        {
          'int': 1,
          'double': 1.0,
          'null': null,
          'bool': true,
          'string': 'text',
          'list': [1],
          'set': {2},
          'map': {'el': 3}
        },
      ],
      {
        1,
        1.0,
        true,
        null,
        [1],
        {2},
        {
          'int': 1,
          'double': 1.0,
          'null': null,
          'bool': true,
          'string': 'text',
          'list': [1],
          'set': {2},
          'map': {'el': 3}
        },
      },
      {
        'int': 1,
        'double': 1.0,
        'null': null,
        'bool': true,
        'string': 'text',
        'list': [1],
        'set': {2},
        'map': {'el': 3}
      },
    ],
    {
      1,
      1.0,
      true,
      null,
      [1],
      {2},
      {
        'int': 1,
        'double': 1.0,
        'null': null,
        'bool': true,
        'string': 'text',
        'list': [1],
        'set': {2},
        'map': {'el': 3}
      },
    },
    {
      'int': 1,
      'double': 1.0,
      'null': null,
      'bool': true,
      'string': 'text',
      'list': [
        1,
        1.0,
        true,
        null,
        [1],
        {2},
        {
          'int': 1,
          'double': 1.0,
          'null': null,
          'bool': true,
          'string': 'text',
          'list': [1],
          'set': {2},
          'map': {'el': 3}
        },
      ],
      'set': {1},
      'map': {'el': 3}
    },
  },
  'map': {
    {
      'int': 1,
      'double': 1.0,
      'null': null,
      'bool': true,
      'string': 'text',
      'list': [1],
      'set': {2},
      'map': {'el': 3}
    }
  }
};

final customJson = jsonDecode('''{
  "taught": 473163006,
  "bar": {
    "expression": {
      "if": "location",
      "captured": 1719911169,
      "production": false,
      "telephone": "hundred",
      "passage": false,
      "themselves": "group",
      "drive": -1080491468,
      "information": {
        "lying": false,
        "actual": false,
        "gas": "belong",
        "express": "information",
        "cattle": "load",
        "apartment": "shallow",
        "needle": -1766760697,
        "live": "both",
        "peace": true,
        "all": "knew"
      },
      "drink": {
        "fact": {
          "fewer": "news",
          "care": {
            "rate": {
              "dead": false,
              "go": -1030278447,
              "factor": -814085880.193563,
              "due": -965483267,
              "lost": {
                "low": true,
                "plate": true,
                "fat": -153206004.7929616,
                "bat": 201986644.14088106,
                "tank": "fair",
                "gravity": {
                  "fell": true,
                  "instead": 1522157691,
                  "setting": false,
                  "vote": "must",
                  "sudden": -1214785289.0918236,
                  "see": {
                    "concerned": {
                      "broad": false,
                      "school": 1037196806.4436922,
                      "duty": false,
                      "sail": 1345484509.437294,
                      "independent": true,
                      "shaking": "jar",
                      "home": "cloud",
                      "partly": {
                        "zero": true,
                        "arrow": -1474898502.2985096,
                        "us": {
                          "image": "bank",
                          "capital": 1637400580,
                          "earn": 810956641.8687286,
                          "interior": false,
                          "surface": "experiment",
                          "slip": {
                            "doing": 1237427036,
                            "trip": "warm",
                            "prevent": "audience",
                            "hunt": {
                              "agree": "mad",
                              "hollow": true,
                              "duty": {
                                "alone": true,
                                "needle": "triangle",
                                "piano": {
                                  "simple": false,
                                  "want": {
                                    "chief": "well",
                                    "else": 357042336,
                                    "port": -302674853.1683197,
                                    "attack": {
                                      "fine": {
                                        "value": 477330691.10026836,
                                        "greatest": true,
                                        "occasionally": 659071442,
                                        "wooden": -1616296964.1248322,
                                        "western": false,
                                        "blanket": {
                                          "grain": "population",
                                          "depth": {
                                            "ran": 2122207002,
                                            "difference": {
                                              "situation": "teeth",
                                              "neighbor": false,
                                              "age": "birds",
                                              "bee": {
                                                "declared": {
                                                  "brown": {
                                                    "rock": "floor",
                                                    "second": {
                                                      "ought": false,
                                                      "writer": true,
                                                      "describe": 1755463735,
                                                      "them": "opposite",
                                                      "forth": true,
                                                      "loud": "lower",
                                                      "machinery": -1200849680.6725082,
                                                      "clear": false,
                                                      "exchange": "travel",
                                                      "fifth": false
                                                    },
                                                    "service": "happy",
                                                    "any": {
                                                      "captured": {
                                                        "obtain": {
                                                          "date": 1661189107.4288902,
                                                          "fed": {
                                                            "line": true,
                                                            "listen": 178140950.7915492,
                                                            "needed": {
                                                              "television": {
                                                                "travel": 743732013.8173313,
                                                                "atom": "between",
                                                                "subject": "result",
                                                                "recall": 1758219885,
                                                                "running": "system",
                                                                "quiet": -1331061905,
                                                                "chart": "select",
                                                                "mice": "last",
                                                                "locate": "near",
                                                                "last": true
                                                              },
                                                              "closely": "pattern",
                                                              "drink": false,
                                                              "system": "if",
                                                              "fly": 1119004891.9442558,
                                                              "wheat": false,
                                                              "lie": -1436831185,
                                                              "happy": "spread",
                                                              "square": false,
                                                              "sides": true
                                                            },
                                                            "value": 1563511302,
                                                            "thy": 493918436,
                                                            "surrounded": false,
                                                            "dried": false,
                                                            "nine": "structure",
                                                            "fill": "joined",
                                                            "proper": true
                                                          },
                                                          "using": "not",
                                                          "needle": 384728182.963305,
                                                          "muscle": "disappear",
                                                          "sound": false,
                                                          "smooth": "spider",
                                                          "breathing": 2079431979,
                                                          "twice": "blow",
                                                          "finest": false
                                                        },
                                                        "somebody": -1468433006.828886,
                                                        "trip": false,
                                                        "sent": "observe",
                                                        "explore": -261196449.76220655,
                                                        "likely": true,
                                                        "equator": true,
                                                        "sound": -503652475,
                                                        "equally": -78435734.4828682,
                                                        "repeat": "bent"
                                                      },
                                                      "ready": -1948620959,
                                                      "plenty": false,
                                                      "each": 1721870427,
                                                      "mark": "brother",
                                                      "me": 1969947917,
                                                      "eleven": -1859786811.504859,
                                                      "ranch": -2116091678.4510083,
                                                      "average": "symbol",
                                                      "hung": -498321989
                                                    },
                                                    "soon": "event",
                                                    "mud": false,
                                                    "difficulty": "trap",
                                                    "tight": "mostly",
                                                    "go": "call",
                                                    "cross": "stems"
                                                  },
                                                  "exactly": "unhappy",
                                                  "wish": "yourself",
                                                  "rod": -492950637,
                                                  "famous": -1077427337,
                                                  "run": false,
                                                  "did": 1702659541.244885,
                                                  "people": "acres",
                                                  "many": -1365785850,
                                                  "fun": 1764901486
                                                },
                                                "upper": "chemical",
                                                "touch": "separate",
                                                "chosen": -1519527103,
                                                "chicken": -1518423778,
                                                "lead": true,
                                                "by": true,
                                                "tears": -1648510465.9704366,
                                                "straight": "hang",
                                                "concerned": "verb"
                                              },
                                              "express": false,
                                              "card": -1570929588,
                                              "middle": false,
                                              "repeat": true,
                                              "meet": false,
                                              "by": false
                                            },
                                            "fox": -955679766,
                                            "information": "divide",
                                            "fur": true,
                                            "cowboy": -240931008.70814514,
                                            "did": 91079050,
                                            "yellow": true,
                                            "large": 1518413711.6783814,
                                            "tent": "climb"
                                          },
                                          "state": "all",
                                          "cabin": -894727463,
                                          "tell": true,
                                          "one": 1149504051,
                                          "rain": -1890964562.8162951,
                                          "railroad": -982983578.6653924,
                                          "needed": false,
                                          "sold": true
                                        },
                                        "does": "attack",
                                        "prize": true,
                                        "product": false
                                      },
                                      "melted": 697677997,
                                      "deer": "tribe",
                                      "better": "caught",
                                      "at": "broke",
                                      "oxygen": true,
                                      "women": "method",
                                      "thought": true,
                                      "cause": "women",
                                      "those": true
                                    },
                                    "folks": -79576781.38100338,
                                    "sunlight": -1941116739.307777,
                                    "perfectly": false,
                                    "horse": "noon",
                                    "opposite": true,
                                    "castle": true
                                  },
                                  "sometime": "trick",
                                  "cheese": true,
                                  "putting": -666306355,
                                  "remain": 94902260,
                                  "weight": "noted",
                                  "bound": "judge",
                                  "difference": "research",
                                  "ground": -2133567100.925712
                                },
                                "excited": -178611449.08777475,
                                "mission": false,
                                "dug": false,
                                "clothing": 741090731,
                                "behind": false,
                                "onto": false,
                                "chief": false
                              },
                              "history": "inside",
                              "choice": true,
                              "lot": true,
                              "object": "whatever",
                              "try": 233400609.52419376,
                              "oil": false,
                              "prepare": -834225913.0951447
                            },
                            "kids": false,
                            "usual": true,
                            "wonder": "stretch",
                            "health": -2016673458,
                            "shake": "breath",
                            "cold": true
                          },
                          "dog": 2009038717,
                          "saved": -1450789636.734933,
                          "rose": true,
                          "relationship": "sleep"
                        },
                        "wait": true,
                        "storm": "seen",
                        "account": "sight",
                        "lucky": 1036655486.3246393,
                        "supply": -1577724848,
                        "nervous": false,
                        "busy": true
                      },
                      "pound": false,
                      "arrange": 284260652
                    },
                    "percent": false,
                    "press": 2007287133,
                    "nine": true,
                    "tell": -1993517254,
                    "huge": -2106033348,
                    "quarter": "he",
                    "per": 410866404,
                    "size": "whenever",
                    "opportunity": 1265286948
                  },
                  "courage": "bill",
                  "perhaps": false,
                  "teeth": 432273843,
                  "shape": -250599230
                },
                "drew": "coach",
                "catch": "worry",
                "captured": false,
                "union": "browserling"
              },
              "bear": true,
              "bar": true,
              "hungry": 1908258587,
              "next": true,
              "east": 319999827.33609295
            },
            "lady": 2088800721.1711116,
            "audience": "affect",
            "differ": true,
            "motor": 1383097337.9331985,
            "source": true,
            "nice": "force",
            "fierce": false,
            "certain": -1618274964,
            "live": "production"
          },
          "high": false,
          "famous": true,
          "partly": -1669298794.4085536,
          "gradually": "plural",
          "needs": -2040290382.013897,
          "hospital": -1934653305.723084,
          "child": "happily",
          "planned": 1959581132.1504226
        },
        "husband": 1997403521.9696002,
        "route": true,
        "mother": 178767370.9856515,
        "follow": -1161093661.2580266,
        "anywhere": "sight",
        "memory": "fall",
        "cold": "sleep",
        "against": true,
        "thus": "occasionally"
      },
      "religious": 111118696.78200245
    },
    "range": false,
    "production": "hurt",
    "physical": 581397589.5876546,
    "review": "refer",
    "wheat": false,
    "something": false,
    "dull": "sound",
    "shelf": 1065229010,
    "dot": "clear"
  },
  "grade": 1203978966.246863,
  "now": "outline",
  "judge": "rocket",
  "outline": 435700331.4004774,
  "disappear": "position",
  "fight": "felt",
  "ocean": true,
  "unhappy": "finish"
}''') as Map;
