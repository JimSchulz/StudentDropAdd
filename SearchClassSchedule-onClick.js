// SearchClassSchedule - onClick

// Show/Hide the Class Schedule search section

var i;
var paws;

if ($BlockClassSearch.$visible == false) {
  $BlockNull04.$visible = true;
  $BlockClassSearch.$visible = true;
  $BlockNull05.$visible = true;
  $BlockCourseAdd.$visible = true;
  $SearchTermSelect.$load({clearCache:true});
  $SearchSubjectSelect.$load({clearCache:true});
  $SearchBlockSelect.$load({clearCache:true});
  $SearchInstructorSelect.$load({clearCache:true});
  $SearchDegReqSelect.$load({clearCache:true});
  $SearchCampusSelect.$load({clearCache:true});
  alert("Class Schedule form displayed below.", {flash: true});
  waitForIt();
}
else {
  $BlockClassSearch.$visible = false;
  $BlockNull05.$visible = false;
  $BlockCourseAdd.$visible = false;
}

function waitForIt() {
  // We pause a moment to allow DB retrieval time for the database values
  paws = setTimeout(go, 200);
}

function go() {
  if (document.getElementById("pbid-DropTerm").value != '') {
    // A course is being dropped!
    // Select Term option based on the course being dropped value (DropTerm)
    document.getElementById('pbid-SearchTermSelect').value = "string:" + document.getElementById('pbid-DropTerm').value;
  }
}