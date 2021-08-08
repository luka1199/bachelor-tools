let myPromise = new Promise(function(resolve, reject) {
    resolve(); // success
    reject();  // error
  });
  
  myPromise.then(
    function(value) { console.log("ok") },
    function(error) { console.log(error) }
);