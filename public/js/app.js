(function(){
  var app = angular.module('transformer', []);
  
  function Tag(data) {
    this.id = data.id;
    this.tag_name = data.tag_name;
    this.tag_assoc = data.tag_assoc;
  }

  app.controller('MainController',['$scope', '$http', function($scope,$http){
    this.test = 'test text';
    $http.get("/mods/")
      .then(function(res){ $scope.tags = res.data;
      });
    
  }]);
  
  
})();