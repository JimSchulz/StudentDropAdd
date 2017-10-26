// ClassSearchSubmit - onClick

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

// Remember that the $DroppingCourse variable is assigned in Track-onUpdate event.

// Show the AddGrid
$BlockCourseAdd.$visible = true;

document.getElementById("pbid-CourseAddSearchLabel").innerHTML = "Loading...";

$AddGrid.$load({clearCache:true});