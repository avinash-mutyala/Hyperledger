'use strict';

var app = angular.module('application', []);
// Angular Controller

app.controller('appController', function ($scope, appFactory) {

	var locSample = {
		id: "loc",
		amt: 10,
		prodesc: "Color Black, Brand MRF, Model CLX1 TL",
		weight: 100,
		vol: 1000,
		buyer: "Honda Pvt Ltd",
		buyeradd: "Hyderabad",
		buyerbank: "Axis",
		seller: "MRF Pvt Ltd",
		selleradd: "Chennai",
		sellerbank: "Axis",
		shipfrom: "Chennai",
		shipto: "Hyderabad",
		qnty: 1000,
		presentdays: 19
	}

	$scope.modes = { "Login": "l", "Buyer": "by", "Seller": "s", "Bank": "bk" }


	function init() {
		$scope.logout();
	}

	function setupsampleloc() {
		$scope.loc = {};
		$scope.loc = locSample;
	}

	$scope.login = function () {
		if ($scope.loginId == "bank" && $scope.password == "admin") {
			$scope.loc_id = "";
			$scope.loc_result = {};
			$scope.see = $scope.modes.Bank;
		} else if ($scope.loginId == "buyer" && $scope.password == "admin") {
			setupsampleloc();
			$scope.see = $scope.modes.Buyer;
		} else if ($scope.loginId == "seller" && $scope.password == "admin") {
			$scope.sloc_id = "";
			$scope.sloc_result = {};
			$scope.see = $scope.modes.Seller;
		} else {
			$scope.see = $scope.modes.Login;
		}
	}

	$scope.logout = function () {
		$scope.loginId = "";
		$scope.password = "";
		$scope.see = $scope.modes.Login;
	}

	$scope.requestLC = function () {
		appFactory.requestLOC($scope.loc, function (result) {
			alert("request created for loc with Transaction id: "+ result);
			if (result == "Failed to request loc") {
				alert(result);
			}
		});
	}

	$scope.issueLC = function () {
		$scope.issue = {};
		$scope.issue.id = $scope.loc_result.lcId;
		$scope.issue.expDate = $scope.loc_result.expiryDate;
		$scope.issue.issDate = $scope.loc_result.issueDate;
		appFactory.issueLOC($scope.issue, function (result) {
			alert("Loc is issued with Transaction id: "+ result);
			if (result == "Failed to issue loc") {
				alert(result);
			}

		});
	}

	$scope.queryLC = function () {
		var id = $scope.loc_id;

		appFactory.getLOC(id, function (result) {
			//alert(JSON.stringify(result));
			if (result == "Could not locate loc") {
				alert(result);
			} else {
				$scope.loc_result = result;
			}
		});
	}

	$scope.querysLC = function () {
		var id = $scope.sloc_id;

		appFactory.getLOC(id, function (result) {
			//alert(JSON.stringify(result));
			if (result == "Could not locate loc") {
				alert(result);
			} else {
				$scope.sloc_result = result;
			}
		});
	}

	$scope.acceptLC = function () {
		var id = $scope.sloc_id;

		appFactory.acceptLOC(id, function (result) {
			alert("Loc is accepted with Transaction id: "+ result);
			if (result == "Could not accept loc") {
				alert(result);
			}
		});
	}

	init();
});

// Angular Factory
app.factory('appFactory', function ($http) {

	var factory = {};

	factory.requestLOC = function (data, callback) {
		var locObj = data.id + "-" + data.amt + "-" + data.prodesc + "-" + data.weight + "-" + data.vol + "- - -" + data.buyer + "-" + data.buyeradd + "-" + data.buyerbank + "-" + data.seller + "-" + data.selleradd + "-" + data.sellerbank + "-" + data.shipfrom + "-" + data.shipto + "-" + data.qnty + "-" + data.presentdays;
		console.log(locObj);
		$http.get('/request_loc/' + locObj).success(function (output) {
			callback(output)
		});
	}

	factory.issueLOC = function (data, callback) {

		var dataObj = data.id + "-" + data.expDate + "-" + data.issDate;
		console.log(dataObj);
		$http.get('/issue_loc/' + dataObj).success(function (output) {
			callback(output)
		});
	}

	factory.getLOC = function (id, callback) {
		$http.get('/get_loc/' + id).success(function (output) {
			callback(output)
		});
	}

	factory.acceptLOC = function (id, callback) {
		$http.get('/accept_loc/' + id).success(function (output) {
			callback(output)
		});
	}

	return factory;
});


