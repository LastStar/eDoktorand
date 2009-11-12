// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//
function open_all_contacts() {
  $$('.contact').each(function(value) {value.show();});
}
function close_all_contacts() {
  $$('.contact').each(function(value) {value.hide();});
}
function open_all_histories() {
  $$('.history').each(function(value) {value.show();});
}
function close_all_histories() {
  $$('.history').each(function(value) {value.hide();});
}

