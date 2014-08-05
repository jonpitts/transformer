(function(){
  var app = angular.module('transformer', []);

  app.controller('MainController',['$scope', '$http', function($scope,$http){
    $http.get("/mods/")
      .then(function(res){ 
        var data = res.data; //response data is in json format
        for (var key in data) {
          var str = String(data[key]);
          data[key] = str.replace(/[\[\"\ \]]/,''); //remove special characters from values
        }
        $scope.tags = data; //scope data into tags
      });
    
  }]);
  
  
})();