// SearchTermSelect - onLoad

var i = 0;

waitForIt();

function waitForIt() {
  // We pause a moment to allow DB retrieval time for the database values
  paws = setTimeout(go, 200);
}

function go() {
  if (document.getElementById("pbid-DropTerm").value != '') {
    // A course is being dropped!

    // Limit Term Select options based on DropTerm value
    for (i=0; i < document.getElementById('pbid-SearchTermSelect').options.length; i++) {
      if (document.getElementById('pbid-SearchTermSelect').options[i].value != "string:" + document.getElementById('pbid-DropTerm').value && i != 0) {
        document.getElementById('pbid-SearchTermSelect').remove(i);
        i = i - 1;
      }
    }
  }
}