import consumer from "./consumer"

consumer.subscriptions.create("AppearanceChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log('online from the appearance consumer');
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
    console.log('offline from the appearance consumer');
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel

    //=================== IF THE USER IS ONLINE ============================//////////////
    if (data['state'] === "online") {
      console.log(data['user_id']);
      var green_dot = document.getElementById("appearance" + data['user_id']);
      var user_state = document.getElementById("user-state" + data['user_id']);
      var call_icon = document.getElementById("call-icon" + data['user_id']);
      if (green_dot != null && user_state != null && call_icon != null) { // This values are null for the current_user
        green_dot.classList.remove("offline");
        green_dot.classList.add("online");
        user_state.innerHTML = "online";
        call_icon.classList.remove("offline");
        call_icon.classList.add("online");
      }
      console.log(green_dot);


    //===================== IF THE USER IS OFFLINE =========================///////////////
    } else if (data['state'] === "offline") { // e.g: the user logged out
      console.log(data['user_id']);
      var green_dot = document.getElementById("appearance" + data['user_id']);
      var user_state = document.getElementById("user-state" + data['user_id']);
      var call_icon = document.getElementById("call-icon" + data['user_id']);
      if (green_dot != null && user_state != null && call_icon != null) {
        green_dot.classList.remove("online");
        green_dot.classList.add("offline");
        user_state.innerHTML = "offline";
        call_icon.classList.remove("online");
        call_icon.classList.add("offline");
      }
      console.log(green_dot);
    }

  }



});
