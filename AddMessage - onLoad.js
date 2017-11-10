// AddMessage - onLoad

// Show or Hide the Add Message

if ($AddMessage.ADD_MESSAGE == '' || $AddMessage.ADD_MESSAGE == null) {
  $AddEntryMessageForm.$visible = false;
}
else {
  $AddEntryMessageForm.$visible = true;
}