// DropGrid - onClick

var table = document.getElementById("pbid-DropGrid");
var trk;

// Loop through all DropGrid rows
for (i=0; i<table.rows.length-1; i++) {

  trk = document.getElementById("pbid-Track-" + i);

  if (trk.disabled) {
    // Track select list is disabled because we're in the middle of a drop/add transaction.
    alert("You have chosen to drop a course.  You need to also add a course in the same block.  Please choose a new course.<br><br>To cancel this transaction, press the Cancel button.");
    break;
  }
}