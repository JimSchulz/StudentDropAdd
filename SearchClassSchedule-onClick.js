// SearchClassSchedule - onClick

if ($BlockClassSearch.$visible == false) {

  // Show the Class Schedule search block and hide the Course Add and Course Drop blocks

  $BlockCourseAddEntry.$visible = false;
  $BlockCourseDrop.$visible = false;
  $BlockClassSearch.$visible = true;
  $SearchTermSelect.$load({clearCache:true});
  $SearchSubjectSelect.$load({clearCache:true});
  $SearchDegReqSelect.$load({clearCache:true});
  $SearchCampusSelect.$load({clearCache:true});
}