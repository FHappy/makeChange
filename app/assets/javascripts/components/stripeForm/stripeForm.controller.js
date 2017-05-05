StripeFormController.$inject = ['StripeCheckout', '$http', 'FlashMessage'];

function StripeFormController(StripeCheckout, $http, FlashMessage) {
  const vm = this;

  vm.description = 'hello world';
  vm.doCheckout = doCheckout;
  vm.alertMessage = '';
  vm.noticeMessage = '';
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
        vm.isLoading = true;
        console.log(response);
        // alert("Got stripe token: " + response[0].id);
        var token = {
          token: response[0].id
        };
        $http.post('/api/charges', token)
          .then(function (response) {
            // console.log('successful payment submitted!');
            var alert = response.data.message;
            vm.alertMessage = alert;
          })
          .catch(function(response) {
            console.log(response.data.message);
            var error = response.data.message;
            vm.alertMessage = error;
          });
      });
      

  };
}

angular
  .module('makeChangeApp')
  .controller('StripeFormController', StripeFormController);