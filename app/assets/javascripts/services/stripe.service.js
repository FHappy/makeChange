angular
  .module('makeChangeApp')
  .service('StripeService', StripeService);

StripeService.$inject = ['$http'];

function StripeService($http) {
  const self = this;

  self.postCharge = postCharge;


  function postCharge(token) {
    return $http.post('/api/charges', token);
  }
}