StripeFormController.$inject = ['StripeCheckout', '$http', 'SweetAlert', 'UsersService'];

function StripeFormController(StripeCheckout, $http, SweetAlert, UsersService) {
  const vm = this;

  vm.description = '10 tokens';
  vm.amount = 545;
  vm.doCheckout = doCheckout;
  vm.confirm = confirm;

  var handler = StripeCheckout.configure({
    name: 'makeChange',
    token: function(token, args) {
      console.log(token.id);
    }
  });

  function doCheckout(token, args) {
    var options = {
      description: vm.description,
      amount: vm.amount
    };

    handler.open(options)
      .then(function resolve(response) {
        vm.isLoading = true;
        console.log(response);
        var token = {
          token: response[0].id
        };
        vm.confirm(token);
      });
  }

  function confirm(token) {
    SweetAlert.swal({
            title: "Are you sure you want to purchase 10 tokens?", 
            text: "No refunds are available.", 
            type: "warning", 
            showCancelButton: true,
            confirmButtonColor: "#DD6B55",
            confirmButtonText: "Yes",
            closeOnConfirm: false, 
            closeOnCancel: false
      }, function(isConfirm) {
        if (isConfirm) {
          $http.post('/api/charges', token)
            .then(function (response) {
              SweetAlert.swal("Success!", response.data.message, "success");
              vm.user.token_amount += 5;
            })
            .catch(function(response) {
              SweetAlert.swal("Something went wrong...", response.data.message, "error");
            });
        } else {
          SweetAlert.swal("Cancelled!", "Your payment has been cancelled.", "error");
        }
      }
    )};
}

angular
  .module('makeChangeApp')
  .controller('StripeFormController', StripeFormController);