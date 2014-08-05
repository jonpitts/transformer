(function(){
  var app = angular.module('transformer', []);

  app.controller('MainController',['$scope', '$http', function($scope,$http){
    $http.get("/mods/")
      .then(function(res){ $scope.tags = res.data;
      });
    
  }]);
  
  
})();