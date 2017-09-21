// AddGrid - onLoad

var table = document.getElementById("pbid-AddGrid");
var CRN = '';
var i = 0;

// Set AddGrid Label

var termSelected = $SearchTermSelect.$selected?$SearchTermSelect.$selected.TERM_VALUE:null;

if (termSelected == null) {
  document.getElementById("pbid-CourseAddSearchLabel").innerHTML = "Choose class schedule criteria to view available courses.";
}
else {
  document.getElementById("pbid-CourseAddSearchLabel").innerHTML = "Class Schedule Search Course Results";
}

document.getElementById('pbid-UserButton').click();

// Loop through all AddGrid rows
for (i=0; i<table.rows.length-1; i++) {

  CRN = $AddGrid.$data[i].CRN;
  Block = $AddGrid.$data[i].BLOCK;
  ScheduleType = $AddGrid.$data[i].SCHEDULETYPE;

  if (CRN == '<b>CRN</b>' || CRN == '' || CRN == null) {
    // Turn off the checkbox for non-course rows
    document.getElementById("pbid-AddCourse-" + i).style.display = "none";  // Hide Checkbox
  }
  else {
    // This is a course row

    if (document.getElementById('pbid-DropBlock').value.length > 1) {

      // Multi-Block course being dropped
      
      if (Block == document.getElementById('pbid-DropBlock').value) {
        if (ScheduleType == "2") {
          // Also turn off the checkbox for Adjunct courses
          document.getElementById("pbid-AddCourse-" + i).style.display = "none";  // Hide Checkbox
        }
      }
      else {
        // Turn off the checkbox for single block rows
        document.getElementById("pbid-AddCourse-" + i).style.display = "none";  // Hide Checkbox
      }
    }
  }

}  // Close For Loop

document.getElementById('pbid-UserButton').click();

alert("Search Results displayed below.",{flash:true});