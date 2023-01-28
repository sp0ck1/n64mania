
    
    document.querySelector("#autoComplete").addEventListener("selection", function (event) {
    // "event.detail" carries the autoComplete.js "feedback" object
    console.log(event.detail);
});

document.querySelector(".btn-game-search").addEventListener("click", function (event) {
    console.log(event);
    // if searched thing in JSON.parse(document.getElementById('search-data').dataset.games, 
         // logic that sends you to that game's page
         // else render html: error etc etc 

});

