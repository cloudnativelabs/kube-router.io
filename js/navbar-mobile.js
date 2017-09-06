// SIMPLE STICKY NAVBAR
// SOURCE: https://stackoverflow.com/a/28452687

$(document).ready(function() {
  $(window).scroll(function() {
    console.log($(window).scrollTop());
    if ($(window).scrollTop() > 475) {
      $('body').addClass('navbar-fixed');
    }
    if ($(window).scrollTop() < 475) {
      $('body').removeClass('navbar-fixed');
    }
  });
});
