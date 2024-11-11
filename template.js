const makeNumber = require('makeNumber');
const getType = require('getType');
const type = data.type;

if (data.number1.length <= 0 || data.number2.length <= 0 ) return undefined;

const number1 = makeNumber(data.number1);
const number2 = makeNumber(data.number2);

if (getType(number1) !== 'number' || getType(number2) !== 'number' || number1 !== number1 || number2 !== number2) {
  return undefined;
}

switch (type) {
  case 'multiply':
    return number1 * number2;
  case 'divide':
    return number2 !== 0 ? number1 / number2 : undefined;
  case 'add':
    return number1 + number2;
  case 'subtract':
    return number1 - number2;
  default:
    return undefined;
}
