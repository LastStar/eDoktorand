// needs a prototype by Fuchs
function toggle_detail(block, link, id) {
  Element.toggle(block + id);
  if($(block + id).style.display == '') {
    new Effect.Highlight(block + id);
    $(link + id).style.background = '#ffd';
    $(link + id).style.color = 'gray';
  } else {
    $(link + id).style.color = ''; 
    $(link + id).style.background = 'white';
  }
}
function print_details() {
	open_all_contacts();
  window.print();
}
