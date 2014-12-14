//https://github.com/samdutton/simpl/blob/master/rtcdatachannel

//shim for firefox
var PeerConnection = window.mozRTCPeerConnection || window.webkitRTCPeerConnection;
window.webkitRTCPeerConnection = PeerConnection;



var sendChannel, receiveChannel;

var startButton = document.getElementById("startButton");
var sendButton = document.getElementById("sendButton");
var closeButton = document.getElementById("closeButton");
startButton.disabled = false;
sendButton.disabled = true;
closeButton.disabled = true;
startButton.onclick = createConnection;
sendButton.onclick = sendData;
closeButton.onclick = closeDataChannels;

document.addEventListener('keypress',function(e){
	if(e.which==13)
		sendData();
});

function trace(text) {
  console.log((performance.now() / 1000).toFixed(3) + ": " + text);
}

function createConnection() {
  var servers = {
    "iceServers": [
        {"url": "stun:stun2.l.google.com:19302"},
        {"url": "stun:stun3.l.google.com:19302"},
        {"url": "stun:stun.voiparound.com"},
		{"url": "stun:stun.voipbuster.com"}
    ]
  };
  var options = {
    optional: [
        {DtlsSrtpKeyAgreement: true},
        {RtpDataChannels: true}
    ]
  };
  window.localPeerConnection = new webkitRTCPeerConnection(servers,
   options);
  trace('Created local peer connection object localPeerConnection');

  try {
    // Reliable Data Channels not yet supported in Chrome
    sendChannel = localPeerConnection.createDataChannel("sendDataChannel",
      {reliable: false});
    trace('Created send data channel');
  } catch (e) {
    alert('Failed to create data channel. ' +
          'You need Chrome M25 or later with RtpDataChannel enabled');
    trace('createDataChannel() failed with exception: ' + e.message);
  }
  localPeerConnection.onicecandidate = gotLocalCandidate;
  sendChannel.onopen = handleSendChannelStateChange;
  sendChannel.onclose = handleSendChannelStateChange;

  window.remotePeerConnection = new webkitRTCPeerConnection(servers,
    {optional: [{RtpDataChannels: true}]});
  trace('Created remote peer connection object remotePeerConnection');

  remotePeerConnection.onicecandidate = gotRemoteIceCandidate;
  remotePeerConnection.ondatachannel = gotReceiveChannel;
	
	
  var errorHandler = function (err) {
    console.error(err);
  };
  var constraints = {
    mandatory: {
      OfferToReceiveAudio: false,
      OfferToReceiveVideo: false
    }
  };
  localPeerConnection.createOffer(gotLocalDescription, errorHandler, constraints);
  
  startButton.disabled = true;
  closeButton.disabled = false;
}

function sendData() {
  var data = document.getElementById("dataChannelSend").value;
  sendChannel.send(data);
  trace('Sent data: ' + data);
}

function closeDataChannels() {
  trace('Closing data channels');
  sendChannel.close();
  trace('Closed data channel with label: ' + sendChannel.label);
  receiveChannel.close();
  trace('Closed data channel with label: ' + receiveChannel.label);
  localPeerConnection.close();
  remotePeerConnection.close();
  localPeerConnection = null;
  remotePeerConnection = null;
  trace('Closed peer connections');
  startButton.disabled = false;
  sendButton.disabled = true;
  closeButton.disabled = true;
  dataChannelSend.value = "";
  dataChannelReceive.value = "";
  dataChannelSend.disabled = true;
  dataChannelSend.placeholder = "Press Start, enter some text, then press Send.";
}

function gotLocalDescription(desc) {
  localPeerConnection.setLocalDescription(desc);
  trace('Offer from localPeerConnection \n' + desc.sdp);
  remotePeerConnection.setRemoteDescription(desc);
  remotePeerConnection.createAnswer(gotRemoteDescription);
}

function gotRemoteDescription(desc) {
  remotePeerConnection.setLocalDescription(desc);
  trace('Answer from remotePeerConnection \n' + desc.sdp);
  localPeerConnection.setRemoteDescription(desc);
}

function gotLocalCandidate(event) {
  trace('local ice callback');
  console.log(event);
  if (event.candidate) {
    remotePeerConnection.addIceCandidate(event.candidate);
    trace('Local ICE candidate: \n' + event.candidate.candidate);
  }
}

function gotRemoteIceCandidate(event) {
  trace('remote ice callback');
  if (event.candidate) {
    localPeerConnection.addIceCandidate(event.candidate);
    trace('Remote ICE candidate: \n ' + event.candidate.candidate);
  }
}

function gotReceiveChannel(event) {
  trace('Receive Channel Callback');
  receiveChannel = event.channel;
  receiveChannel.onmessage = handleMessage;
  receiveChannel.onopen = handleReceiveChannelStateChange;
  receiveChannel.onclose = handleReceiveChannelStateChange;
}

function handleMessage(event) {
  trace('Received message: ' + event.data);
  document.getElementById("dataChannelReceive").value = event.data;
}

function handleSendChannelStateChange() {
  var readyState = sendChannel.readyState;
  trace('Send channel state is: ' + readyState);
  if (readyState == "open") {
    dataChannelSend.disabled = false;
    dataChannelSend.focus();
    dataChannelSend.placeholder = "";
    sendButton.disabled = false;
    closeButton.disabled = false;
  } else {
    dataChannelSend.disabled = true;
    sendButton.disabled = true;
    closeButton.disabled = true;
  }
}

function handleReceiveChannelStateChange() {
  var readyState = receiveChannel.readyState;
  trace('Receive channel state is: ' + readyState);
}







