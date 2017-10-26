// SearchClassSchedule - onClick

// Show/Hide the Class Schedule search section

if ($BlockClassSearch.$visible == false) {
  $BlockClassSearch.$visible = true;
  $SearchTermSelect.$load({clearCache:true});
  $SearchSubjectSelect.$load({clearCache:true});
  $SearchDegReqSelect.$load({clearCache:true});
  $SearchCampusSelect.$load({clearCache:true});
  alert("Class Schedule form displayed below.", {flash: true});
}
else {
  $BlockClassSearch.$visible = false;
  $BlockCourseAdd.$visible = false;
  document.getElementById('pbid-ClassSearch').reset();
  $BlockCourseAdd.$visible = false;
}