//phase 1
function decryptA(message) {
  var tempval = [];
  for (var j = 0; j < message.length; j++) {
    tempval = message.split(" ");
  }

  var strval = "";
  for (var i = 0; i < tempval.length; i++) {
    strval += tempval[i].slice(-1);
  }

  return strval;
}

var result1 = decryptA("laugh ride lol hall bozo")
//console.log(result1) // This should be "hello"

var result2 = decryptA("dog polo boo sudd noob smiley ride")
//console.log(result2) // This should be "goodbye"

//phase 2
function decryptB(message) {
  var tempArray = [];
  for (var j = 0; j < message.length; j++) {
    tempArray = message.split(" ");
  }

  var strval = "";
  for (var i = 0; i < tempArray.length; i++) {
    if (tempArray[i][0] > tempArray[i].slice(-1)) {
      strval += tempArray[i][0];
    } else {
      strval += tempArray[i].slice(-1);
    }
  }

  return strval;
}

//tests
var result1 = decryptB("wazdee apple love bic nooo more end")
//console.log(result1) // This should be "welcome"

var result2 = decryptB("bria loud fuzu antidote")
//console.log(result2) // This should be "blue"

// phase 3
function encrypt(message) {

}

function decrypt(message) {

}