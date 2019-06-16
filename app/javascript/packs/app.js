import consumer from "../channels/consumer"
import cable from "../channels/room_channel"

console.log(cable);
console.log("Hi there from app.js");



//================ CUSTOM JAVASCRIPT ===========================================

document.addEventListener('DOMContentLoaded', (event) => {
    console.log(consumer);
    console.log("Hi from the room channel");


    // Add an event listener to call buttons
    var call_icons = document.getElementsByClassName('call-icon');
    for (let item of call_icons) {
      item.addEventListener('click', (event) => {
        event.preventDefault();
        var recipient_id = item.getAttribute("data-id");
        var recipient_name = item.getAttribute("data-name");
        console.log(recipient_id);
        console.log(recipient_name);
        var recipient_name_modal = document.getElementById('recipient_name_modal');
        recipient_name_modal.innerHTML = recipient_name;
        $('#sender-notif-modal').modal('show');

        cable.call(recipient_id, recipient_name);
      })
    }

    // Call the answer method when the answer_btn is clicked.
    const answer_btn = document.getElementById("answer-call");
    answer_btn.addEventListener('click', (event) => {
      event.preventDefault();
      var session_id = document.getElementById("session_id").innerHTML;
      var sender_id = document.getElementById('sender_id').innerHTML;
      console.log(session_id);
      console.log("answer btn clicked");
      $('#receiver-notif-modal').modal('hide');
      cable.answer(session_id, sender_id);
    });

    // Initialize tooltips
    $(function () {
      $('[data-toggle="tooltip"]').tooltip()
    });

});
