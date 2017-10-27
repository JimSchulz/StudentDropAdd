// AddCourse - onUpdate

var DropCourseRows = document.getElementById("pbid-DropGrid").rows.length;
var rows = $AddGrid.$data.length;
var i = 0;
var k = 0;

// Loop through all AddGrid rows
for (i=0; i<rows; i++) {

  if (document.getElementById("pbid-AddCourse-" + i).checked) {

    // User checked an AddGrid's AddCourse checkbox

    // Set Term within the AddEntryForm
    for(k=0; k<document.getElementById('pbid-AddTermEntry').options.length; k++) {
      if (document.getElementById('pbid-AddTermEntry').options[k].innerHTML == $AddGrid.$data[i].TERM) {
        document.getElementById('pbid-AddTermEntry').selectedIndex = k;
        break;
      }
    }

    // Set the CRN within the AddEntryForm
    $AddCRNEntry = $AddGrid.$data[i].CRN;

    // Hide the Class Schedule Search and Class Schedule Search Results blocks
    $BlockClassSearch.$visible = false;
    $BlockCourseAdd.$visible = false;

    // Show the Course Add and Course Drop blocks
    $BlockCourseAddEntry.$visible = true;
    if (DropCourseRows > 2) { 
      // Even when a student has no courses, the pbid-DropGrid query still returns two header rows.
      $BlockCourseDrop.$visible = true;
    }

    // Reset the Class Search Results form
    document.getElementById("pbid-AddCourse-" + i).click();  // Maintain state of checkbox
    document.getElementById("pbid-CourseAddForm").reset();
    document.getElementById('pbid-ClassSearch').reset();

    break;
  }
}