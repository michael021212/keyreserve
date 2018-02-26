$ ->
  #-----------------------------------------------
  # Map
  #-----------------------------------------------
  $('.google-map').each () ->
    geocoder = new (google.maps.Geocoder)
    lat = $(this).data('lat')
    lon = $(this).data('lon')

    mapOptions = {
      zoom:         16
      scrollwheel:  false
      draggable:    true
    }

    map = new google.maps.Map($(this).get(0), mapOptions)
    mapStyle = {
      name: 'centrl_map'
      styles: [
        {
          "stylers": [
            { "saturation": -20 },
            { "lightness": 15 },
            { "gamma": 0.89 },
          ]
        }
      ]
    }
    styledMapType = new google.maps.StyledMapType(mapStyle.styles, { name: mapStyle.name })
    latLng = new google.maps.LatLng(lat, lon)
    map.setCenter(latLng)
    map.mapTypes.set(mapStyle.name, styledMapType)
    map.setMapTypeId(mapStyle.name)

    marker = new google.maps.Marker({
      position:  latLng,
      map:       map,
      draggable: false
    })
