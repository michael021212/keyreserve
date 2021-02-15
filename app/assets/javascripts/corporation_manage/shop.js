$(document).ready(function() {
  displayFormForDisclosureRange();
})

function displayFormForDisclosureRange() {
  val = document.getElementById('shop_disclosure_range').value;
  optionForm = document.getElementById('disclosure_range');
  optionForm.style.display = 'none';
  switch (val) {
    case "for_chose_plan_users":
      document.getElementById("disclosure_range").style.display = "block";
      break;
  }
};
