addEventListener("resize", (event) => {for (i in document.getElementsByClassName("header-bar")) {
    if (window.innerWidth < 775) {
        document.getElementsByClassName("header-bar")[0].style.display = "none";
        document.getElementsByClassName("header-bar")[1].style.display = "none";
    } else { 
        document.getElementsByClassName("header-bar")[0].style.display = "block";
        document.getElementsByClassName("header-bar")[1].style.display = "block"; }
}});