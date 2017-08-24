// Track - onUpdate

var table = document.getElementById("pbid-DropGrid");
var trk;
var i;
var j;
drop = 0;

// Loop through all DropGrid rows
for (i=0; i<table.rows.length-1; i++) {

  trk = document.getElementById("pbid-Track-" + i);

  if (trk.options[trk.selectedIndex].text == "Drop" && $DropGrid.$data[i].SCHEDULETYPE != '2') {
    // Course is being dropped, and it's not an Adjunct course.
    for (j=0; j<table.rows.length-1; j++) {
      trk = document.getElementById("pbid-Track-" + j);
      trk.disabled = true;  // Disable all Track selects
    }

    if ($DropGrid.$data[i].BLOCK == "1-2" || $DropGrid.$data[i].BLOCK == "2-3" || $DropGrid.$data[i].BLOCK == "3-4" || $DropGrid.$data[i].BLOCK == "5-6" || $DropGrid.$data[i].BLOCK == "6-7" || $DropGrid.$data[i].BLOCK == "7-8") {
      // Dropping a two-block course
      alert("You have chosen to drop a two-block course.  You need to also add a two-block course in the same blocks.  Please choose a new two-block course. If you wish to add two one-block courses, please see the registrars office.");
    }
    else if ($DropGrid.$data[i].BLOCK.length == 1) {
      alert("You have chosen to drop a one-block course.  You need to also add a one-block course in the same block.  Please choose a new course.");
    }
    else {
      alert("This application does not support the dropping of blocks " + $DropGrid.$data[i].BLOCK + ". Please see the Registrars Office.");
      return;
    }

    //$DropGrid.$load({clearCache:true});
    //trk.value = "Drop";

    document.getElementById("pbid-DropTerm").value = $DropGrid.$data[i].ACADPERIOD;  // Used in SearchClassSchedule-onClick
    document.getElementById("pbid-DropBlock").value = $DropGrid.$data[i].BLOCK;      // Used in SearchClassSchedule-onClick
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
  // Hide the DropGrid Apply Changes button (This is a course drop)
  document.getElementById('pbid-DropApplyChanges').style.display = 'none';
  document.getElementById('pbid-DropReset').style.display = 'block';

  // Change the DropGrid background to grey
  document.getElementById('pbid-DropGrid').style.backgroundColor= "#c2c2c3";

  // Reset the ClassSearch form
  document.getElementById('pbid-ClassSearch').reset();

  // Hide BlockClassSearch
  $BlockClassSearch.$visible = false;
}