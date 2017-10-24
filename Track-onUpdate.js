// Track - onUpdate

var table = document.getElementById("pbid-DropGrid");
var trk;
var i;
var j;
var dropPolicy = 0;
var block = 0;
var units = 0;

// Loop through all DropGrid rows
for (i=0; i<table.rows.length-1; i++) {

  block = $DropGrid.$data[i].BLOCK;
  units = $DropGrid.$data[i].UNITS;

  trk = document.getElementById("pbid-Track-" + i);

  if (trk.options[trk.selectedIndex].text == "Drop") {

    // Course is being dropped

    if ((block == "1-2" || block == "2-3" || block == "3-4" || block == "5-6" || block == "6-7" || block == "7-8") && (units == " 2.00")) {
      // Dropping a two-block course
      disableTrackSelect();
      alert("You have chosen to drop a two-block course.  You need to also add a two-block course in the same blocks.  Please choose a new two-block course. If you wish to add two one-block courses, please see the registrars office.");
      break;
    }
    else if (block.length == 1 && units == " 1.00") {
      // Dropping a one-block course
      disableTrackSelect();
      alert("You have chosen to drop a one-block course.  You need to also add a one-block course in the same block.  Please choose a new course.");
      break;
    }
  }
}

$DropCourseButtonsForm.$visible = true;  // Show the Buttons form

if (dropPolicy == 0) {

  // Grade Track change only

  // Show the DropGrid buttons (This is only a Grading Track change)
  document.getElementById('pbid-DropApplyChanges').style.display = 'block';
  document.getElementById('pbid-DropReset').style.display = 'block';
}
else {

  // User is dropping a course

  // Hide the DropGrid Apply Changes button (This is a course drop)
  document.getElementById('pbid-DropApplyChanges').style.display = 'none';
  document.getElementById('pbid-DropReset').style.display = 'block';

  // Change the DropGrid background to grey
  document.getElementById('pbid-DropGrid').style.backgroundColor = "#c2c2c3";

  // Reset the ClassSearch form
  document.getElementById('pbid-ClassSearch').reset();

  // Hide BlockClassSearch and BlockAddCourse
  $BlockClassSearch.$visible = false;
  $BlockAddCourse.$visible = false;

  // Save the dropping action.
  // The Virtual Domain StuAddGrid uses the DroppingCourse variable to 
  // determinine when to retrieve courses that are full or not full.
  // This is done to prevent a student from replacing a dropped course
  // with a waitlisted course.
  // $DroppingCourse = 0 means get only courses with available seats.
  // $DroppingCourse = null means get all courses. (Course Add only).

  $DroppingCourse = 0;
}

function disableTrackSelect() {
  for (j=0; j<table.rows.length-1; j++) {
    trk = document.getElementById("pbid-Track-" + j);
    trk.disabled = true;  // Disable All Track select objects
  }
  dropPolicy = 1;
  document.getElementById("pbid-DropTerm").value = $DropGrid.$data[i].ACADPERIOD;  // Used in SearchClassSchedule-onClick
  document.getElementById("pbid-DropBlock").value = $DropGrid.$data[i].BLOCK;      // Used in SearchClassSchedule-onClick
}