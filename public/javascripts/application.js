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


function switch_external_chairman() {
  Element.toggle('chairman_text')
  Element.toggle('chairman_select')
  $('external_chairman').value = !($('external_chairman').value == 'true')
}


document.observe("dom:loaded", function() {
  if($("both_in_one_day") != null) {
    $("both_in_one_day").observe("click", function() {
      if ($("both_in_one_day").checked) {
        $("file").hide()
      } else {
        $("file").show()
      }
    })
  }
});
