// needs a prototype by Fuchs
function toggle_detail(id) {
  Element.toggle('info' + id);
  if($('info' + id).style.display == '') {
    new Effect.Highlight('info' + id);
    $('link' + id).style.background = '#ffd';
    $('link' + id).style.color = 'gray';
  } else {
    $('link' + id).style.color = ''; 
    $('link' + id).style.background = 'white';
  }
}
function print_details() {
  open_all_details();
  window.print();
}
