// ClassSearch - submit

// Edits

if (document.getElementById('pbid-SearchTermSelect').options.selectedIndex == 0)  {
  alert("Please select a term.", {flash: true,type:"error"});
  document.getElementById('pbid-SearchTermSelect').focus();
  return;
}

if (document.getElementById('pbid-SearchBlockSelect').options.selectedIndex == 0 && document.getElementById('pbid-DropBlock').value != '')  {
  alert("Please select a block.", {flash: true,type:"error"});
  document.getElementById('pbid-SearchTermSelect').focus();
  return;
}

// Show the AddGrid
$BlockNull05.$visible = true;
$BlockCourseAdd.$visible = true;

document.getElementById("pbid-CourseAddSearchLabel").innerHTML = "Loading...";

$AddGrid.$load({clearCache:true});