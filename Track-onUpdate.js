// Track - onUpdate

var table = document.getElementById("pbid-DropGrid");
var correspondingTable = document.getElementById("pbid-DropGrid");
var trk;
var i;
var j;
var k;
var dropPolicy = 0;
var block = 0;
var units = 0;
var regStatus = '';
var correspondingRegBlock = '';
var correspondingRegStatus = '';
var correspondingRegCourseFound = 0;

// Loop through all DropGrid rows
for (i=0; i<table.rows.length-1; i++) {

  block = $DropGrid.$data[i].BLOCK;
  units = $DropGrid.$data[i].UNITS;
  regStatus = $DropGrid.$data[i].REGSTATUS;

  trk = document.getElementById("pbid-Track-" + i);

  if (trk.options[trk.selectedIndex].text == "Drop") {

    // Course is being dropped
    
    if (regStatus == 'WL') {

      // Dropping a waitlisted course

      // Loop through all DropGrid rows and look for a corresponding registered course in the same block.
      correspondingRegCourseFound = 0;
      for (k=0; k<correspondingTable.rows.length-1; k++) {
        correspondingRegBlock = $DropGrid.$data[k].BLOCK;
        correspondingRegStatus = $DropGrid.$data[k].REGSTATUS;
        if (block == correspondingRegBlock && correspondingRegStatus == 'RE') {
          correspondingRegCourseFound = 1;
          break;
        }
      }

      if (correspondingRegCourseFound == 0) {
        alert("You need to add a corresponding registered course in the same block before you can drop this waitlisted course.", {flash:true});
        refreshDropGrid();  // Reset the DropGrid
        return;
      }

      if (confirm("Are you sure you want to drop this waitlisted course? You will be releasing your current waitlisted position for this course..") == true) {  // Prompt user to verify waitlist course drop
        dropCourse();  // Drop the Waitlisted Course
        return;
      }
      else {
        refreshDropGrid();  // Confirm's Cancel button clicked.  Reset the DropGrid.
        return;
      }
      break;
    }
    else if ((block == "1-2" || block == "2-3" || block == "3-4" || block == "5-6" || block == "6-7" || block == "7-8") && (units == " 2.00")) {
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

  // Grade Track change

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

function dropCourse() {

  // Procedure call - Drop Check - This checks course drops
  $dropCheck.$post({
    stu_pidm: $PassPIDM,
    user_source: document.getElementById('pbid-UserSource').value,
    drops_in: $DropGrid.$data[i].ACADPERIOD + $DropGrid.$data[i].CRN + ",",
    changes_in: ",",
    passcode_in: ","
  },
  null,
  function(response) {
    // Success!

    document.getElementById("pbid-CourseDropLabel").innerHTML = "Loading...";
    document.getElementById('pbid-UserButton').click();

    // Show the Add and Drop sections and hide the ProcessingData section
    $BlockCourseAddEntry.$visible = true;
    $BlockCourseDrop.$visible = true;
    $ProcessingData.$visible = false;

    // Show the BlockCourseAddEntry and BlockCourseDrop objects
    $BlockCourseAddEntry.$visible = true;
    $BlockCourseDrop.$visible = true;

    // Load Student Information
    $DropGrid.$load({clearCache:true});
    $DropMessage.$load({clearCache:true});
    $AddButtonText.$load({clearCache:true});
    $Processing.$load({clearCache:true});

    // Refresh the Drop Add Data
    document.getElementById('pbid-RefreshDropAddData').click();
    document.getElementById('pbid-RefreshDropAddData').click();

    // Hide the DropGrid buttons
    document.getElementById('pbid-DropApplyChanges').style.display = 'none';
    document.getElementById('pbid-DropReset').style.display = 'none';
  },
  function(response) {
    var errorMessage = response.data.errors?response.data.errors.errorMessage:null;
    if (response.data.errors.errorMessage) {
      errorMsg = response.data.errors.errorMessage;
    }
    else if (response.data.errors[0].errorMessage) {
      errorMsg = response.data.errors[0].errorMessage;
    }
    else {
      errorMsg = errorMessage?errorMessage:response.data;
    }
    if (errorMsg) {

      // Show the Add and Drop sections and hide the ProcessingData section
      $BlockCourseAddEntry.$visible = true;
      $BlockCourseDrop.$visible = true;
      $ProcessingData.$visible = false;

      alert("Track - onUpdate - Drop Waitlisted Course Error: " + errorMsg,{type:"error"});  // Display Error
      return;
    }
  });
}

function refreshDropGrid() {

  // Reset the DropGrid

  // Loop through all DropGrid rows
  for (i=0; i<table.rows.length-1; i++) {
    $DropGrid.$data[i].CONSENTCODE = '';
    $DropGrid.$data[i].DROPCHECKBOX = '0';
  }

  document.getElementById("pbid-CourseDropForm").reset();

  // Procedure call - Student Check - This loads the SZRDRAD table
  $studentCheck.$post({
    stu_pidm: document.getElementById('pbid-PassPIDM').value,
    user_source: document.getElementById('pbid-UserSource').value
  },
  null,
  function(response) {
    // Success!

    // Procedure call - Drop Check - This checks course drops
    $dropCheck.$post({
      stu_pidm: document.getElementById('pbid-PassPIDM').value,
      user_source: document.getElementById('pbid-UserSource').value,
      drops_in: null,
      changes_in: null,
      passcode_in: null
    },
    null,
    function(response) {
      // Success!

      document.getElementById("pbid-CourseDropLabel").innerHTML = "Loading...";
      document.getElementById('pbid-UserButton').click();

      // Show the BlockCourseAddEntry and BlockCourseDrop objects
      $BlockCourseAddEntry.$visible = true;
      $BlockCourseDrop.$visible = true;

      // Load Student Information
      $StuNameID.$load();
      $AddTermEntry.$load();
      $AddTrackEntry.$load();
      $DropGrid.$load({clearCache:true});
      $AddEntryStuName.$load();
      $AddEntryStuClass.$load();
      $AddMessage.$load({clearCache:true});
      $DropMessage.$load({clearCache:true});
      $AddButtonText.$load({clearCache:true});
      $Processing.$load({clearCache:true});

      // Hide the DropGrid buttons
      document.getElementById('pbid-DropApplyChanges').style.display = 'none';
      document.getElementById('pbid-DropReset').style.display = 'none';
    },
    function(response) {
      var errorMessage = response.data.errors?response.data.errors.errorMessage:null;
      if (response.data.errors.errorMessage) {
        errorMsg = response.data.errors.errorMessage;
      }
      else if (response.data.errors[0].errorMessage) {
        errorMsg = response.data.errors[0].errorMessage;
      }
      else {
        errorMsg = errorMessage?errorMessage:response.data;
      }
      if (errorMsg) {
        alert("Track - onUpdate - dropCheck Error: " + errorMsg,{type:"error"});  // Display Error
        return;
      }
    });

  },
  function(response) {
    var errorMessage = response.data.errors?response.data.errors.errorMessage:null;
    if (response.data.errors.errorMessage) {
      errorMsg = response.data.errors.errorMessage;
    }
    else if (response.data.errors[0].errorMessage) {
      errorMsg = response.data.errors[0].errorMessage;
    } 
    else {
      errorMsg = errorMessage?errorMessage:response.data;
    }
    if (errorMsg) {
      alert("DropApplyChanges - onClick - studentCheck Error: " + errorMsg,{type:"error"});  // Display Error
      return;
    }
  });
}
