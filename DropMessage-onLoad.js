// DropMessage - onLoad

// Show or Hide the Drop Message
if ($DropMessage.DROP_MESSAGE == '' || $DropMessage.DROP_MESSAGE == null) {
  $CourseDropMessageForm.$visible = false;
}
else {
  $CourseDropMessageForm.$visible = true;
}