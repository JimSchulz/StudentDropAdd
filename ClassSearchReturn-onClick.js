// ClassSearchReturn - onClick

// Turn off the Class Search blocks and turn on the Add and Drop blocks.

var DropCourseRows = document.getElementById("pbid-DropGrid").rows.length;

$BlockCourseAddEntry.$visible = true;
if (DropCourseRows > 2) { 
  // Even when a student has no courses, the pbid-DropGrid query still returns two header rows.
  $BlockCourseDrop.$visible = true;
}
$BlockClassSearch.$visible = false;
$BlockCourseAdd.$visible = false;