(function(){
  var app = angular.module('transformer', ['ngSanitize','ngResource']); //ngSanitize directive needed for inserting html
  app.config(['$resourceProvider',function($resourceProvider) { //ngResource for working with RESTful resources
    $resourceProvider.defaults.stripTrailingSlashes = false;
  }]);
  
  app.controller('MainController',['$resource','$scope', '$filter','$http', function($resource,$scope,$filter,$http){
    //note: xhr header removed from angular for posts
    $http.defaults.headers.common["X-Requested-With"] = 'XMLHttpRequest'; //manually adding xhr request header
    //RESTful resources
    var Mods = $resource('/mods/:id');
    var Notes = $resource('/notes/');
    var Packages = $resource('/packages/');
    var Errors = $resource('/errors/');
    
    //bring resources into scope
    var errors = Errors.get(function(){
        $scope.errors = errors;
    });
    var notes = Notes.get(function() {
        $scope.notes = notes;
    });
    var packages = Packages.query(function() {
        $scope.packages = packages;
    });
    var tags = Mods.get(function() {
        $scope.tags = tags; //scope data into tags
    });

    $scope.removePackage = function(name) {
      $http.post('/remove/'+ name).
        success(function(res) {
          //x is not used but needed for proper behavior
          $scope.packages = $filter('filter')($scope.packages, '!' + name); 
        }).
        error(function(res){
          alert(res);
        });
    };
      
    $scope.deleteError = function(sub,index) {
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
    
    $scope.clearErrors = function(sub) {
      $http.post('/delete/'+ sub + '/').
        success(function(res) {
          //x is not used but needed for proper behavior
          delete $scope.errors[sub]       
        }).
        error(function(res){
          alert(res);
        });
    };
    
    $scope.hash = function(tags) {
      //send data as json
      $http.post("/createHash", angular.toJson(tags)).
        success(function(res) {
          alert(res);
        }).
        error(function() {
          alert("Error!");
        });
    };
    
    $scope.submit = function(e) {
      $scope.btnDisabled = true; //slow down submits
      var formElement = document.getElementById("submitForm");
      var formData = new FormData(formElement);
      formData.append("timestamp",Date.now()); //nonce value - used server side to prevent duplicate submits
      var inst = formElement[2].value; //institution value
      formElement.reset();
      formElement[2] = inst;
      
      //remove error message
      if(document.getElementById("error")) {
        var parent = document.getElementById("submitPanel")
        var child = document.getElementById("error");
        parent.removeChild(child);
      }
      
      //create sent message if it does not exist
      if(!document.getElementById("submitted")) {
        var label = document.createElement("div");
        var t = document.createTextNode("Submitted");
        label.id = "submitted";
        label.className = "alert alert-success";
        label.appendChild(t);
        document.getElementById("submitPanel").appendChild(label);
      }
      
      $http({
        method: 'POST',
        url: "/",
        data: formData,
        cache: true,
        headers: {'Content-Type': undefined},
        transformRequest: function(data) {return data;}
        }).
        success(function(res) {
          var packages = Packages.query(function() {
              $scope.packages = packages;
          });
          var errors = Errors.get(function(){
              $scope.errors = errors;
          });
        }).
        error(function(res) {
          var packages = Packages.query(function() {
              $scope.packages = packages;
          });
          var errors = Errors.get(function(){
              $scope.errors = errors;
          });
          //remove submit message
          if(document.getElementById("submitted")) {
            var parent = document.getElementById("submitPanel")
            var child = document.getElementById("submitted");
            parent.removeChild(child);
          }
          //create error message
          var label = document.createElement("div");
          var t = document.createTextNode(res);
          label.id = "error";
          label.className = "alert alert-warning";
          label.appendChild(t);
          document.getElementById("submitPanel").appendChild(label);
        });
        setTimeout(function(){$scope.btnDisabled = false;$scope.$apply();},1000);
        e.stopPropagation();
        e.preventDefault();
        return false;
    };
    
  }]);
  
})();