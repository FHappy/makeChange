StripeFormController.$inject = ['StripeCheckout', '$http'];

function StripeFormController(StripeCheckout, $http) {
  const vm = this;

  vm.description = 'hello world';
  vm.doCheckout = doCheckout;

  var handler = StripeCheckout.configure({
    name: 'boop boop',
    token: function(token, args) {
      console.log(token.id);
    }
  });

  function doCheckout(token, args) {
    var options = {
      description: 'one hundred dollahs!',
      amount: 10000
    };

    handler.open(options)
      .then(function resolve(response) {
        console.log(response);
        // alert("Got stripe token: " + response[0].id);
        var token = response[0].id;
        $http.post('/api/charges');
      }, function reject(response) {
        alert("Stripe Checkout closed without making a sale: :(");
      });

  };
}

angular
  .module('makeChangeApp')
  .controller('StripeFormController', StripeFormController);