class Device
        constructor: (pusher, device, member) ->
                @_member = member
                @renderMarker()
                @_deviceChannel = pusher.subscribe('private-device_'+device)
                @_deviceChannel.bind 'client-location', (data) =>
                        myPos = new google.maps.LatLng(data.latitude, data.longitude)
                        @setPosition(myPos)
                @_deviceChannel.bind 'client-bearing', (data) =>
                        @setRotation(data.bearing)

        setPosition: (newPos) =>
                @_position = newPos
                if(@_marker == undefined)
                        renderMarker()
                @_marker.setPosition(@_position)

        setRotation: (rotation) =>
                @_bearing = rotation
                renderMarker()

        renderMarker: =>
                if(@_marker != undefined)
                        @_marker.setMap(null)
                @_marker = new google.maps.Marker({
                        title: @_member.name,
                        map: map,
                        position: @_position,
                        icon: {
                                path: google.maps.SymbolPath.FORWARD_CLOSED_ARROW,
                        scale: 5,
                        rotation: @_bearing
                        }
                })
                infowindow = new google.maps.InfoWindow({
                        content: @_member.name
                })
                google.maps.event.addListener @_marker, 'click', ->
                        infowindow.open(map,this)

window.Device = Device
