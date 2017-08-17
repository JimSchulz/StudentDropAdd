// Track - onUpdate

var table = document.getElementById("pbid-DropGrid");
var trk;
var i;
var j;
drop = 0;

// Loop through all DropGrid rows
for (i=0; i<table.rows.length-1; i++) {

  trk = document.getElementById("pbid-Track-" + i);

  if (trk.options[trk.selectedIndex].text == "Drop") {
    alert("You have chosen to drop a course.  You need to also add a course in the same block.  Please choose a new course.");
    for (j=0; j<table.rows.length-1; j++) {
      trk = document.getElementById("pbid-Track-" + j);
      trk.disabled = true;  // Disable all Track selects
    }

    document.getElementById("pbid-DropTerm").value = $DropGrid.$data[i].ACADPERIOD;  // Used in SearchClassSchedule-onClick
    drop = 1;
    break;
  }
}

$DropCourseButtonsForm.$visible = true;  // Show the Buttons form

if (drop == 0) {
  // Show the DropGrid buttons (This is only a Grading Track change)
  document.getElementById('pbid-DropApplyChanges').style.display = 'block';
  document.getElementById('pbid-DropReset').style.display = 'block';
}
else {
  // Show the DropGrid buttons (This is a course drop)
  document.getElementById('pbid-DropApplyChanges').style.display = 'none';
  document.getElementById('pbid-DropReset').style.display = 'block';
}