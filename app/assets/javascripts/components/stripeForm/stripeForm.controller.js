StripeFormController.$inject = ['StripeCheckout'];

function StripeFormController(StripeCheckout) {
  const vm = this;

  vm.description = 'hello world';
  vm.doCheckout = doCheckout;

  var handler = StripeCheckout.configure({
    name: 'boop boop',
    token: function(token, args) {
      console.log(token.id);
    }
  })

  function doCheckout(token, args) {
    var options = {
      description: 'Ten dollahs!',
      amount: 1000
    };

    handler.open(options)
      .then(function resolve(response) {
        alert("Got stripe token: " + response[0].id);
      }, function reject(response) {
        alert("Stripe Checkout closed without making a sale: :(");
      });

  };
}

angular
  .module('makeChangeApp')
  .controller('StripeFormController', StripeFormController);