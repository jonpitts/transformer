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
      
    $http.get("/errors/")
      .then(function(res){
        $scope.errors = res.data;
      });
      
    $http.get("/packages/")
      .then(function(res){
        $scope.packages = res.data;
      });
      
    $scope.remove = function(sub,index) {
      $http.post('/delete/'+ sub + '/' + index).
        success(function(res) {
          //x is not used but needed for proper behavior
          var x = $scope.errors[sub].splice(index,1); 
          if ($scope.errors[sub].length == 0) {
            delete $scope.errors[sub];
          }          
        }).
        error(function(res){
          alert(res);
        });
    };
    
    $scope.submit = function(tags) {
      //send data as json
      $http.post("/createHash", angular.toJson(tags)).
        success(function(res) {
          alert(res);
        }).
        error(function() {
          alert("Error!");
        });
    };
  }]);
  
})();