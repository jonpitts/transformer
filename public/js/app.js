(function(){
  var app = angular.module('transformer', ['ngSanitize']); //ngSanitize directive needed for inserting html
  
  app.controller('MainController',['$scope', '$http', function($scope,$http){
    $scope.params = {};
    $http.get("/mods/")
      .then(function(res){ 
        var data = res.data; //response data is in json format
        for (var key in data) {
          var str = String(data[key]);
          data[key] = str.replace(/[\[\"\ \]]/,''); //remove special characters from values
        }
        $scope.tags = data; //scope data into tags
      });
      
    $http.get("/notes/")
      .then(function(res){ 
        $scope.notes = res.data; //response data is in json format
      });
    
    $scope.submit = function() {
      
      alert($scope);
    };
    
  }]);
  
  
})();