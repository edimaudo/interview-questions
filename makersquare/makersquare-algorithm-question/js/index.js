function greaterZero(value) {
  return value > 0;
}

function findSmallestDifference(arr) {
  tempArray = [];
  for (var i = 0; i < arr.length; i++) {
    for (var j = 0; j < arr.length; j++) {
      if (arr[i] != arr[j]) {
        tempArray.push(arr[j] - arr[i]);
      }
    }
  } 
  return Math.min.apply(Math, tempArray.filter(greaterZero));
};

var result = findSmallestDifference([100, 500, 300, 1000, -200, 990]);
console.log(result);