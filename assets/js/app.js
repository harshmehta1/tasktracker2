// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

import $ from "jquery";
import "phoenix_html"

let start_time = "";

var timeblock_count = 0;

function update_buttons(){
  $('.time-block-add').each( (_,bb) => {
      // let timeblock = $(bb).data('timeblock');
      if(start_time != ""){
        $(bb).text("Stop Working");
      }
      else {
        $(bb).text("Start Working");
      }
  });
}

function set_button(tid, value){
  $('.time-block-add').each( (_,bb) => {
    if (tid == $(bb).data('task-id')){
      $(bb).data('timeblock', value);
    }
  });
  start_time = "";
  update_buttons();
  location.reload();
}

// function stop_working(taskid, timeblockid){
//   let timeend = new Date();
//
//   let text = JSON.stringify({
//     time_block: {
//       end_time: timeend
//     },
//   });
//
//   $.ajax(time_block_path + "/" + timeblockid, {
//     method: "post",
//     data: text,
//     dataType: "json",
//     contentType: "application/json; charset=UTF-8",
//     success: (resp) => { set_button(tid, ""); },
//   });
// }

function start_working(){
  start_time = new Date();
  update_buttons();
}

function stop_working(tid) {
  let curr_time = new Date();
  console.log(curr_time)
  let text  = JSON.stringify({
    time_block: {
      end_time: curr_time,
      start_time: start_time,
      task_id: tid
    },
  });


  $.ajax(time_block_path, {
    method: "post",
    data: text,
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    success: (resp) => { set_button(tid, resp.data.id); },
    error: function(e){
      console.log(e);
    },
  });
}

function time_block_edit(ev){
  console.log($("#edit-dialog").is("visible"));
  $("#edit-dialog").show();
}

function show_manual_timeblock(){

}

function time_block_add(ev){
    let btn = $(ev.target);
    let tid = btn.data('task-id');
    let current_time = btn.data('current-time');
    let timeblock = btn.data('timeblock');
    if(start_time != ""){
      stop_working(tid)
    }
    else {
      start_working();
    }
    // update_buttons();
}


function save_edited_info(ev){
  let btn = $(ev.target);
  let taskid = btn.data('task-id');
  let timeid = btn.data('time-id');
  let sd = $("#sd"+timeid).val();
  let st = $("#st"+timeid).val();
  let ed = $("#ed"+timeid).val();
  let et = $("#et"+timeid).val();
  if (ed == "" || et == "" || sd == "" || st == ""){
    alert('Please enter all details before saving')
  } else {
    let startdatetime = sd+" "+st+":00";
    let enddatetime = ed+" "+et+":00";

    let text = JSON.stringify({
      time_block: {
        end_time: enddatetime,
        start_time: startdatetime,
        task_id: taskid
      },
    });

    $.ajax(time_block_path + "/" +timeid, {
      method: "patch",
      data: text,
      dataType: "json",
      contentType: "application/json; charset=UTF-8",
      success: (resp) => { alert("Successfully update time block"); location.reload(); },
      error: function(e){
        console.log(e);
      },
    });

  }
}

function push_manual_timeblocks(){
  let taskid = $("#manual-timeblocks").data('task-id');
  for(let i=0; i<timeblock_count; i++){
    let sd = $("#nsd"+i).val();
    let st = $("#nst"+i).val();
    let ed = $("#ned"+i).val();
    let et = $("#net"+i).val();
    if (ed < sd){
      alert("end date cannot be before start date");
      return false;
    }
    if (ed == sd && et < st){
      alert("end time cannot be before start time");
      return false;
    }
    if (ed == "" || et == "" || sd == "" || st == ""){
      alert('TimeBlock '+i+' is incomplete or empty. It will not be pushed on to the Database');
    } else {
      let startdatetime = sd+" "+st+":00";
      let enddatetime = ed+" "+et+":00";

      let text = JSON.stringify({
        time_block: {
          end_time: enddatetime,
          start_time: startdatetime,
          task_id: taskid
        },
      });

      $.ajax(time_block_path, {
        method: "post",
        data: text,
        dataType: "json",
        contentType: "application/json; charset=UTF-8",
        success: (resp) => {},
        error: function(e){
          console.log(e);
        },
      });

    }
  }
}

function add_timeblock(){
  var tb = '<h6>TimeBlock '+timeblock_count+'</h6><div class="form-group">'+
  '<input type="date" id="nsd'+timeblock_count+'" name="edit_startdate">'+
  '<input id="nst'+timeblock_count+'" type="time" name="edit_starttime"><br>'+
  '<input type="date" id="ned'+timeblock_count+'" name="edit_enddate">'+
  '<input id="net'+timeblock_count+'" type="time" name="edit_endtime"><br></div>';
  timeblock_count = timeblock_count + 1;
  $("#manual-timeblocks").append(tb);
}

function init(){
  if(!$('.time-block')) {
    // console.log("NOPE")
    return;
  }


  $(".time-block-add").click(time_block_add)
  $(".time-block-edit").click(time_block_edit)
  $(".manual-input").click(add_timeblock);

  $(".time-block-edit-save").click(save_edited_info);

  $("#ph-form").submit(push_manual_timeblocks);

  $("#del-btn").click(function(){
    location.reload();
  });


  update_buttons();

}

$(init);
