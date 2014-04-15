class Device
        constructor: (pusher, device, member) ->
                @_member = member
                @_deviceChannel = pusher.subscribe('private-device_'+device)
                @_deviceChannel.bind 'client-location', (data) =>
                        myPos = new google.maps.LatLng(data.latitude, data.longitude)
                        @setPosition(myPos)
                @_deviceChannel.bind 'client-bearing', (data) =>
                        @setRotation(data.bearing)
                @renderMarker()

        setPosition: (newPos) =>
                @_position = newPos
                if(@_marker == undefined)
                        @renderMarker()
                @_marker.setPosition(@_position)

        setRotation: (rotation) =>
                @_bearing = rotation
                @renderMarker()

        renderMarker: =>
                if(@_marker != undefined)
                        @_marker.setMap(null)
                name = @_member.info.name
                @_marker = new google.maps.Marker({
                        title: name,
                        map: map,
                        position: @_position,
                        icon: {
                                path: google.maps.SymbolPath.FORWARD_CLOSED_ARROW,
                        scale: 5,
                        rotation: @_bearing
                        }
                })
                infowindow = new google.maps.InfoWindow({
                        content: name + "<br/>" + @_member.info.email
                })
                google.maps.event.addListener @_marker, 'click', ->
                        infowindow.open(map,this)

window.Device = Device
