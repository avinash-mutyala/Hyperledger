// SPDX-License-Identifier: Apache-2.0

'use strict';

var app = angular.module('application', []);

// Angular Controller
app.controller('appController', function($scope, appFactory){

	$("#success_holder").hide();
	$("#success_create").hide();
	$("#error_holder").hide();
	$("#error_query").hide();
	
	$scope.requestLC = function(){
		
		appFactory.requestLOC($scope.loc, function(data){
			$scope.loc_created = data;
			$("#success_create").show();
		});
	}
	
	$scope.issueLC = function(){
		
		$scope.issue = {};
		$scope.issue.id = $scope.loc_result.lcId;
		$scope.issue.expDate = $scope.loc_result.expiryDate;
		$scope.issue.issDate = $scope.loc_result.issueDate;
		appFactory.issueLOC($scope.issue, function(data){
			//$scope.loc_issued = data;
			$("#success_create").show();
		});
	}

	$scope.queryLC = function(){

		var id = $scope.loc_id;

		appFactory.getLOC(id, function(data){
			$scope.loc_result = data;

			if ($scope.loc_result == "Could not locate loc"){
				console.log()
				$("#error_query").show();
			} else{
				$("#error_query").hide();
			}
		});
	}
	$scope.acceptLC = function(){

		var id = $scope.aloc_id;
		
		appFactory.acceptLOC(id, function(data){
			/*$scope.aloc_result = data;

			if ($scope.loc_result == "Could not locate loc"){
				console.log()
				$("#error_query").show();
			} else{
				$("#error_query").hide();
			}*/
		});
	}

	
});

// Angular Factory
app.factory('appFactory', function($http){
	
	var factory = {};

	factory.requestLOC = function(data, callback){	
		var locObj = data.id + "-" + data.amt  + "-" + data.prodesc  + "-" + data.weight  + "-" + data.vol  + "- - -" + data.buyer  + "-" + data.buyeradd  + "-" + data.buyerbank  + "-" + data.seller  + "-" + data.selleradd  + "-" + data.sellerbank  + "-" + data.shipfrom  + "-" + data.shipto  + "-" + data.qnty  + "-"  + data.presentdays ;
console.log(locObj);
    	$http.get('/request_loc/'+locObj).success(function(output){
			callback(output)
		});
	}

	factory.issueLOC = function(data, callback){		

		var dataObj = data.id + "-" + data.expDate  + "-" + data.issDate;
	console.log(dataObj);
    	$http.get('/issue_loc/'+dataObj).success(function(output){
			callback(output)
		});
	}

	factory.getLOC = function(id, callback){
    	$http.get('/get_loc/'+id).success(function(output){
			callback(output)
		});
	}

	factory.acceptLOC = function(id, callback){
    	$http.get('/accept_loc/'+id).success(function(output){
			callback(output)
		});
	}

   
	return factory;
});


