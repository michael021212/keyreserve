$(document).ready(function() {
  $("#spot_stay").change(function() {
    checkoutCalendar = document.getElementById("checkout-calendar");
    checkoutText = document.getElementById("checkout-text");
    userHour = document.getElementById("use_hour");
    if(document.getElementById("spot_stay").checked) {
      $('#checkout').show();
      $('#checkout').css('display', 'table');
      $('#term').hide();
      $('#checkin-time').hide();
      $('.wavy').show();
      checkout.disabled = false;
      checkoutCalendar.disabled = false;
      checkoutText.disabled = false;
      userHour.disabled = true;
    }else {
      $('#checkout').hide();
      $('#term').show();
      $('#checkin-time').show();
      $('.wavy').hide();
      checkoutCalendar.disabled = true;
      checkoutText.disabled = true;
      userHour.disabled = false;
    }
  })
});

function changeFacilityType(){
  checked =  document.getElementById("spot_stay").checked;
  facility_type = document.getElementById("facility-type")
  facility_type.classList.toggle('stay-checked');
  if (checked == true) {
    facility_type.options[6].selected = true;
  } else {
    facility_type.options[1].selected = true;
  }
};

function changeStayChecked() {
  obj = document.getElementById("spot_stay")
  facility_type = document.getElementById("facility-type")
  if (facility_type.value == "accommodation") {
    obj.click();
  }
};
