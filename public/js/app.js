(function(){
  var app = angular.module('transformer', ['ngSanitize']); //ngSanitize directive needed for inserting html
  
  app.controller('MainController',['$scope', '$http', function($scope,$http){
    //note: xhr header removed from angular for posts
    $http.defaults.headers.common["X-Requested-With"] = 'XMLHttpRequest'; //manually adding xhr request header
    
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
    
    $scope.submit = function(tags) {
      //send data as json
      $http.post("/createHash", angular.toJson(tags)).
        success(function() {
          alert("Hash updated");
        }).
        error(function() {
          alert("Error!");
        });
    };
  }]);
  
})();