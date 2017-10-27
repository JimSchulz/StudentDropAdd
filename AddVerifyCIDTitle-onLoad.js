// AddVerifyCIDTitle - onLoad

// Show or Hide the Add Verify Form

if ($AddVerifyCIDTitle == '' || $AddVerifyCIDTitle == null) {
  $AddVerifyForm.$visible = false;
}
else {
  $AddVerifyForm.$visible = true;

  // Disable the SearchClassSchedule button
  document.getElementById('pbid-SearchClassSchedule').disabled = true;
}