// SearchSubjectSelect - onUpdate

// Indicate SearchInstructorSelect is loading
document.getElementById('pbid-SearchInstructorSelect').options[0].text = 'Loading...';

// Load SearchInstructorSelect select lists
$SearchInstructorSelect.$load({clearCache:true});