// SearchInstructorSelect - onLoad

document.getElementById('pbid-UserButton').click();

document.getElementById('pbid-SearchInstructorSelect').options[0].text = '';

document.getElementById('pbid-SearchInstructorSelect').selectedIndex = '0';

if (document.getElementById('pbid-SearchInstructorSelect').length > 1) {
 document.getElementById('pbid-SearchInstructorSelect').remove(document.getElementById('pbid-SearchInstructorSelect').length-1);
}
