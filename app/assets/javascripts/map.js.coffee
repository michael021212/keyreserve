$ ->
  #-----------------------------------------------
  # Map
  #-----------------------------------------------
  $('.google-map').each () ->
    geocoder = new (google.maps.Geocoder)
    lat = $(this).data('lat')
    lon = $(this).data('lon')
    name = $(this).data('name')
    address = $(this).data('address')
    url = "https://www.google.co.jp/maps/search/" + address

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

    contentString =
      '<div id="content">' +
      '<div id="siteNotice">' +
      "</div>" +
      "<div id='firstHeading' class='firstHeading'>#{name}</div>" +
      '<div id="bodyContent">' +
      "<div>#{address}</div>" +
      "<div><a href=#{url} target='_blank' rel='noopener'>Googleマップで見る</a></div>" +
      "</div>" +
      "</div>";

    infowindow = new (google.maps.InfoWindow)(content: contentString)
    marker = new (google.maps.Marker)(
      position: latLng
      map: map
      title: name)
    marker.addListener 'click', ->
      infowindow.open map, marker
    return
