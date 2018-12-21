var tuna = require('./controller.js');

module.exports = function(app){

  app.get('/request_loc/:loc', function(req, res){
	console.log("inside router request");
    tuna.request_loc(req, res);
  });

  app.get('/get_loc/:id', function(req, res){
	console.log("inside router get");
    tuna.get_loc(req, res);
  });

  app.get('/accept_loc/:id', function(req, res){
console.log("inside router accept");
    tuna.accept_loc(req, res);
  });
  
  app.get('/issue_loc/:data', function(req, res){
console.log("inside router issue");
    tuna.issue_loc(req, res);
  });
}
