// SearchSubjectSelect - onUpdate

// Edit

if (document.getElementById('pbid-SearchTermSelect').options.selectedIndex == 0)  {
  alert("Please select a term.", {flash: true,type:"error"});
  document.getElementById('pbid-SearchTermSelect').focus();
  document.getElementById('pbid-SearchSubjectSelect').selectedIndex = '0';
  return;
}

// Indicate SearchInstructorSelect is loading
document.getElementById('pbid-SearchInstructorSelect').options[0].text = 'Loading...';

// Load SearchInstructorSelect select list
$SearchInstructorSelect.$load({clearCache:true});
