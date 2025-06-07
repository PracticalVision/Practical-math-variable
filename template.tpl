___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "displayName": "Practical Math",
  "description": "Perform a sequence of mathematical operations starting from a single value. Supports chaining, rounding, absolute conversion, and custom zero-result handling.",
  "containerContexts": [
    "SERVER"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "starting_value",
    "displayName": "Starting Value",
    "simpleValueType": true,
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ],
    "help": "Enter the number that all calculations will start from"
  },
  {
    "type": "SIMPLE_TABLE",
    "name": "calculations_table",
    "displayName": "Calculations Table",
    "simpleTableColumns": [
      {
        "defaultValue": "",
        "displayName": "Operation",
        "name": "operation",
        "type": "SELECT",
        "selectItems": [
          {
            "value": "multiply",
            "displayValue": "* (Multiply)"
          },
          {
            "value": "divide",
            "displayValue": "/ (Divide)"
          },
          {
            "value": "add",
            "displayValue": "+ (Add)"
          },
          {
            "value": "subtract",
            "displayValue": "- (Subtract)"
          }
        ],
        "help": "Pick the math action for this step"
      },
      {
        "defaultValue": "",
        "displayName": "Number",
        "name": "number",
        "type": "TEXT",
        "help": "The operand applied with the chosen operation"
      },
      {
        "defaultValue": "",
        "displayName": "Note / Explanation",
        "name": "note",
        "type": "TEXT",
        "valueValidators": [],
        "help": "Optional description for this step"
      }
    ],
    "newRowButtonText": "Add Step",
    "alwaysInSummary": true,
    "help": "Add each operation in the exact order it should run on the result"
  },
  {
    "type": "GROUP",
    "name": "result_manipulation",
    "displayName": "Result Manipulation",
    "groupStyle": "NO_ZIPPY",
    "subParams": [
      {
        "type": "CHECKBOX",
        "name": "enable_rounding",
        "checkboxText": "Round Result",
        "simpleValueType": true,
        "subParams": [
          {
            "type": "SELECT",
            "name": "rounding_mode",
            "displayName": "Rounding Mode",
            "macrosInSelect": false,
            "selectItems": [
              {
                "value": "round_closest",
                "displayValue": "Round Closest"
              },
              {
                "value": "round_up",
                "displayValue": "Round Up"
              },
              {
                "value": "round_down",
                "displayValue": "Round Down"
              }
            ],
            "simpleValueType": true,
            "enablingConditions": [
              {
                "paramName": "enable_rounding",
                "paramValue": true,
                "type": "EQUALS"
              }
            ],
            "valueValidators": [
              {
                "type": "NON_EMPTY"
              }
            ],
            "help": "Choose how the rounding should behave when enabled"
          },
          {
            "type": "SELECT",
            "name": "decimal_places",
            "displayName": "Decimal Places",
            "macrosInSelect": false,
            "selectItems": [
              {
                "value": 0,
                "displayValue": "0"
              },
              {
                "value": 1,
                "displayValue": "1"
              },
              {
                "value": 2,
                "displayValue": "2"
              },
              {
                "value": 3,
                "displayValue": "3"
              },
              {
                "value": 4,
                "displayValue": "4"
              },
              {
                "value": 5,
                "displayValue": "5"
              },
              {
                "value": 6,
                "displayValue": "6"
              },
              {
                "value": 7,
                "displayValue": "7"
              }
            ],
            "simpleValueType": true,
            "help": "Select how many decimal places to keep after rounding",
            "enablingConditions": [
              {
                "paramName": "enable_rounding",
                "paramValue": true,
                "type": "EQUALS"
              }
            ]
          }
        ],
        "help": "Enable rounding of the final result"
      },
      {
        "type": "CHECKBOX",
        "name": "enable_zero_transform",
        "checkboxText": "Transform 0 to",
        "simpleValueType": true,
        "subParams": [
          {
            "type": "SELECT",
            "name": "zero_transform_value",
            "displayName": "",
            "macrosInSelect": false,
            "selectItems": [
              {
                "value": "undefined_value",
                "displayValue": "undefined"
              },
              {
                "value": false,
                "displayValue": "false"
              },
              {
                "value": "other",
                "displayValue": "Other"
              }
            ],
            "simpleValueType": true,
            "valueValidators": [
              {
                "type": "NON_EMPTY"
              }
            ],
            "enablingConditions": [
              {
                "paramName": "enable_zero_transform",
                "paramValue": true,
                "type": "EQUALS"
              }
            ]
          },
          {
            "type": "TEXT",
            "name": "transform_0_to_other",
            "displayName": "",
            "simpleValueType": true,
            "enablingConditions": [
              {
                "paramName": "zero_transform_value",
                "paramValue": "other",
                "type": "EQUALS"
              }
            ]
          }
        ],
        "help": "Convert a final result of 0 into another value"
      },
      {
        "type": "CHECKBOX",
        "name": "use_absolute_value",
        "checkboxText": "Absolute Number",
        "simpleValueType": true,
        "help": "Convert the final result to its absolute value"
      }
    ],
    "help": "Optional transformations that run after all calculations are complete"
  },
  {
    "type": "GROUP",
    "name": "Credits",
    "displayName": ".",
    "groupStyle": "NO_ZIPPY",
    "subParams": [
      {
        "type": "LABEL",
        "name": "Practical Vision",
        "displayName": "Made with care \u0026 ❤️ by Practical Vision ✔️"
      },
      {
        "type": "LABEL",
        "name": "Stape",
        "displayName": "Based on the original work by Stape 🟧"
      }
    ]
  }
]


___SANDBOXED_JS_FOR_SERVER___

const makeNumber = require('makeNumber');
const getType    = require('getType');
const Math       = require('Math');

// 1. Validate starting value
const start = makeNumber(data.starting_value);
if (getType(start) !== 'number' || start !== start) return undefined; // NaN guard

let result = start;
const table = data.calculations_table;

// 2. Run the calculation steps
if (getType(table) === 'array') {
  for (let i = 0; i < table.length; i++) {
    const row = table[i];
    if (getType(row) !== 'object') return undefined;

    const op  = row.operation;
    const num = makeNumber(row.number);

    if (!op || getType(num) !== 'number' || num !== num) return undefined;

    switch (op) {
      case 'multiply':
        result = result * num;
        break;
      case 'divide':
        if (num === 0) return undefined;
        result = result / num;
        break;
      case 'add':
        result = result + num;
        break;
      case 'subtract':
        result = result - num;
        break;
      default:
        return undefined;
    }
  }
}

// 3. Absolute value if requested
if (data.use_absolute_value === true) {
  result = Math.abs(result);
}

// 4. Rounding (with decimal places) if requested
if (data.enable_rounding === true) {
  const mode     = data.rounding_mode;
  let decimals   = makeNumber(data.decimal_places);
  if (getType(decimals) !== 'number' || decimals !== decimals || decimals < 0) decimals = 0;
  if (decimals > 7) decimals = 7;                    // UI limit
  const factor = Math.pow(10, decimals);

  switch (mode) {
    case 'round_closest':
      result = Math.round(result * factor) / factor;
      break;
    case 'round_up':
      result = Math.ceil(result * factor) / factor;
      break;
    case 'round_down':
      result = Math.floor(result * factor) / factor;
      break;
    default:
      return undefined;                              // invalid mode
  }
}

// 5. Zero-transform if requested and result is exactly 0
if (data.enable_zero_transform === true && result === 0) {
  switch (data.zero_transform_value) {
    case 'undefined_value':
      return undefined;
    case false:
    case 'false':
      return false;
    case 'other':
      if (data.transform_0_to_other && data.transform_0_to_other.length > 0) {
        return data.transform_0_to_other;
      }
      return undefined;
    default:
      return undefined;
  }
}

return result;


___TESTS___

scenarios: []


___NOTES___

Created on 8/15/2024, 12:08:53 PM


