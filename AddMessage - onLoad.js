// AddMessage - onLoad

// Show or Hide the Add Message

if ($AddMessage.ADD_MESSAGE == '' || $AddMessage.ADD_MESSAGE == null) {
  $AddEntryMessageForm.$visible = false;
}
else {
  $AddEntryMessageForm.$visible = true;

  if ($AddMessage.ADD_MESSAGE == 'ADD FAILED: Registration status code WL is not type R.') {
     $AddMessage.ADD_MESSAGE = "ADD FAILED: Please select a course with open seats. To be added to a course's wait list, please see the Registrar's Office.";
  }
}