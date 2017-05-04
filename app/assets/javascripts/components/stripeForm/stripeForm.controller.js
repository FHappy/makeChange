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
        var token = {
          token: response[0].id
        }
        return $http.post('/api/charges', token);
      })
      .then(function (payment) {
        console.log('successful payment submitted!')
      });

  };
}

angular
  .module('makeChangeApp')
  .controller('StripeFormController', StripeFormController);