// SearchBlockSelect - onLoad

var i = 0;
var DropBlock = '';

document.getElementById('pbid-UserButton').click();

document.getElementById('pbid-SearchBlockSelect').options[0].text = '';

waitForIt();

function waitForIt() {
  // We pause a moment to allow DB retrieval time for the database values
  paws = setTimeout(go, 200);
}

function go() {
  DropBlock = document.getElementById("pbid-DropBlock").value.charAt(0);
  
  if (DropBlock != '') {
    // A course is being dropped!

    // Limit Block Select options based on DropBlock value
    for (i=1; i < document.getElementById('pbid-SearchBlockSelect').options.length; i++) {
      if (document.getElementById('pbid-SearchBlockSelect').options[i].value != "string:" + DropBlock) {
        document.getElementById('pbid-SearchBlockSelect').remove(i);
        i = i - 1;
      }
    }
  }
}