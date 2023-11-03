// Menu manipulation
// Add toggle listeners to listen for clicks.
document.addEventListener("turbo:load", function () {
  let dropbtn = document.querySelector(".dropdown-toggle");
  dropbtn.addEventListener("click", function (event) {
    event.preventDefault();
    let menu = document.querySelector(".dropdown-menu");
    menu.classList.toggle("active");
  });
});
