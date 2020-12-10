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
  if (checked) {
    facility_type.value = "accommodation";
  } else {
    facility_type.value = "conference_room";
  }
};

function changeStayChecked() {
  obj = document.getElementById("spot_stay")
  facility_type = document.getElementById("facility-type")
  if (facility_type.value == "accommodation") {
    obj.click();
  }
};
