$(document).ready(function() {
  displayFormForStay();
})

function displayFormForStay() {
  val = document.getElementById('facility_facility_type').value;
  optionForm = document.getElementsByClassName("option_form");
  for (i = 0; i < optionForm.length; i++) {
    optionForm[i].style.display = "none";
  }
  switch (val) {
    case "accommodation":
      document.getElementById("for_stay").style.display = "block";
      break;
    case "chartered_place":
      document.getElementById("chartered_area").style.display = "block";
      break;
  }
};
