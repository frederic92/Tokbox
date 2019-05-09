import consumer from "./consumer"

 const cable = consumer.subscriptions.create("RoomChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log('online');
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
    console.log('offline');
  },

  received(data) {

    console.log(data);


//============== IF THE USER IS RECEIVING THE CALL ==============================================
    if (data['step'] === 'receiving the call'){
      var sender_first_name = data['sender_first_name'];
      var session_id = data['session_id'];
      var session_id_modal = document.getElementById('session_id');
      session_id_modal.innerHTML = session_id;
      var sender_name_modal = document.getElementById('sender_name');
      sender_name_modal.innerHTML = sender_first_name;
      // Display the receiver notification modal
      $('#receiver-notif-modal').modal('show');

    }

// ============ BROADCASTING THE SESSION TO THE RECIPIENT.=====================================================
    if (data['step'] === 'Broadcasting session to the recipient') {
      console.log('Broadcasting the session to the recipient');
      // Initialize the session
      var session = OT.initSession(data['apikey'], data['session_id']);
      console.log(session);

      // Initialize the publisher for the recipient
      var publisherProperties = {insertMode: "append", width: '100%', height: '100%'};
      var publisher = OT.initPublisher('publisher', publisherProperties, function (error) {
        if (error) {
          console.log(error);
        } else {
          console.log("Receiver publisher initialized.");
        }
      });
      $('#session-modal').modal("show");

      // Detect when new streams are created and subscribe to them.
      session.on("streamCreated", function (event) {
        console.log("New stream in the session");
        console.log("New stream in the session: " + event.stream);
        var subscriberProperties = {insertMode: 'append', width: '100%', height: '100%'};
        session.subscribe(event.stream, 'subscriber', subscriberProperties, function(error) {
          if (error) {
            console.log(error);
          } else {
            console.log('Receiver subscriber added.');
          }
        });
      });

      // Connect to the session
      // If the connection is successful, publish an audio-video stream.
      session.connect(data['token'], function(error) {
        if (error) {
          console.log("Error connecting: MBEA", error.name, error.message);
        } else {
          console.log("Connected to the session.");
          session.publish(publisher, function(error) {
            if (error) {
              console.log(error);
            } else {
              console.log("The receiver is publishing a stream");
            }
          });
        }
      });

    }

// ============ BROADCASTING THE SESSION TO THE SENDER.=====================================================
    if (data['step'] === 'Broadcasting session to the sender') {
      console.log('Broadcasting the session to the sender');
      // Initialize the session
      var session = OT.initSession(data['apikey'], data['session_id']);
      console.log(session);
      $('#sender-notif-modal').modal("hide");
      // Initialize the publisher for the sender
      var publisherProperties = {insertMode: "append", width: '100%', height: '100%'};
      var publisher = OT.initPublisher('publisher', publisherProperties, function (error) {
        if (error) {
          console.log(error);
        } else {
          console.log("Sender publisher initialized.");
        }
      });
      $('#session-modal').modal("show");
      // Detect when new streams are created and subscribe to them.
      session.on("streamCreated", function (event) {
        console.log("New stream in the session");
        console.log("New stream in the session: " + event.stream);
        var subscriberProperties = {insertMode: 'append', width: '100%', height: '100%'};
        session.subscribe(event.stream, 'subscriber', subscriberProperties, function(error) {
          if (error) {
            console.log(error);
          } else {
            console.log('Sender subscriber added.');
          }
        });
      });
      // Connect to the session
      // If the connection is successful, publish an audio-video stream.
      session.connect(data['token'], function(error) {
        if (error) {
          console.log("Error connecting: MBEA", error.name, error.message);
        } else {
          console.log("Connected to the session.");
          session.publish(publisher, function(error) {
            if (error) {
              console.log(error);
            } else {
              console.log("The sender is publishing a stream");
            }
          });
        }
      });


    }

  },



  call(recipient_id, recipient_name) {
    console.log(`Hello from the call method: ${recipient_id}. You are calling ${recipient_name}`);
    return this.perform('call', {
            recipient_id: recipient_id,
            recipient_name: recipient_name
    });
  },

  answer(session_id) {
    console.log(`Hello from the answer method: ${session_id}`);
    return this.perform('answer', {
            session_id: session_id
    });

  }
});

export default cable;
