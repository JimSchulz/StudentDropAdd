// UserID - onLoad

// Browser Page Closing, Clean Up
window.onbeforeunload = function (e) {
  // Delete the Processing PIDM's SZRDRAD records
  $deleteSZRDRAD.$post({
    stu_pidm: document.getElementById('pbid-PassPIDM').value
  },
  null,
  function(response) {
    // Success!   
  },
  function(response) {
    var errorMessage = response.data.errors?response.data.errors.errorMessage:null;
    if (response.data.errors.errorMessage) {
      errorMsg = response.data.errors.errorMessage;
    }
    else if (response.data.errors[0].errorMessage) {
      errorMsg = response.data.errors[0].errorMessage;
    } 
    else {
      errorMsg = errorMessage?errorMessage:response.data;
    }
    if (errorMsg) {
      alert("UserID - Delete SZRDRAD Error: " + errorMsg,{type:"error"});  // Display Error
      return;
    }
  });
  return;
};

// Initially, hide the DropAddInstructions and show the BlockDropAddInstructions
document.getElementById("pbid-DropAddInstructions").style.display = "none";
$BlockDropAddInstructions.$visible = true;

// Initially, hide the AddConsentEntry object
document.getElementById("pbid-AddConsentEntry-container").style.display = "none";

// Initially, hide the AddVerifyForm
$AddVerifyForm.$visible = false;

var userType = '';
var auth = '';

// Internet Explorer 6-11
var isIE = /*@cc_on!@*/false || !!document.documentMode;

// IE Browser Test
if (isIE) {
  alert("This applicaiton does not support Internet Explorer.  Please choose a different browser.",{flash:true});
  return;
}

// Determine what kind of user is signing on (Web Tailor)
for (i=0; i<$$user.authorities.length; i++) {
  auth = $$user.authorities[i].objectName;
  //alert(auth,{flash:true});  // Helpful Debug - Shows user's WebTailor Roles
  if (auth.indexOf('WTAILORADMIN') > -1) {  // was GPBADMN
    userType = "Dev";
  }
  if (auth.indexOf('REGISTRAR') > -1) {
    userType = "Reg";
    break;  // Give Registrars higher prority
  }
  if (auth.indexOf('STUDENT') > -1) {
    userType = "Stu";
  }
}

if (userType == 'Reg' || userType == 'Dev') {

  // Show the student lookup block
  $BlockStuLookup.$visible = true;
  $BlockNull02.$visible = true;
  document.getElementById("pbid-UserSource").value = 'R';  // Registrars or Dev User
}
else if (userType == 'Stu') {

  // Hide the student lookup block
  $BlockStuLookup.$visible = false;
  $BlockNull02.$visible = false;

  // Prep data
  document.getElementById("pbid-UserSource").value = 'S';  // Student User
  var userSource = 'S';
  document.getElementById('pbid-UserButton').click();

  $UserPIDM.$load();

  waitForUserPidm();
}
else {
  document.getElementById("pbid-UserSource").value = null;  // Not Allowed

  // Hide the student lookup block
  $BlockStuLookup.$visible = false;
  $BlockNull02.$visible = false;

  alert("You're not authorized to use the Drop/Add application.",{type:"error"});
}


function waitForUserPidm() {

  // The waitForUserPidm function calls the isUserPidmLoaded function
  // We do this to make JavaScript wait for the completion of the DB call ($load)

  var promise = isUserPidmLoaded();
  promise.then(function(result) {

    // Promise fulfilled.  UserPIDM has completed its load.

    var passPIDM = document.getElementById('pbid-UserPIDM').value;

    // Procedure call - Student Check - This loads the SZRDRAD table
    $studentCheck.$post({  // ---------- studentCheck Post
      stu_pidm: passPIDM,
      user_source: userSource
    },
    null,
    function(response) {  // ---------- studentCheck Success
      // Success!

      // Procedure call - Drop Check - This checks course drops
      $dropCheck.$post({  // ---------- dropCheck Post
        stu_pidm: passPIDM,
        user_source: userSource,
        drops_in: null,
        changes_in: null,
        passcode_in: null
      },
      null,
      function(response) {  // ---------- dropCheck Success
        
        // Success!

        // Show the BlockCourseAddEntry and BlockCourseDrop objects
        $BlockCourseAddEntry.$visible = true;
        $BlockNull03.$visible = true;
        $BlockCourseDrop.$visible = true;
        document.getElementById("pbid-CourseDropLabel").innerHTML = "Loading...";

        // Load Student Information
        $AddTermEntry.$load();
        $AddTrackEntry.$load();
        $StuNameID.$load();
        $AddEntryStuName.$load();
        $AddEntryStuClass.$load();
        $AddMessage.$load({clearCache:true});
        $DropMessage.$load({clearCache:true});
        $AddButtonText.$load({clearCache:true});
        $Processing.$load({clearCache:true});
        $DropGrid.$load({clearCache:true});
      },
      function(response) {  // ---------- dropCheck Error
        var errorMessage = response.data.errors?response.data.errors.errorMessage:null;
        if (response.data.errors.errorMessage) {
          errorMsg = response.data.errors.errorMessage;
        }
        else if (response.data.errors[0].errorMessage) {
          errorMsg = response.data.errors[0].errorMessage;
        }
        else {
          errorMsg = errorMessage?errorMessage:response.data;
        }
        if (errorMsg) {
          alert("UserID dropCheck Error: " + errorMsg,{type:"error"});  // Error
          return;
        }
      });  // ---------- dropCheck Close
    },
    function(response) {  // ---------- studentCheck Error
      var errorMessage = response.data.errors?response.data.errors.errorMessage:null;
      if (response.data.errors.errorMessage) {
        errorMsg = response.data.errors.errorMessage;
      }
      else if (response.data.errors[0].errorMessage) {
        errorMsg = response.data.errors[0].errorMessage;
      }
      else {
        errorMsg = errorMessage?errorMessage:response.data;
      }
      if (errorMsg) {
        alert("UserID studentCheck Error: " + errorMsg,{type:"error"});  // Error
        return;
      }
    });  // ---------- studentCheck Close

  });
}

function isUserPidmLoaded() {  // See if the UserPIDM is loaded
  var deferred = $.Deferred();
  var nextStep = function() {
    if ($UserPIDM == null) {
      // UserPIDM is not loaded yet, wait a little more.
      setTimeout(nextStep, 100); 
    }
    else {
      // UserPIDM has loaded
      $PassPIDM = document.getElementById('pbid-UserPIDM').value;
      deferred.resolve("UserPIDM Loaded");
    }
  }
  nextStep();
  return deferred.promise();
}
