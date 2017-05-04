StripeFormController.$inject = ['StripeCheckout', '$http', 'FlashMessage'];

function StripeFormController(StripeCheckout, $http, FlashMessage) {
  const vm = this;

  vm.description = 'hello world';
  vm.doCheckout = doCheckout;
  vm.isLoading = false;

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
        var target = document.getElementById('spinner');
        console.log(response);
        // alert("Got stripe token: " + response[0].id);
        var token = {
          token: response[0].id
        };
        $http.post('/api/charges', token)
          .then(function (response) {
            console.log('button submitted!');
            // console.log('successful payment submitted!');
            console.log(response.data.message);
          })
          .catch(function(response) {
            console.log(response.data.message);
            error = response.data.message;
            FlashMessage.setShow('alert');
            FlashMessage.setMessage(error);
          });
      });
      

  };
}

angular
  .module('makeChangeApp')
  .controller('StripeFormController', StripeFormController);