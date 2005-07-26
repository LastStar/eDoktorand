last = []
last[1] = 0
last[2] = 0
last[3] = 0
function hide_on_internal(id) {
  var element = eval("document.forms[0].plan_subject_" + id + "_subject_id");
  if((element.value == 0 && last[id] != 0) || (element.value != 0 && last[id] == 0)) {
    if($('external' + id).style.display == 'none') {
    <%= visual_effect(:slide_down, 'external' + id) %>
    last[id] = element.value;
    }
    else {
    <%= visual_effect(:fade, , 'external' + id) %>
    last[id] = element.value;
    }
  };
}

    
  

