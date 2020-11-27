$(document).ready(function() {
  displayFormForStay();
})

function displayFormForStay() {
  val = document.getElementById('facility_facility_type').value;
  if(val == "accommodation") {
    document.getElementById("for_stay").style.display = "block";
  }else {
    document.getElementById("for_stay").style.display = "none";
  }
};
