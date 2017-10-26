// SearchTermSelect - onUpdate

// Indicate the SearchBlockSelect is loading
document.getElementById('pbid-SearchBlockSelect').options[0].text = 'Loading...';

// Load the SearchBlockSelect select lists
$SearchBlockSelect.$load({clearCache:true});