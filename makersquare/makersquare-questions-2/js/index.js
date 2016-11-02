  var inventory = {
    product: {
      money: 1000,
      cookies: 0
    },
    ingredients: {
      sugar: 10,
      flour: 10
    },
    pot: {
      sugar: 0,
      flour: 0
    }
  };

  $(document).ready(function() {
    //get current inventory information
    document.getElementsByClassName("money")[0].innerHTML = inventory.product.money;
    document.getElementsByClassName("cookies")[0].innerHTML = inventory.product.cookies;
    document.getElementsByClassName("sugar")[0].innerHTML = inventory.ingredients.sugar;
    document.getElementsByClassName("flour")[0].innerHTML = inventory.ingredients.flour;
    document.getElementsByClassName("sugar")[1].innerHTML = inventory.pot.sugar;
    document.getElementsByClassName("flour")[1].innerHTML = inventory.pot.flour;

    $(".use-sugar").click(function() {
      //input
      var sugarIng = getInput("sugar", 0);
      var sugarPot = getInput("sugar", 1);

      //output    
      document.getElementsByClassName("sugar")[0].innerHTML = ingredientPot(parseInt(sugarIng), parseInt(sugarPot), "ingredient");
      document.getElementsByClassName("sugar")[1].innerHTML = ingredientPot(parseInt(sugarIng), parseInt(sugarPot), "pot");

    });

    $(".buy-sugar").click(function() {

      //input 
      var moneyval = getInput("money", 0);
      var sugarIng = getInput("sugar", 0);
      var buySugar = [];
      buySugar = buyItem(parseInt(moneyval), parseInt(sugarIng), "sugar");

      //output 
      document.getElementsByClassName("money")[0].innerHTML = buySugar[0];
      document.getElementsByClassName("sugar")[0].innerHTML = buySugar[1];

    });

    $(".use-flour").click(function() {
      //input
      var flourIng = getInput("flour", 0);
      var flourPot = getInput("flour", 1);

      //output
      document.getElementsByClassName("flour")[0].innerHTML = ingredientPot(parseInt(flourIng), parseInt(flourPot), "ingredient");
      document.getElementsByClassName("flour")[1].innerHTML = ingredientPot(parseInt(flourIng), parseInt(flourPot), "pot");
    });

    $(".buy-flour").click(function() {
      var moneyval = getInput("money", 0);
      var flourIng = getInput("flour", 0);
      var buyFlour = [];
      buyFlour = buyItem(parseInt(moneyval), parseInt(flourIng), "flour");

      //output 
      document.getElementsByClassName("money")[0].innerHTML = buyFlour[0];
      document.getElementsByClassName("flour")[0].innerHTML = buyFlour[1];

    });

    $(".cook-Cookie").click(function() {
      //input
      var sugarIng = getInput("sugar", 0);
      var flourIng = getInput("flour", 0);
      var cookie = parseInt(document.getElementsByClassName("cookies")[0].innerHTML);
      var sugarFlour = [];
      sugarFlour = cookCookie(parseInt(sugarIng), parseInt(flourIng), parseInt(cookie));

      //output
      document.getElementsByClassName("sugar")[0].innerHTML = sugarFlour[0];
      document.getElementsByClassName("flour")[0].innerHTML = sugarFlour[1];
      document.getElementsByClassName("cookies")[0].innerHTML = sugarFlour[2];

    });
    //add ingredients to pot
    function ingredientPot(ingramount, potamount, type) {
      if (ingramount == 0 && type == "ingredient") {
        return ingramount;
      } else if (type == "ingredient") {
        return ingramount - 1;
      } else if (ingramount == 0 && type == "pot") {
        return potamount;
      } else if (type == "pot") {
        return potamount + 1;
      }
    }

    //get class input info
    function getInput(classname, position) {
      if (document.getElementsByClassName(classname)[position].innerHTML == null) {
        return "0";
      } else {
        return document.getElementsByClassName(classname)[position].innerHTML;
      }
    }

    //cook a cookie function
    function cookCookie(sugarAmount, flourAmount, cookieAmount) {
      tempval = [];
      if (flourAmount - 6 < 0 || sugarAmount - 3 < 0) {
        tempval.push(sugarAmount);
        tempval.push(flourAmount);
        tempval.push(cookieAmount)
        return tempval;
      } else {
        tempval.push(sugarAmount - 3);
        tempval.push(flourAmount - 6);
        tempval.push(cookieAmount + 1)
        return tempval;
      }
    }

    function buyItem(moneyAmount, inputAmount, type) {
      outputval = [];
      if (moneyAmount < 10 && type == "sugar" || moneyAmount < 15 && type == "flour") {
        outputval.push(moneyAmount, inputAmount);
      } else if (type == "sugar") {
        moneyAmount = moneyAmount - 10;
        inputAmount = inputAmount + 1;
        outputval.push(moneyAmount);
        outputval.push(inputAmount);
      } else if (type == "flour") {
        moneyAmount = moneyAmount - 15;
        inputAmount = inputAmount + 1;
        outputval.push(moneyAmount)
        outputval.push(inputAmount);
      }
      return outputval;
    }

  });